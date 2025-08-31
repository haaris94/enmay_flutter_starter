// lib/providers/app_startup/app_startup_provider.dart

import 'package:enmay_flutter_starter/src/core/exceptions/app_exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_startup_provider.g.dart';

@Riverpod(keepAlive: true)
class AppStartup extends _$AppStartup {
  // Keep track of which service failed and from where to retry
  int _lastFailedServiceIndex = 0;

  // Define the initialization order
  final List<_ServiceInitializer> _services = [
    // _ServiceInitializer('SharedPreferences', (ref) => ref.watch(sharedPreferencesProvider.future)),
    // _ServiceInitializer('Database', (ref) => ref.watch(driftDatabaseProvider.future)),
    // _ServiceInitializer('HTTP Client', (ref) => ref.watch(dioClientProvider.future)),
    // _ServiceInitializer('Auth Repository', (ref) => ref.watch(authRepositoryProvider.future)),
    // _ServiceInitializer('User Repository', (ref) => ref.watch(userRepositoryProvider.future)),
    // Add more services as needed
  ];

  @override
  Future<void> build() async {
    ref.onDispose(() {
      // Clean invalidation of all dependent providers
      // ref.invalidate(sharedPreferencesProvider);
      // ref.invalidate(driftDatabaseProvider);
      // ref.invalidate(dioClientProvider);
      // ref.invalidate(authRepositoryProvider);
      // ref.invalidate(userRepositoryProvider);
      // Add all your providers here
    });

    // Initialize services starting from the last failed index
    await _initializeServicesFromIndex(_lastFailedServiceIndex);
    _lastFailedServiceIndex = 0; // Reset on success
  }

  Future<void> _initializeServicesFromIndex(int startIndex) async {
    for (int i = startIndex; i < _services.length; i++) {
      final service = _services[i];
      bool success = false;
      int attemptCount = 0;

      while (!success && attemptCount < 2) {
        try {
          attemptCount++;
          await service.initializer(ref);
          success = true;
        } catch (error, stackTrace) {
          if (attemptCount == 1) {
            _logStartupError('${service.name} failed, retrying silently...', error, stackTrace);
            await Future.delayed(const Duration(milliseconds: 500));
            continue;
          } else {
            _lastFailedServiceIndex = i;
            _logStartupError('${service.name} failed after retry', error, stackTrace);
            throw StartupException('Failed to initialize ${service.name}: ${error.toString()}');
          }
        }
      }
    }
  }

  void _logStartupError(String message, Object error, StackTrace stackTrace) {
    debugPrint('Startup: $message - $error');
    if (kDebugMode) {
      debugPrint('StackTrace: $stackTrace');
    }
  }

  Future<void> retry() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _initializeServicesFromIndex(_lastFailedServiceIndex));
  }
}

// Helper class to define service initialization
class _ServiceInitializer {
  const _ServiceInitializer(this.name, this.initializer);

  final String name;
  final Future<void> Function(Ref ref) initializer;
}


