import 'dart:convert';

import 'package:enmay_flutter_starter/src/core/exceptions/error_handler.dart';
import 'package:enmay_flutter_starter/src/core/constants/enums/error_context.dart';
import 'package:enmay_flutter_starter/src/features/review/data/models/review_data.dart';
import 'package:enmay_flutter_starter/src/features/review/data/models/review_options.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'review_repository.g.dart';

@Riverpod(keepAlive: true)
ReviewRepository reviewRepository(Ref ref) {
  throw UnimplementedError('ReviewRepository provider must be overridden');
}

class ReviewRepository {
  ReviewRepository({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const String _reviewDataKey = 'app_review_data';
  static const String _reviewOptionsKey = 'app_review_options';

  /// Load review data from storage
  Future<ReviewData> getReviewData() async {
    try {
      final jsonString = _prefs.getString(_reviewDataKey);
      if (jsonString == null) {
        return ReviewData.initial();
      }

      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return ReviewData.fromJson(jsonData);
    } catch (exception, stackTrace) {
      ErrorHandler.handle(
        Exception('Failed to load review data: $exception'),
        context: ErrorContext.dataLoading,
        stackTrace: stackTrace,
      );
      
      // Return initial data as fallback
      return ReviewData.initial();
    }
  }

  /// Save review data to storage
  Future<void> saveReviewData(ReviewData data) async {
    try {
      final jsonString = json.encode(data.toJson());
      await _prefs.setString(_reviewDataKey, jsonString);
    } catch (exception, stackTrace) {
      final failure = ErrorHandler.handle(
        Exception('Failed to save review data: $exception'),
        context: ErrorContext.dataSaving,
        stackTrace: stackTrace,
      );
      // Re-throw as this is critical functionality
      throw failure;
    }
  }

  /// Load review options from storage
  Future<ReviewOptions> getReviewOptions() async {
    try {
      final jsonString = _prefs.getString(_reviewOptionsKey);
      if (jsonString == null) {
        return ReviewOptions.defaultOptions;
      }

      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return ReviewOptions.fromJson(jsonData);
    } catch (exception, stackTrace) {
      ErrorHandler.handle(
        Exception('Failed to load review options: $exception'),
        context: ErrorContext.dataLoading,
        stackTrace: stackTrace,
      );
      
      // Return default options as fallback
      return ReviewOptions.defaultOptions;
    }
  }

  /// Save review options to storage
  Future<void> saveReviewOptions(ReviewOptions options) async {
    try {
      final jsonString = json.encode(options.toJson());
      await _prefs.setString(_reviewOptionsKey, jsonString);
    } catch (exception, stackTrace) {
      final failure = ErrorHandler.handle(
        Exception('Failed to save review options: $exception'),
        context: ErrorContext.dataSaving,
        stackTrace: stackTrace,
      );
      // Re-throw as this is critical functionality
      throw failure;
    }
  }

  /// Clear all review data (useful for testing or reset)
  Future<void> clearReviewData() async {
    try {
      await _prefs.remove(_reviewDataKey);
      await _prefs.remove(_reviewOptionsKey);
    } catch (exception, stackTrace) {
      ErrorHandler.handle(
        Exception('Failed to clear review data: $exception'),
        context: ErrorContext.dataDeletion,
        stackTrace: stackTrace,
      );
    }
  }

  /// Check if review system has been initialized
  bool get isInitialized {
    return _prefs.containsKey(_reviewDataKey);
  }

  /// Get raw storage data for debugging
  Map<String, dynamic>? getDebugData() {
    try {
      final reviewDataJson = _prefs.getString(_reviewDataKey);
      final reviewOptionsJson = _prefs.getString(_reviewOptionsKey);
      
      return {
        'reviewData': reviewDataJson != null ? json.decode(reviewDataJson) : null,
        'reviewOptions': reviewOptionsJson != null ? json.decode(reviewOptionsJson) : null,
        'isInitialized': isInitialized,
      };
    } catch (exception, stackTrace) {
      ErrorHandler.handle(
        Exception('Failed to get debug data: $exception'),
        context: ErrorContext.dataLoading,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}