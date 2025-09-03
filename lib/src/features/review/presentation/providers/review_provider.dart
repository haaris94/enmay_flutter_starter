import 'package:enmay_flutter_starter/src/data/services/service_provider/service_providers.dart';
import 'package:enmay_flutter_starter/src/features/review/data/repositories/review_repository.dart';
import 'package:enmay_flutter_starter/src/features/review/services/review_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_provider.g.dart';

/// Provider for ReviewRepository
@Riverpod(keepAlive: true)
ReviewRepository reviewRepository(Ref ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider).value;
  return ReviewRepository(prefs: sharedPrefs!);
}

/// Provider for ReviewService
@Riverpod(keepAlive: true)
ReviewService reviewService(Ref ref) {
  final repository = ref.watch(reviewRepositoryProvider);
  return ReviewService(repository: repository);
}

/// Provider to get current review metrics
@Riverpod()
Future<Map<String, dynamic>> reviewMetrics(Ref ref) async {
  final service = ref.watch(reviewServiceProvider);
  return await service.getMetrics();
}

/// Provider to check if review should be requested
@Riverpod()
Future<bool> shouldRequestReview(Ref ref) async {
  final service = ref.watch(reviewServiceProvider);
  return await service.shouldRequestReview();
}