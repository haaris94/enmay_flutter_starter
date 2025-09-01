import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'console_logger.g.dart';

@riverpod
ConsoleLogger consoleLogger(Ref ref) => ConsoleLogger();

class ConsoleLogger {
  late final Logger _logger;

  ConsoleLogger() {
    _logger = Logger(
      printer: MinimalistPrinter(),
      output: ConsoleOutput(),
    );
  }

  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void wtf(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}

class MinimalistPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final level = _getLevelPrefix(event.level);
    final message = event.message;
    final error = event.error != null ? ' | ${event.error}' : '';
    
    return ['$level $message$error'];
  }

  String _getLevelPrefix(Level level) {
    switch (level) {
      case Level.debug:
        return '🐛';
      case Level.info:
        return 'ℹ️';
      case Level.warning:
        return '⚠️';
      case Level.error:
        return '❌';
      case Level.fatal:
        return '💀';
      default:
        return '📝';
    }
  }
}