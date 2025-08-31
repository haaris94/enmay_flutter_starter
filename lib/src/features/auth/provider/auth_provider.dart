import 'package:enmay_flutter_starter/src/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
Stream<User?> authStateChanges(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<User?> build() async {
    final authRepository = ref.watch(authRepositoryProvider);
    return authRepository.currentUser;
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      final user = await authRepository.signInWithEmail(email, password);
      return user;
    });
  }

  Future<void> registerWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      final user = await authRepository.registerWithEmail(email, password);
      return user;
    });
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.sendPasswordResetEmail(email);
  }

  Future<void> sendEmailVerification() async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.sendEmailVerification();
  }

  Future<bool> reloadAndCheckEmailVerification() async {
    final authRepository = ref.read(authRepositoryProvider);
    return await authRepository.reloadAndCheckEmailVerification();
  }

  Future<void> updateEmail(String newEmail) async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.updateEmail(newEmail);
  }

  Future<void> updatePassword(String newPassword) async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.updatePassword(newPassword);
  }

  Future<void> reauthenticateWithEmail(String password) async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.reauthenticateWithEmail(password);
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.deleteAccount();
      return null;
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signOut();
      return null;
    });
  }
}
