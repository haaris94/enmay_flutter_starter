import 'dart:convert';

import 'package:enmay_flutter_starter/src/core/constants/enums/error_context.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/failure.dart';
import 'package:flutter/services.dart';

class ErrorMessages {
  static Map<String, dynamic>? _messages;

  static Future<void> initialize(String language) async {
    final jsonString = await rootBundle.loadString('assets/error_messages/$language.json');
    _messages = json.decode(jsonString);
  }

  static String getTitle(ErrorType errorType, ErrorContext context) {
    return _messages?[errorType.name]?[context.name]?['title'] ??
        _messages?[errorType.name]?['fallback']?['title'] ??
        'Something went wrong';
  }

  static String getMessage(ErrorType errorType, ErrorContext context) {
    return _messages?[errorType.name]?[context.name]?['message'] ??
        _messages?[errorType.name]?['fallback']?['message'] ??
        'Please try again later';
  }
}
