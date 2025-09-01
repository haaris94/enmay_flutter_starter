import 'dart:collection';

import 'package:enmay_flutter_starter/src/core/constants/enums/error_context.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/error_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CrashlyticsClient {
  static final CrashlyticsClient _instance = CrashlyticsClient._internal();
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;
  
  static const int _maxRecentErrors = 10;
  static const Duration _rateLimitWindow = Duration(minutes: 5);
  
  final Queue<_ErrorRecord> _recentErrors = Queue<_ErrorRecord>();
  PackageInfo? _packageInfo;

  factory CrashlyticsClient() => _instance;
  
  CrashlyticsClient._internal();

  Future<void> logError({
    required Exception exception,
    required ErrorSeverity severity,
    required ErrorContext context,
    StackTrace? stackTrace,
    Map<String, dynamic>? additionalData,
    bool isFatal = false,
  }) async {
    if (!_shouldLogToCrashlytics(severity, exception)) {
      return;
    }

    if (_isRateLimited(exception)) {
      return;
    }

    _recordError(exception);

    await _setUserContext();
    await _setCustomKeys(severity, context, additionalData);
    
    if (isFatal) {
      await _crashlytics.recordFlutterFatalError(
        FlutterErrorDetails(
          exception: exception,
          stack: stackTrace ?? StackTrace.current,
          context: ErrorDescription('Fatal error in context: $context'),
        ),
      );
    } else {
      await _crashlytics.recordError(
        exception,
        stackTrace ?? StackTrace.current,
        fatal: false,
        information: _buildInformationList(context, severity, additionalData),
      );
    }
  }

  bool _shouldLogToCrashlytics(ErrorSeverity severity, Exception exception) {
    switch (severity) {
      case ErrorSeverity.critical:
        return true;
      case ErrorSeverity.high:
        return true;
      case ErrorSeverity.medium:
        return exception is FirebaseAuthException;
      case ErrorSeverity.low:
        return false;
    }
  }

  bool _isRateLimited(Exception exception) {
    final now = DateTime.now();
    final exceptionKey = exception.runtimeType.toString() + exception.toString().hashCode.toString();
    
    final recentSimilar = _recentErrors.where((record) {
      return record.exceptionKey == exceptionKey &&
        now.difference(record.timestamp) < _rateLimitWindow;
    });
    
    return recentSimilar.length >= 3;
  }

  void _recordError(Exception exception) {
    final exceptionKey = exception.runtimeType.toString() + exception.toString().hashCode.toString();
    _recentErrors.add(_ErrorRecord(exceptionKey, DateTime.now()));
    
    while (_recentErrors.length > _maxRecentErrors) {
      _recentErrors.removeFirst();
    }
  }

  Future<void> _setUserContext() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _crashlytics.setUserIdentifier(user.uid);
      await _crashlytics.setCustomKey('user_authenticated', true);
      await _crashlytics.setCustomKey('email_verified', user.emailVerified);
    } else {
      await _crashlytics.setCustomKey('user_authenticated', false);
    }
  }

  Future<void> _setCustomKeys(
    ErrorSeverity severity,
    ErrorContext context,
    Map<String, dynamic>? additionalData,
  ) async {
    await _crashlytics.setCustomKey('error_severity', severity.name);
    await _crashlytics.setCustomKey('error_context', context.name);
    
    final appVersion = await _getAppVersion();
    await _crashlytics.setCustomKey('app_version', appVersion);
    await _crashlytics.setCustomKey('build_number', await _getBuildNumber());
    
    if (additionalData != null) {
      for (final entry in additionalData.entries) {
        await _crashlytics.setCustomKey('custom_${entry.key}', entry.value.toString());
      }
    }
  }

  Future<String> _getAppVersion() async {
    _packageInfo ??= await PackageInfo.fromPlatform();
    return _packageInfo!.version;
  }

  Future<String> _getBuildNumber() async {
    _packageInfo ??= await PackageInfo.fromPlatform();
    return _packageInfo!.buildNumber;
  }

  List<String> _buildInformationList(
    ErrorContext context,
    ErrorSeverity severity,
    Map<String, dynamic>? additionalData,
  ) {
    final info = <String>[
      'Context: $context',
      'Severity: $severity',
      'Timestamp: ${DateTime.now().toIso8601String()}',
    ];

    if (additionalData != null) {
      for (final entry in additionalData.entries) {
        info.add('${entry.key}: ${entry.value}');
      }
    }

    return info;
  }

  Future<void> setUserId(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  Future<void> setBool(String key, bool value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  Future<void> setString(String key, String value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  Future<void> setInt(String key, int value) async {
    await _crashlytics.setCustomKey(key, value);
  }
}

class _ErrorRecord {
  final String exceptionKey;
  final DateTime timestamp;

  _ErrorRecord(this.exceptionKey, this.timestamp);
}