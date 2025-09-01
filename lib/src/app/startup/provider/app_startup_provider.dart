import 'package:enmay_flutter_starter/src/core/exceptions/error_handler.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/failure.dart';
import 'package:enmay_flutter_starter/src/core/constants/enums/error_context.dart';
import 'package:enmay_flutter_starter/src/data/repositories/auth_repository.dart';
import 'package:enmay_flutter_starter/src/providers/services/service_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_startup_provider.g.dart';

@Riverpod(keepAlive: true)
class AppStartup extends _$AppStartup {
  @override
  Future<void> build() async {
    ref.onDispose(() {
      ref.invalidate(sharedPreferencesProvider);
      ref.invalidate(authRepositoryProvider);
    });

    await _initializeServices();
  }

  Future<void> retry() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _initializeServices());
  }

  Future<void> _initializeServices() async {
    await _initializeService(
      initFunction: () async => await ref.watch(sharedPreferencesProvider.future),
      context: ErrorContext.appStartup,
      genericFailureTitle: 'Startup Error',
      genericFailureMessage: 'Failed to initialize app storage. Please retry or restart the app.',
      genericFailureType: ErrorType.storage,
    );
    await _initializeService(
      initFunction: () async => ref.watch(authRepositoryProvider),
      context: ErrorContext.appStartup,
      genericFailureTitle: 'Authentication Error',
      genericFailureMessage: 'Failed to initialize authentication. Please retry or restart the app.',
      genericFailureType: ErrorType.authentication,
    );
  }


  // Generic Service Initialization method
  Future<void> _initializeService({
    required Future<dynamic> Function() initFunction,
    required ErrorContext context,
    required String genericFailureTitle,
    required String genericFailureMessage,
    required ErrorType genericFailureType,
  }) async {
    try {
      await initFunction();
    } catch (error, stackTrace) {
      if (error is Exception) {
        final failure = ErrorHandler.handle(error, stackTrace: stackTrace, context: context);
        throw failure;
      } else {
        throw Failure(
          title: genericFailureTitle,
          message: genericFailureMessage,
          type: genericFailureType,
        );
      }
    }
  }
}
