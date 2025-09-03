import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_data.freezed.dart';
part 'review_data.g.dart';

@freezed
abstract class ReviewData with _$ReviewData {
  const factory ReviewData({
    // Core metrics
    @Default(0) int launchCount,
    @Default(0) int keyActionCount,
    @Default(0) int usageMinutes,
    @Default(0) int differentDaysUsed,
    @Default({}) Set<String> uniqueDaysUsed,
    
    // Timing data
    DateTime? firstLaunch,
    DateTime? lastLaunch,
    DateTime? lastKeyAction,
    DateTime? lastReviewRequest,
    
    // Review attempt tracking
    @Default(0) int reviewAttempts,
    @Default(false) bool dontAskAgain,
    @Default(false) bool hasRatedApp,
    
    // Pro user tracking (optional)
    DateTime? proUpgradeDate,
    @Default(0) int proFeatureUsageCount,
    
    // Phase tracking
    @Default(false) bool hasTriggeredPhase1,
    @Default(false) bool hasTriggeredPhase2,
  }) = _ReviewData;

  factory ReviewData.fromJson(Map<String, dynamic> json) =>
      _$ReviewDataFromJson(json);

  /// Initial data when user first launches the app
  static ReviewData initial() {
    final now = DateTime.now();
    return ReviewData(
      firstLaunch: now,
      lastLaunch: now,
      launchCount: 1,
      uniqueDaysUsed: {_getDayKey(now)},
      differentDaysUsed: 1,
    );
  }

  static String _getDayKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

/// Helper extension for common data operations
extension ReviewDataX on ReviewData {
  /// Days since first launch
  int get daysSinceFirstLaunch {
    if (firstLaunch == null) return 0;
    return DateTime.now().difference(firstLaunch!).inDays;
  }

  /// Days since last review request
  int get daysSinceLastRequest {
    if (lastReviewRequest == null) return 999; // Large number if never requested
    return DateTime.now().difference(lastReviewRequest!).inDays;
  }

  /// Days since pro upgrade (if applicable)
  int? get daysSinceProUpgrade {
    if (proUpgradeDate == null) return null;
    return DateTime.now().difference(proUpgradeDate!).inDays;
  }

  /// Check if user is a pro user
  bool get isProUser => proUpgradeDate != null;

  /// Update data after a launch
  ReviewData incrementLaunch() {
    final now = DateTime.now();
    final dayKey = ReviewData._getDayKey(now);
    final newUniqueDays = {...uniqueDaysUsed, dayKey};
    
    return copyWith(
      launchCount: launchCount + 1,
      lastLaunch: now,
      uniqueDaysUsed: newUniqueDays,
      differentDaysUsed: newUniqueDays.length,
    );
  }

  /// Update data after a key action
  ReviewData incrementKeyAction() {
    return copyWith(
      keyActionCount: keyActionCount + 1,
      lastKeyAction: DateTime.now(),
    );
  }

  /// Update usage time
  ReviewData addUsageTime(int minutes) {
    return copyWith(
      usageMinutes: usageMinutes + minutes,
    );
  }

  /// Mark pro upgrade
  ReviewData upgradeToProUser() {
    return copyWith(
      proUpgradeDate: DateTime.now(),
    );
  }

  /// Increment pro feature usage
  ReviewData incrementProFeatureUsage() {
    return copyWith(
      proFeatureUsageCount: proFeatureUsageCount + 1,
    );
  }

  /// Record review request attempt
  ReviewData recordReviewRequest() {
    return copyWith(
      reviewAttempts: reviewAttempts + 1,
      lastReviewRequest: DateTime.now(),
    );
  }

  /// Set don't ask again preference
  ReviewData setDontAskAgain() {
    return copyWith(
      dontAskAgain: true,
    );
  }

  /// Mark that user rated the app
  ReviewData markAsRated() {
    return copyWith(
      hasRatedApp: true,
      lastReviewRequest: DateTime.now(),
    );
  }

  /// Mark phase 1 as triggered
  ReviewData markPhase1Triggered() {
    return copyWith(
      hasTriggeredPhase1: true,
    );
  }

  /// Mark phase 2 as triggered
  ReviewData markPhase2Triggered() {
    return copyWith(
      hasTriggeredPhase2: true,
    );
  }
}