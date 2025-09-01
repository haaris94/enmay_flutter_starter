import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enmay_flutter_starter/src/core/constants/enums/error_context.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/error_messages.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/crashlytics_client.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/failure.dart';
import 'package:enmay_flutter_starter/src/core/logging/console_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum ErrorSeverity { low, medium, high, critical }

class ErrorHandler {
  static final ConsoleLogger _logger = ConsoleLogger();
  static final CrashlyticsClient _crashlyticsClient = CrashlyticsClient();

  static Failure handle(
    Exception exception, {
    ErrorContext context = ErrorContext.unknown,
    StackTrace? stackTrace,
    Map<String, dynamic>? additionalData,
    bool isFatal = false,
  }) {
    final errorInfo = _classifyError(exception);

    _logToConsole(exception, context);
    _logToCrashlytics(
      exception,
      errorInfo.severity,
      context,
      stackTrace: stackTrace,
      additionalData: additionalData,
      isFatal: isFatal,
    );

    return _createFailure(errorInfo.type, context);
  }

  static ErrorInfo _classifyError(Exception exception) {
    if (exception is DioException) {
      return _handleDioException(exception);
    } else if (exception is FirebaseAuthException) {
      return _handleFirebaseAuthException(exception);
    } else if (exception is SocketException) {
      return ErrorInfo(ErrorType.network, ErrorSeverity.medium);
    } else if (exception is FormatException) {
      return ErrorInfo(ErrorType.validation, ErrorSeverity.low);
    }

    return ErrorInfo(ErrorType.unknown, ErrorSeverity.high);
  }

  static ErrorInfo _handleDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ErrorInfo(ErrorType.network, ErrorSeverity.medium);
      case DioExceptionType.badResponse:
        if (exception.response?.statusCode == 401) {
          return ErrorInfo(ErrorType.authentication, ErrorSeverity.high);
        }
        return ErrorInfo(ErrorType.externalApi, ErrorSeverity.medium);
      default:
        return ErrorInfo(ErrorType.network, ErrorSeverity.medium);
    }
  }

  static ErrorInfo _handleFirebaseAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
      case 'invalid-email':
        return ErrorInfo(ErrorType.authentication, ErrorSeverity.medium);
      case 'email-already-in-use':
        return ErrorInfo(ErrorType.authentication, ErrorSeverity.low);
      case 'email-not-verified':
        return ErrorInfo(ErrorType.emailNotVerified, ErrorSeverity.medium);
      case 'weak-password':
        return ErrorInfo(ErrorType.weakPassword, ErrorSeverity.low);
      case 'user-disabled':
        return ErrorInfo(ErrorType.userDisabled, ErrorSeverity.high);
      case 'too-many-requests':
        return ErrorInfo(ErrorType.tooManyRequests, ErrorSeverity.medium);
      case 'operation-not-allowed':
        return ErrorInfo(ErrorType.operationNotAllowed, ErrorSeverity.high);
      case 'requires-recent-login':
        return ErrorInfo(ErrorType.authentication, ErrorSeverity.medium);
      case 'provider-already-linked':
        return ErrorInfo(ErrorType.providerAlreadyLinked, ErrorSeverity.low);
      case 'credential-already-in-use':
        return ErrorInfo(ErrorType.authentication, ErrorSeverity.medium);
      default:
        return ErrorInfo(ErrorType.authentication, ErrorSeverity.high);
    }
  }

  static void _logToConsole(Exception exception, ErrorContext context) {
    _logger.error('[$context] ${exception.toString()}');
  }

  static void _logToCrashlytics(
    Exception exception,
    ErrorSeverity severity,
    ErrorContext context, {
    StackTrace? stackTrace,
    Map<String, dynamic>? additionalData,
    bool isFatal = false,
  }) {
    _crashlyticsClient.logError(
      exception: exception,
      severity: severity,
      context: context,
      stackTrace: stackTrace,
      additionalData: additionalData,
      isFatal: isFatal,
    );
  }

  static Failure _createFailure(ErrorType errorType, ErrorContext context) {
    final title = ErrorMessages.getTitle(errorType, context);
    final message = ErrorMessages.getMessage(errorType, context);

    return Failure(title: title, message: message, type: errorType);
  }

}

class ErrorInfo {
  final ErrorType type;
  final ErrorSeverity severity;

  ErrorInfo(this.type, this.severity);
}
