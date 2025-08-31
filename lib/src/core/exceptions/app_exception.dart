/// Base exception class for the application
///
/// All application-specific exceptions should extend this class
/// or be created through the factory constructors
class AppException implements Exception {
  final String message;
  final String code;
  final dynamic stackTrace;
  final dynamic originalException;
  final ExceptionSeverity severity;

  const AppException({
    required this.message,
    required this.code,
    this.stackTrace,
    this.originalException,
    this.severity = ExceptionSeverity.error,
  });

  /// Factory constructor for network-related errors
  factory AppException.network({
    String message = 'A network error occurred',
    String code = 'network_error',
    dynamic stackTrace,
    dynamic originalException,
  }) {
    return AppException(
      message: message,
      code: code,
      stackTrace: stackTrace,
      originalException: originalException,
      severity: ExceptionSeverity.error,
    );
  }

  /// Factory constructor for authentication errors
  factory AppException.authentication({
    String message = 'Authentication failed',
    String code = 'auth_error',
    dynamic stackTrace,
    dynamic originalException,
  }) {
    return AppException(
      message: message,
      code: code,
      stackTrace: stackTrace,
      originalException: originalException,
      severity: ExceptionSeverity.error,
    );
  }

  /// Factory constructor for server errors
  factory AppException.server({
    String message = 'Server error occurred',
    String code = 'server_error',
    dynamic stackTrace,
    dynamic originalException,
  }) {
    return AppException(
      message: message,
      code: code,
      stackTrace: stackTrace,
      originalException: originalException,
      severity: ExceptionSeverity.error,
    );
  }

  /// Factory constructor for data validation errors
  factory AppException.validation({
    String message = 'Data validation failed',
    String code = 'validation_error',
    dynamic stackTrace,
    dynamic originalException,
  }) {
    return AppException(
      message: message,
      code: code,
      stackTrace: stackTrace,
      originalException: originalException,
      severity: ExceptionSeverity.warning,
    );
  }

  /// Factory constructor for permission errors
  factory AppException.permission({
    String message = 'Permission denied',
    String code = 'permission_error',
    dynamic stackTrace,
    dynamic originalException,
  }) {
    return AppException(
      message: message,
      code: code,
      stackTrace: stackTrace,
      originalException: originalException,
      severity: ExceptionSeverity.error,
    );
  }

  /// Factory constructor for unknown/unexpected errors
  factory AppException.unknown({
    String message = 'An unexpected error occurred',
    String code = 'unknown_error',
    dynamic stackTrace,
    dynamic originalException,
  }) {
    return AppException(
      message: message,
      code: code,
      stackTrace: stackTrace,
      originalException: originalException,
      severity: ExceptionSeverity.critical,
    );
  }

  /// Check if this exception is of a specific type based on code prefix
  bool isExceptionType(String codePrefix) {
    return code.startsWith(codePrefix);
  }

  @override
  String toString() {
    return 'AppException(message: $message, code: $code, severity: $severity)';
  }
}

/// Enum representing the severity of an exception
enum ExceptionSeverity {
  /// Informational only, doesn't affect functionality
  info,

  /// Minor issue that doesn't block core functionality
  warning,

  /// Significant error that affects some functionality
  error,

  /// Critical error that prevents core functionality
  critical,
}
