import 'package:enmay_flutter_starter/src/core/exceptions/error_handler.dart';
import 'package:enmay_flutter_starter/src/core/constants/enums/error_context.dart';
import 'package:enmay_flutter_starter/src/core/logging/console_logger.dart';
import 'package:enmay_flutter_starter/src/features/review/data/models/review_data.dart';
import 'package:enmay_flutter_starter/src/features/review/data/models/review_options.dart';
import 'package:enmay_flutter_starter/src/features/review/data/repositories/review_repository.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_service.g.dart';

enum ReviewAction { rateNow, later, dontAskAgain }

@Riverpod(keepAlive: true)
ReviewService reviewService(ref) {
  final repository = ref.watch(reviewRepositoryProvider);
  return ReviewService(repository: repository);
}

class ReviewService {
  ReviewService({
    required ReviewRepository repository,
    InAppReview? inAppReview,
    ConsoleLogger? logger,
  })  : _repository = repository,
        _inAppReview = inAppReview ?? InAppReview.instance,
        _logger = logger ?? ConsoleLogger();

  final ReviewRepository _repository;
  final InAppReview _inAppReview;
  final ConsoleLogger _logger;

  ReviewData? _cachedData;
  ReviewOptions? _cachedOptions;

  /// Initialize the review service with options
  static Future<ReviewService> create({
    required ReviewRepository repository,
    ReviewOptions options = ReviewOptions.defaultOptions,
    InAppReview? inAppReview,
    ConsoleLogger? logger,
  }) async {
    final service = ReviewService(
      repository: repository,
      inAppReview: inAppReview,
      logger: logger,
    );
    
    // Save initial options if not already saved
    await service._initializeOptions(options);
    return service;
  }

  /// Initialize with default or provided options
  Future<void> _initializeOptions(ReviewOptions options) async {
    try {
      if (!_repository.isInitialized) {
        await _repository.saveReviewOptions(options);
        _cachedOptions = options;
      }
    } catch (exception, stackTrace) {
      ErrorHandler.handle(
        Exception('Failed to initialize review options: $exception'),
        context: ErrorContext.initialization,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get current review data
  Future<ReviewData> _getReviewData() async {
    if (_cachedData != null) return _cachedData!;
    
    _cachedData = await _repository.getReviewData();
    return _cachedData!;
  }

  /// Get current review options
  Future<ReviewOptions> _getReviewOptions() async {
    if (_cachedOptions != null) return _cachedOptions!;
    
    _cachedOptions = await _repository.getReviewOptions();
    return _cachedOptions!;
  }

  /// Save review data and update cache
  Future<void> _saveReviewData(ReviewData data) async {
    await _repository.saveReviewData(data);
    _cachedData = data;
  }

  /// Increment launch count - call this on app startup
  Future<void> incrementLaunchCount() async {
    try {
      final data = await _getReviewData();
      final updatedData = data.incrementLaunch();
      await _saveReviewData(updatedData);
      
      final options = await _getReviewOptions();
      if (options.debugMode) {
        _logger.debug('Launch count incremented: ${updatedData.launchCount}');
      }
    } catch (exception, stackTrace) {
      ErrorHandler.handle(
        Exception('Failed to increment launch count: $exception'),
        context: ErrorContext.userAction,
        stackTrace: stackTrace,
      );
    }
  }

  /// Increment key action count and potentially trigger review request
  Future<void> incrementKeyAction() async {
    try {
      final data = await _getReviewData();
      final updatedData = data.incrementKeyAction();
      await _saveReviewData(updatedData);
      
      final options = await _getReviewOptions();
      if (options.debugMode) {
        _logger.debug('Key action incremented: ${updatedData.keyActionCount}');
      }

      // Check if we should request review after this key action
      await _evaluateReviewRequest();
    } catch (exception, stackTrace) {
      ErrorHandler.handle(
        Exception('Failed to increment key action: $exception'),
        context: ErrorContext.userAction,
        stackTrace: stackTrace,
      );
    }
  }

  /// Add usage time in minutes
  Future<void> addUsageTime(int minutes) async {
    try {
      final data = await _getReviewData();
      final updatedData = data.addUsageTime(minutes);
      await _saveReviewData(updatedData);
    } catch (exception, stackTrace) {
      ErrorHandler.handle(
        Exception('Failed to add usage time: $exception'),
        context: ErrorContext.userAction,
        stackTrace: stackTrace,
      );
    }
  }

  /// Mark user as pro user
  Future<void> upgradeToProUser() async {
    try {
      final data = await _getReviewData();
      final updatedData = data.upgradeToProUser();
      await _saveReviewData(updatedData);
      
      final options = await _getReviewOptions();
      if (options.debugMode) {
        _logger.debug('User upgraded to pro');
      }
    } catch (exception, stackTrace) {
      ErrorHandler.handle(
        Exception('Failed to upgrade to pro user: $exception'),
        context: ErrorContext.userAction,
        stackTrace: stackTrace,
      );
    }
  }

  /// Increment pro feature usage
  Future<void> incrementProFeatureUsage() async {
    try {
      final data = await _getReviewData();
      final updatedData = data.incrementProFeatureUsage();
      await _saveReviewData(updatedData);
    } catch (exception, stackTrace) {
      ErrorHandler.handle(
        Exception('Failed to increment pro feature usage: $exception'),
        context: ErrorContext.userAction,
        stackTrace: stackTrace,
      );
    }
  }

  /// Main evaluation logic - determines if we should show review request
  Future<bool> _evaluateReviewRequest() async {
    try {
      final data = await _getReviewData();
      final options = await _getReviewOptions();

      // Never ask if user selected "Don't Ask Again"
      if (data.dontAskAgain) return false;

      // Never ask if user already rated
      if (data.hasRatedApp) return false;

      // Check if we've reached max attempts
      if (options.hasReachedMaxAttempts(data.reviewAttempts)) return false;

      // Check timing constraints
      if (!_checkTimingConstraints(data, options)) return false;

      // Check phase-specific criteria
      if (options.isInPhase1(data.firstLaunch!)) {
        return _evaluatePhase1Criteria(data, options);
      } else {
        return _evaluatePhase2Criteria(data, options);
      }
    } catch (exception, stackTrace) {
      ErrorHandler.handle(
        Exception('Failed to evaluate review request: $exception'),
        context: ErrorContext.businessLogic,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Check timing constraints
  bool _checkTimingConstraints(ReviewData data, ReviewOptions options) {
    // Debug mode can ignore timing constraints
    if (options.debugMode && options.debugIgnoreTimingConstraints) {
      return true;
    }

    // If user has rated, don't ask for specified period
    if (data.hasRatedApp && 
        data.daysSinceLastRequest < options.preventAskingAfterRateNowDays) {
      return false;
    }

    // Check retry delay based on attempt number
    if (data.reviewAttempts > 0) {
      final requiredDelay = options.getRetryDelayDays(data.reviewAttempts);
      return data.daysSinceLastRequest >= requiredDelay;
    }

    return true;
  }

  /// Evaluate Phase 1 criteria (first week launch boost)
  bool _evaluatePhase1Criteria(ReviewData data, ReviewOptions options) {
    if (data.hasTriggeredPhase1) return false; // Only trigger once in Phase 1

    int metCriteria = 0;

    // Check different days used
    if (data.differentDaysUsed >= options.phase1MinDifferentDays) {
      metCriteria++;
    }

    // Check usage minutes
    if (data.usageMinutes >= options.phase1MinUsageMinutes) {
      metCriteria++;
    }

    // Check key actions
    if (data.keyActionCount >= options.phase1MinKeyActions) {
      metCriteria++;
    }

    // Check if pro user (relaxed criteria)
    if (options.enableRelaxedProUserCriteria && 
        data.isProUser && 
        data.daysSinceProUpgrade != null &&
        data.daysSinceProUpgrade! >= options.proUserMinDaysAfterUpgrade &&
        data.proFeatureUsageCount >= options.proUserMinProFeatureUsage) {
      metCriteria++;
    }

    return metCriteria >= options.phase1MinCriteriaToMeet;
  }

  /// Evaluate Phase 2 criteria (long-term strategy)
  bool _evaluatePhase2Criteria(ReviewData data, ReviewOptions options) {
    // Check minimum days active
    if (data.daysSinceFirstLaunch < options.phase2MinDaysActive) {
      return false;
    }

    // Check minimum launch count
    if (data.launchCount < options.phase2MinLaunchCount) {
      return false;
    }

    // Check minimum key actions
    if (data.keyActionCount < options.phase2MinKeyActions) {
      return false;
    }

    // Pro users have relaxed criteria
    if (options.enableRelaxedProUserCriteria && data.isProUser) {
      return data.daysSinceProUpgrade != null &&
          data.daysSinceProUpgrade! >= options.proUserMinDaysAfterUpgrade &&
          data.proFeatureUsageCount >= options.proUserMinProFeatureUsage;
    }

    return true;
  }

  /// Check if review request should be shown (external API for UI)
  Future<bool> shouldRequestReview() async {
    return await _evaluateReviewRequest();
  }

  /// Handle user's response to review request
  Future<void> handleReviewAction(ReviewAction action) async {
    try {
      final data = await _getReviewData();
      final options = await _getReviewOptions();
      ReviewData updatedData;

      switch (action) {
        case ReviewAction.rateNow:
          await _inAppReview.requestReview();
          updatedData = data.recordReviewRequest().markAsRated();
          
          if (options.debugMode) {
            _logger.debug('User chose to rate now');
          }
          break;

        case ReviewAction.later:
          updatedData = data.recordReviewRequest();
          
          if (options.debugMode) {
            _logger.debug('User chose later (attempt ${updatedData.reviewAttempts})');
          }
          break;

        case ReviewAction.dontAskAgain:
          updatedData = data.recordReviewRequest().setDontAskAgain();
          
          if (options.debugMode) {
            _logger.debug('User chose don\'t ask again');
          }
          break;
      }

      // Mark phase as triggered
      if (options.isInPhase1(data.firstLaunch!)) {
        updatedData = updatedData.markPhase1Triggered();
      } else {
        updatedData = updatedData.markPhase2Triggered();
      }

      await _saveReviewData(updatedData);
    } catch (exception, stackTrace) {
      ErrorHandler.handle(
        Exception('Failed to handle review action: $exception'),
        context: ErrorContext.userAction,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get current metrics for debugging/analytics
  Future<Map<String, dynamic>> getMetrics() async {
    try {
      final data = await _getReviewData();
      final options = await _getReviewOptions();

      return {
        'launchCount': data.launchCount,
        'keyActionCount': data.keyActionCount,
        'usageMinutes': data.usageMinutes,
        'differentDaysUsed': data.differentDaysUsed,
        'daysSinceFirstLaunch': data.daysSinceFirstLaunch,
        'daysSinceLastRequest': data.daysSinceLastRequest,
        'reviewAttempts': data.reviewAttempts,
        'dontAskAgain': data.dontAskAgain,
        'hasRatedApp': data.hasRatedApp,
        'isProUser': data.isProUser,
        'currentPhase': options.isInPhase1(data.firstLaunch!) ? 1 : 2,
        'shouldRequestReview': await _evaluateReviewRequest(),
      };
    } catch (exception, stackTrace) {
      ErrorHandler.handle(
        Exception('Failed to get metrics: $exception'),
        context: ErrorContext.dataLoading,
        stackTrace: stackTrace,
      );
      return {};
    }
  }

  /// Reset all data (useful for testing)
  Future<void> resetData() async {
    try {
      await _repository.clearReviewData();
      _cachedData = null;
      _cachedOptions = null;
    } catch (exception, stackTrace) {
      ErrorHandler.handle(
        Exception('Failed to reset data: $exception'),
        context: ErrorContext.dataDeletion,
        stackTrace: stackTrace,
      );
    }
  }

  /// Update review options
  Future<void> updateOptions(ReviewOptions options) async {
    try {
      await _repository.saveReviewOptions(options);
      _cachedOptions = options;
    } catch (exception, stackTrace) {
      ErrorHandler.handle(
        Exception('Failed to update options: $exception'),
        context: ErrorContext.dataSaving,
        stackTrace: stackTrace,
      );
    }
  }
}