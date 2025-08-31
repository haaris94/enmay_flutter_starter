import 'package:equatable/equatable.dart';

/// Base class for all Failures in the application.
/// 
/// Failures represent expected error scenarios that can be handled gracefully.
/// They are typically returned by Repositories and handled in the presentation layer.
/// Each failure type should provide a user-friendly message through [getUserFriendlyMessage].
abstract class Failure extends Equatable {
  final String? message;
  final dynamic originalException;
  final StackTrace? stackTrace;

  const Failure({this.message, this.originalException, this.stackTrace});

  /// Returns a localized, user-friendly error message.
  /// Override this in subclasses to provide specific messages.
  String getUserFriendlyMessage(context) {
    return 'An unexpected error occurred. Please try again.';
  }

  @override
  List<Object?> get props => [message, originalException, stackTrace];

  @override
  String toString() {
    return '$runtimeType: ${message ?? 'No message'}. Original Exception: ${originalException?.toString()}';
  }
}

/// Server-side failures (5xx errors, timeouts)
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({super.message, this.statusCode, super.originalException, super.stackTrace});

  @override
  String getUserFriendlyMessage(context) {
    return 'Failed to communicate with the server. Please check your connection or try again later.';
  }

  @override
  List<Object?> get props => super.props..add(statusCode);
}

/// Local storage/cache failures
class CacheFailure extends Failure {
  const CacheFailure({super.message, super.originalException, super.stackTrace});

  @override
  String getUserFriendlyMessage(context) {
    return 'Failed to load data from local storage. Please try again.';
  }
}

/// Network connectivity failures
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection detected.', super.originalException, super.stackTrace});

  @override
  String getUserFriendlyMessage(context) {
    return 'No internet connection. Please check your network settings.';
  }
}

/// Input validation failures
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    super.message = 'Invalid input data.',
    this.fieldErrors,
    super.originalException,
    super.stackTrace,
  });

  @override
  String getUserFriendlyMessage(context) {
    return message ?? 'The information provided is invalid. Please check and try again.';
  }

  @override
  List<Object?> get props => super.props..add(fieldErrors);
}

/// Permission-related failures
class PermissionFailure extends Failure {
  final String? permission;

  const PermissionFailure({
    super.message = 'Permission denied.',
    this.permission,
    super.originalException,
    super.stackTrace,
  });

  @override
  String getUserFriendlyMessage(context) {
    final perm = permission ?? 'a required permission';
    return 'Access denied. The app needs $perm to function correctly.';
  }

  @override
  List<Object?> get props => super.props..add(permission);
}

/// Authentication failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({super.message = 'Authentication failed.', super.originalException, super.stackTrace});

  @override
  String getUserFriendlyMessage(context) {
    return 'Authentication failed. Please check your credentials or try logging in again.';
  }
}

/// Generic unexpected failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'An unexpected error occurred.', super.originalException, super.stackTrace});

  @override
  String getUserFriendlyMessage(context) {
    return 'An unexpected error occurred. Please try again later or contact support.';
  }
}
