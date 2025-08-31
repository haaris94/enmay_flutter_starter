import 'package:enmay_flutter_starter/src/core/constants/enums/error_context.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/error_handler.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:google_sign_in/google_sign_in.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepository();

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;
  String? get displayName => _auth.currentUser?.displayName;
  String? get email => _auth.currentUser?.email;
  String? get photoURL => _auth.currentUser?.photoURL;
  bool get isSignedIn => _auth.currentUser != null;

  Future<User> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw const Failure(
          title: 'Sign In Failed',
          message: 'Unable to sign in at this time',
          type: ErrorType.authentication,
        );
      }

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      final failure = ErrorHandler.handle(e, context: ErrorContext.login);
      throw failure;
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.login,
      );
      throw failure;
    }
  }

  Future<User> registerWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const Failure(
          title: 'Registration Failed',
          message: 'Unable to create account at this time',
          type: ErrorType.authentication,
        );
      }

      // Send email verification
      await credential.user!.sendEmailVerification();

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      final failure = ErrorHandler.handle(e, context: ErrorContext.register);
      throw failure;
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.register,
      );
      throw failure;
    }
  }

  // Google Sign In - TODO: Implement when Google Sign In package is properly configured
  // Future<User> signInWithGoogle() async {
  //   try {
  //     // Trigger the authentication flow
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     
  //     if (googleUser == null) {
  //       throw const Failure(
  //         title: 'Google Sign In Cancelled',
  //         message: 'Sign in was cancelled by user',
  //         type: ErrorType.authentication,
  //       );
  //     }

  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //     
  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // Sign in to Firebase with the credential
  //     final userCredential = await _auth.signInWithCredential(credential);
  //     
  //     if (userCredential.user == null) {
  //       throw const Failure(
  //         title: 'Google Sign In Failed',
  //         message: 'Unable to sign in with Google',
  //         type: ErrorType.authentication,
  //       );
  //     }

  //     return userCredential.user!;
  //   } on FirebaseAuthException catch (e) {
  //     final failure = ErrorHandler.handle(e, context: ErrorContext.googleSignIn);
  //     throw failure;
  //   } catch (e) {
  //     final failure = ErrorHandler.handle(
  //       Exception(e.toString()),
  //       context: ErrorContext.googleSignIn,
  //     );
  //     throw failure;
  //   }
  // }


  // Password Reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      final failure = ErrorHandler.handle(e, context: ErrorContext.forgotPassword);
      throw failure;
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.forgotPassword,
      );
      throw failure;
    }
  }

  // Email Verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const Failure(
          title: 'No User Found',
          message: 'Please sign in to verify your email',
          type: ErrorType.authentication,
        );
      }

      if (user.emailVerified) {
        throw const Failure(
          title: 'Email Already Verified',
          message: 'Your email is already verified',
          type: ErrorType.validation,
        );
      }

      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      final failure = ErrorHandler.handle(e, context: ErrorContext.sendEmailVerification);
      throw failure;
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.sendEmailVerification,
      );
      throw failure;
    }
  }

  Future<bool> reloadAndCheckEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await user.reload();
      return _auth.currentUser?.emailVerified ?? false;
    } on FirebaseAuthException catch (e) {
      final failure = ErrorHandler.handle(e, context: ErrorContext.verifyEmail);
      throw failure;
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.verifyEmail,
      );
      throw failure;
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const Failure(
          title: 'No User Found',
          message: 'Please sign in to update your email',
          type: ErrorType.authentication,
        );
      }

      await user.verifyBeforeUpdateEmail(newEmail);
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      final failure = ErrorHandler.handle(e, context: ErrorContext.updateEmail);
      throw failure;
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.updateEmail,
      );
      throw failure;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const Failure(
          title: 'No User Found',
          message: 'Please sign in to update your password',
          type: ErrorType.authentication,
        );
      }

      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      final failure = ErrorHandler.handle(e, context: ErrorContext.updatePassword);
      throw failure;
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.updatePassword,
      );
      throw failure;
    }
  }

  Future<void> reauthenticateWithEmail(String password) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw const Failure(
          title: 'No User Found',
          message: 'Please sign in to continue',
          type: ErrorType.authentication,
        );
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      final failure = ErrorHandler.handle(e, context: ErrorContext.reauthenticate);
      throw failure;
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.reauthenticate,
      );
      throw failure;
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const Failure(
          title: 'No User Found',
          message: 'Please sign in to delete your account',
          type: ErrorType.authentication,
        );
      }

      await user.delete();
    } on FirebaseAuthException catch (e) {
      final failure = ErrorHandler.handle(e, context: ErrorContext.deleteAccount);
      throw failure;
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.deleteAccount,
      );
      throw failure;
    }
  }

  // Link Google Provider - TODO: Implement when Google Sign In package is properly configured
  // Future<User> linkWithGoogle() async {
  //   try {
  //     final user = _auth.currentUser;
  //     if (user == null) {
  //       throw const Failure(
  //         title: 'No User Found',
  //         message: 'Please sign in to link accounts',
  //         type: ErrorType.authentication,
  //       );
  //     }

  //     // Trigger the authentication flow
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     
  //     if (googleUser == null) {
  //       throw const Failure(
  //         title: 'Google Sign In Cancelled',
  //         message: 'Account linking was cancelled',
  //         type: ErrorType.authentication,
  //       );
  //     }

  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //     
  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // Link the credential to the current user
  //     final userCredential = await user.linkWithCredential(credential);
  //     
  //     if (userCredential.user == null) {
  //       throw const Failure(
  //         title: 'Account Linking Failed',
  //         message: 'Unable to link Google account',
  //         type: ErrorType.authentication,
  //       );
  //     }

  //     return userCredential.user!;
  //   } on FirebaseAuthException catch (e) {
  //     final failure = ErrorHandler.handle(e, context: ErrorContext.linkProvider);
  //     throw failure;
  //   } catch (e) {
  //     final failure = ErrorHandler.handle(
  //       Exception(e.toString()),
  //       context: ErrorContext.linkProvider,
  //     );
  //     throw failure;
  //   }
  // }


  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // await _googleSignIn.signOut(); // TODO: Uncomment when Google Sign In is configured
    } on FirebaseAuthException catch (e) {
      final failure = ErrorHandler.handle(e, context: ErrorContext.logout);
      throw failure;
    } catch (e) {
      final failure = ErrorHandler.handle(
        Exception(e.toString()),
        context: ErrorContext.logout,
      );
      throw failure;
    }
  }
}
