import 'package:enmay_flutter_starter/src/core/exceptions/error_handler.dart';
import 'package:enmay_flutter_starter/src/core/exceptions/failure.dart';
import 'package:enmay_flutter_starter/src/core/constants/enums/error_context.dart';
import 'package:enmay_flutter_starter/src/data/repositories/auth_repository.dart';
import 'package:enmay_flutter_starter/src/providers/services/service_providers.dart';
import 'package:flutter/foundation.dart';
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
    await _initializeSharedPreferences();
    await _initializeAuthRepository();
  }

  Future<void> _initializeSharedPreferences() async {
    try {
      await ref.watch(sharedPreferencesProvider.future);
    } catch (error, stackTrace) {
      
      if (error is Exception) {
        final failure = ErrorHandler.handle(error, context: ErrorContext.appStartup);
        throw failure;
      } else {
        throw const Failure(
          title: 'Startup Error',
          message: 'Failed to initialize app storage. Please restart the app.',
          type: ErrorType.storage,
        );
      }
    }
  }

  Future<void> _initializeAuthRepository() async {
    try {
      ref.watch(authRepositoryProvider);
    } catch (error, stackTrace) {
      debugPrint('Startup: AuthRepository initialization failed - $error');
      if (kDebugMode) {
        debugPrint('StackTrace: $stackTrace');
      }
      
      if (error is Exception) {
        final failure = ErrorHandler.handle(error, context: ErrorContext.appStartup);
        throw failure;
      } else {
        throw const Failure(
          title: 'Authentication Error',
          message: 'Failed to initialize authentication. Please restart the app.',
          type: ErrorType.authentication,
        );
      }
    }
  }
}


