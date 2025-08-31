import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enmay_flutter_starter/src/core/constants/enums/error_context.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/error_messages.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

enum ErrorSeverity { low, medium, high, critical }

class ErrorHandler {
  static final Logger _logger = Logger();

  static Failure handle(Exception exception, {ErrorContext context = ErrorContext.unknown}) {
    final errorInfo = _classifyError(exception);

    _logToConsole(exception, context);
    _logToCrashlytics(exception, errorInfo.severity, context);

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
    return ErrorInfo(ErrorType.authentication, ErrorSeverity.high);
  }

  static void _logToConsole(Exception exception, ErrorContext context) {
    _logger.e('[$context] ${exception.toString()}');
  }

  static void _logToCrashlytics(Exception exception, ErrorSeverity severity, ErrorContext context) {
    if (severity == ErrorSeverity.high || severity == ErrorSeverity.critical) {
      FirebaseCrashlytics.instance.recordError(
        exception,
        StackTrace.current,
        information: ['Context: $context', 'Severity: $severity'],
      );
    }
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
