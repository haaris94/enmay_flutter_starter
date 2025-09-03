import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_options.freezed.dart';
part 'review_options.g.dart';

@freezed
abstract class ReviewOptions with _$ReviewOptions {
  const factory ReviewOptions({
    // Phase 1: First Week Launch Boost (Days 1-7)
    @Default(3) int phase1MinDifferentDays,
    @Default(10) int phase1MinUsageMinutes,
    @Default(2) int phase1MinKeyActions,
    @Default(7) int phase1MaxDays,
    @Default(2) int phase1MinCriteriaToMeet,

    // Phase 2: Long-term Strategy (Day 8+)
    @Default(7) int phase2MinDaysActive,
    @Default(5) int phase2MinLaunchCount,
    @Default(3) int phase2MinKeyActions,

    // Retry Timing Configuration
    @Default(14) int firstRetryDelayDays,
    @Default(21) int maxFirstRetryDelayDays,
    @Default(30) int secondRetryDelayDays,
    @Default(45) int maxSecondRetryDelayDays,

    // General Settings
    @Default(180) int preventAskingAfterRateNowDays,
    @Default(3) int maxAttempts,
    @Default(true) bool respectDontAskAgain,

    // Pro User Settings (Optional - more relaxed criteria)
    @Default(3) int proUserMinDaysAfterUpgrade,
    @Default(1) int proUserMinProFeatureUsage,
    @Default(true) bool enableRelaxedProUserCriteria,

    // Debug Settings
    @Default(false) bool debugMode,
    @Default(false) bool debugIgnoreTimingConstraints,
  }) = _ReviewOptions;

  factory ReviewOptions.fromJson(Map<String, dynamic> json) =>
      _$ReviewOptionsFromJson(json);

  /// Default configuration following the strategy from docs/app_erview.md
  static const ReviewOptions defaultOptions = ReviewOptions();

  /// Conservative configuration - less aggressive timing
  static const ReviewOptions conservative = ReviewOptions(
    phase1MinDifferentDays: 5,
    phase1MinUsageMinutes: 15,
    phase1MinKeyActions: 3,
    phase2MinDaysActive: 10,
    phase2MinLaunchCount: 8,
    phase2MinKeyActions: 5,
    firstRetryDelayDays: 21,
    secondRetryDelayDays: 45,
  );

  /// Aggressive configuration - faster timing for engaged users
  static const ReviewOptions aggressive = ReviewOptions(
    phase1MinDifferentDays: 2,
    phase1MinUsageMinutes: 5,
    phase1MinKeyActions: 1,
    phase2MinDaysActive: 5,
    phase2MinLaunchCount: 3,
    phase2MinKeyActions: 2,
    firstRetryDelayDays: 10,
    secondRetryDelayDays: 21,
  );

  /// Debug configuration - immediate triggers for testing
  static const ReviewOptions debug = ReviewOptions(
    phase1MinDifferentDays: 1,
    phase1MinUsageMinutes: 1,
    phase1MinKeyActions: 1,
    phase2MinDaysActive: 1,
    phase2MinLaunchCount: 1,
    phase2MinKeyActions: 1,
    firstRetryDelayDays: 1,
    secondRetryDelayDays: 2,
    debugMode: true,
    debugIgnoreTimingConstraints: true,
  );
}

/// Helper extension for common option checks
extension ReviewOptionsX on ReviewOptions {
  /// Check if we're in the first week launch boost phase
  bool isInPhase1(DateTime firstLaunch) {
    final daysSinceFirstLaunch = DateTime.now().difference(firstLaunch).inDays;
    return daysSinceFirstLaunch <= phase1MaxDays;
  }

  /// Get the appropriate retry delay based on attempt number
  int getRetryDelayDays(int attemptNumber) {
    switch (attemptNumber) {
      case 1:
        return firstRetryDelayDays;
      case 2:
        return secondRetryDelayDays;
      default:
        return maxSecondRetryDelayDays;
    }
  }

  /// Check if user has reached maximum attempts
  bool hasReachedMaxAttempts(int currentAttempts) {
    return currentAttempts >= maxAttempts;
  }
}