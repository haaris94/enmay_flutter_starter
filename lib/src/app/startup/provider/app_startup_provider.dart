import 'package:enmay_flutter_starter/src/core/exceptions/app_exceptions.dart';
import 'package:enmay_flutter_starter/src/data/repositories/auth_repository.dart';
import 'package:enmay_flutter_starter/src/providers/services/service_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_startup_provider.g.dart';

@Riverpod(keepAlive: true)
class AppStartup extends _$AppStartup {
  int _lastFailedServiceIndex = 0;

  final List<_ServiceInitializer> _services = [
    _ServiceInitializer('SharedPreferences', (ref) => ref.watch(sharedPreferencesProvider.future)),
    _ServiceInitializer('AuthRepository', (ref) async => ref.watch(authRepositoryProvider)),
  ];

  @override
  Future<void> build() async {
    ref.onDispose(() {
      ref.invalidate(sharedPreferencesProvider);
      ref.invalidate(authRepositoryProvider);
    });

    await _initializeServicesFromIndex(_lastFailedServiceIndex);
    _lastFailedServiceIndex = 0;
  }

  Future<void> retry() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _initializeServicesFromIndex(_lastFailedServiceIndex));
  }

  void _logStartupError(String message, Object error, StackTrace stackTrace) {
    debugPrint('Startup: $message - $error');
    if (kDebugMode) {
      debugPrint('StackTrace: $stackTrace');
    }
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
}

class _ServiceInitializer {
  const _ServiceInitializer(this.name, this.initializer);

  final String name;
  final Future<void> Function(Ref ref) initializer;
}


