# Error Handling Strategy

This document outlines the standardized approach to error handling within this Flutter project. The goal is to ensure consistency, provide meaningful feedback to the user, facilitate debugging, and enable robust error reporting.

## Core Concepts

1. **`Failure` (`lib/core/error/failures.dart`):**

    - Represents **handled, known error scenarios** that the application logic anticipates (e.g., network unavailable, invalid user input, resource not found).
    - These are **not** raw exceptions but specific classes indicating _why_ an operation failed in a business-logic sense.
    - They are intended to be caught and processed by the presentation layer (Bloc/Cubit) to update the UI state appropriately.
    - Each `Failure` subclass (e.g., `ServerFailure`, `CacheFailure`, `NetworkFailure`, `ValidationFailure`, `AuthenticationFailure`) contains logic (`getUserFriendlyMessage`) to provide a user-facing, localized message.
    - Returned by Repositories using `Either<Failure, SuccessType>`.

2. **`DataSourceException` (`lib/core/error/exceptions.dart`):**

    - Represents **lower-level exceptions** originating from data sources (network client, local database, external SDKs).
    - Examples: `ServerException` (for HTTP errors), `CacheException` (for database errors), `AuthenticationException` (for auth provider errors), `PermissionDeniedException`.
    - These are **thrown** by data source implementations.
    - They are **caught** within the Repository layer and **mapped** to corresponding `Failure` types. They generally should _not_ leak beyond the data layer.

3. **`Either<L, R>` (from `dartz` package):**

    - A functional programming type used to represent a value that can be one of two types: `Left` (typically used for errors/failures) or `Right` (typically used for success values).
    - Repositories return `Future<Either<Failure, SuccessType>>`. This makes it explicit that an operation can either fail (returning a `Failure`) or succeed (returning the expected data).
    - This avoids throwing exceptions for handled error cases across layer boundaries and encourages explicit error handling in the presentation layer.

4. **Unhandled Exceptions:**
    - These are unexpected errors (runtime errors, programming bugs) that are not caught by the standard `try-catch` blocks in the repositories.
    - These should be caught by a global error handler (e.g., using `runZonedGuarded`) and reported to an error tracking service (like Sentry or Firebase Crashlytics).

## Error Handling Flow

The typical flow for handling errors originating from data operations is:

1. **Data Source:** An operation fails (e.g., network request returns 401, database query fails). The data source implementation **throws** a specific `DataSourceException` (e.g., `AuthenticationException`, `CacheException`).
2. **Repository:** The repository method calling the data source is wrapped in a `try-catch` block.
    - It **catches** specific `DataSourceException` subtypes and maps them to corresponding `Failure` types (e.g., `catch (e) { return Left(AuthenticationFailure()); }`).
    - It **catches** generic `Exception`s and maps them to `UnexpectedFailure` to handle unforeseen issues gracefully (`catch (e, s) { return Left(UnexpectedFailure(originalException: e, stackTrace: s)); }`).
    - On success, it wraps the result in `Right`.
    - The method returns `Future<Either<Failure, SuccessType>>`.
3. **Use Case (Optional):** If using Use Cases, they typically just forward the `Either` result from the repository.
4. **Presentation (Bloc/Cubit):**
    - Calls the repository (or use case) method.
    - Uses the `.fold( (failure) => ..., (successData) => ... )` method on the returned `Either`.
    - If `Left(failure)`: Emits an error state containing the `Failure` object (e.g., `AuthState.error(failure)`).
    - If `Right(successData)`: Emits a success state with the data (e.g., `AuthState.authenticated(user)`).
5. **UI (Widget):**
    - Listens to the Bloc/Cubit state using `BlocListener` or `BlocBuilder`.
    - When an error state is detected, it extracts the `Failure` object.
    - Calls `failure.getUserFriendlyMessage(context)` to get the appropriate localized message.
    - Displays the message to the user (e.g., using a `SnackBar`, `AlertDialog`, or inline text).
6. **Localization:** The `getUserFriendlyMessage` method within each `Failure` class (or a helper/extension) looks up the appropriate localized string based on the `Failure` type and the current locale.

## Implementing Error Handling in a New Module (Example: Auth Feature)

Let's add a `signInWithEmail` functionality to an `Auth` feature following this pattern.

**1. Define Data Source Contract (`lib/features/auth/data/datasources/auth_remote_data_source.dart`)**

```dart
import 'package:enmay_flutter_starter/data/models/user_model.dart'; // Example

abstract class AuthRemoteDataSource {
  /// Signs in using email and password.
  /// Throws [AuthenticationException] for invalid credentials or other auth errors.
  /// Throws [ServerException] for network or server issues.
  Future<UserModel> signInWithEmail({required String email, required String password});
}
```

**2. Implement Data Source (`lib/features/auth/data/implementations/auth_remote_data_source_impl.dart`)**

```dart
import 'package:dio/dio.dart'; // Example network client
import 'package:enmay_flutter_starter/core/error/exceptions.dart';
import 'package:enmay_flutter_starter/data/models/user_model.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dioClient; // Assume Dio is setup and injected

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> signInWithEmail({required String email, required String password}) async {
    try {
      final response = await dioClient.post(
        '/auth/login', // Your API endpoint
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        // Assume response.data contains user JSON
        return UserModel.fromJson(response.data['user']);
      } else {
        // Handle non-200 status codes that Dio doesn't throw by default
        throw ServerException(
          message: response.data['message'] ?? 'Unknown server error',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthenticationException(
          message: e.response?.data['message'] ?? 'Invalid credentials',
          originalException: e,
        );
      } else {
        // Handle other Dio errors (timeout, connection error, 5xx, etc.)
        throw ServerException(
          message: e.message ?? 'Network request failed',
          statusCode: e.response?.statusCode,
          originalException: e,
        );
      }
    } catch (e) {
      // Catch any other unexpected errors
      throw ServerException(message: 'An unexpected error occurred during sign in', originalException: e);
    }
  }
}
```

**3. Define Repository Contract (`lib/features/auth/data/repositories/auth_repository.dart`)**

```dart
import 'package:dartz/dartz.dart';
import 'package:enmay_flutter_starter/core/error/failures.dart';
import 'package:enmay_flutter_starter/data/models/user_model.dart'; // Or a domain entity

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> signInWithEmail({required String email, required String password});
}

```

**4. Implement Repository (`lib/features/auth/data/repositories/auth_repository_impl.dart`)**

```dart
import 'package:dartz/dartz.dart';
import 'package:enmay_flutter_starter/core/error/exceptions.dart';
import 'package:enmay_flutter_starter/core/error/failures.dart';
import 'package:enmay_flutter_starter/data/models/user_model.dart';
// Assume a network info check exists: import 'package:enmay_flutter_starter/core/network/network_info.dart';
import '../datasources/auth_remote_data_source.dart';
import './auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  // final NetworkInfo networkInfo; // Optional: Check connectivity first

  AuthRepositoryImpl({
    required this.remoteDataSource,
    // required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserModel>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // Optional: Check network connectivity
    // if (!await networkInfo.isConnected) {
    //   return Left(NetworkFailure());
    // }

    try {
      final userModel = await remoteDataSource.signInWithEmail(email: email, password: password);
      // Potential mapping from UserModel to a domain User entity here
      return Right(userModel);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message, originalException: e));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode, originalException: e));
    } on Exception catch (e, s) {
      // Catch-all for unexpected errors during the process
      // Log this error for debugging
      print('Unexpected error in AuthRepository: $e $s');
      return Left(UnexpectedFailure(originalException: e, stackTrace: s));
    }
  }
}

```

**5. Implement Bloc/Cubit (`lib/features/auth/presentation/cubit/auth_cubit.dart`)**

```dart
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:enmay_flutter_starter/core/error/failures.dart';
import 'package:enmay_flutter_starter/data/models/user_model.dart'; // Or domain entity
import '../../data/repositories/auth_repository.dart'; // Use contract

part 'auth_state.dart'; // Define your states (Initial, Loading, Authenticated, Error)

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    final failureOrUser = await authRepository.signInWithEmail(
      email: email,
      password: password,
    );

    failureOrUser.fold(
      (failure) => emit(AuthError(failure: failure)), // Emit error state with Failure
      (user) => emit(Authenticated(user: user)), // Emit success state with User
    );
  }
}
```

**6. Implement UI (`lib/features/auth/presentation/screens/login_screen.dart`)**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart'; // Import Cubit & State

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            // --- Error Handling ---
            final snackBar = SnackBar(
              content: Text(state.failure.getUserFriendlyMessage(context)), // Get localized message
              backgroundColor: Colors.red,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // --- End Error Handling ---
          } else if (state is Authenticated) {
            // Navigate to home screen or show success
            // Example: Navigator.of(context).pushReplacementNamed('/home');
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Login Successful!'),
              backgroundColor: Colors.green,
            ));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
              TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: 'Password')),
              SizedBox(height: 20),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      context.read<AuthCubit>().signIn(
                            _emailController.text,
                            _passwordController.text,
                          );
                    },
                    child: Text('Sign In'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**7. Add Localized Strings (`assets/translations/en.json`)**

You would need to have your localization setup (`flutter_localizations`, `easy_localization`, etc.). The `getUserFriendlyMessage` in `Failure` classes would use this.

```json
{
  "serverError": "Failed to communicate with the server. Please check your connection or try again later.",
  "cacheError": "Failed to load data from local storage. Please try again.",
  "networkError": "No internet connection. Please check your network settings.",
  "validationError": "The information provided is invalid. Please check and try again.",
  "authenticationError": "Authentication failed. Please check your credentials or try logging in again.",
  "permissionDenied": "Access denied. The app needs {permission} to function correctly.",
  "permissionDeniedDefault": "Access denied. The app needs a required permission to function correctly.",
  "unexpectedError": "An unexpected error occurred. Please try again later or contact support."
}
```

Modify `Failure.getUserFriendlyMessage` implementations to use `AppLocalizations.of(context)!.yourErrorKey`.

## Error Reporting (Sentry/Crashlytics)

Unhandled exceptions (those not caught and converted to `Failure` by repositories) should be reported.

1. **Add Dependency:** Add `sentry_flutter` or `firebase_crashlytics` to `pubspec.yaml`.
2. **Initialization:** In `main_*.dart`, wrap `runApp` with `runZonedGuarded` and initialize the reporting SDK.

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart'; // Example

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await SentryFlutter.init(
      (options) {
        options.dsn = 'YOUR_SENTRY_DSN'; // Replace with your DSN
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 1.0;
        // Consider adding environment, release versions etc.
      },
    );

    // --- Your regular app initialization ---
    // setupDependencies(); // Setup GetIt/Riverpod
    // runApp(MyApp());
    // --- End initialization ---

  }, (exception, stackTrace) async {
    // This catches Dart errors and unhandled async errors
    await Sentry.captureException(exception, stackTrace: stackTrace);
  });

  // Catch Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) async {
     await Sentry.captureException(details.exception, stackTrace: details.stack);
  };

   // Catch platform channel errors (might need specific setup)
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   Sentry.captureException(error, stackTrace: stack);
  //   return true; // Indicates error was handled
  // };
}
```

- **Reporting Handled Failures (Optional):** You might choose to explicitly report certain `Failure` types (like `ServerFailure` or `UnexpectedFailure`) to your reporting service from the Bloc/Cubit or Repository for more insight, even though they are "handled".

This comprehensive strategy ensures errors are managed predictably, users receive clear feedback, and critical issues are logged for developers.
