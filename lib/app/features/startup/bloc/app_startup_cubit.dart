import 'dart:async';

import 'package:enmay_flutter_starter/app/core/exceptions/app_exception.dart';
import 'package:enmay_flutter_starter/app/data/repositories/auth_repository.dart';
import 'package:enmay_flutter_starter/app/features/startup/bloc/app_startup_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppStartupCubit extends Cubit<AppStartupState> {
  AppStartupCubit() : super(const AppStartupState.initial());

  String _currentLoadingMessage = 'Starting initialization...';

  String get currentLoadingMessage => _currentLoadingMessage;

  Future<void> initializeServices() async {
    _updateLoadingState('Starting initialization...');

    try {
      _updateLoadingState('Initializing analytics...');
      await _initializeAnalytics();

      _updateLoadingState('Initializing local storage...');
      await _initializeLocalStorage();

      _updateLoadingState('Initializing authentication...');
      final authRepository = await _initializeAuth();

      _updateLoadingState('Initializing services...');
      await _initializeAdditionalServices();

      _updateLoadingState('Finalizing...');
      await Future.delayed(const Duration(milliseconds: 300));

      emit(AppStartupState.loaded(LoadedState(authRepository: authRepository)));
    } catch (e, stackTrace) {
      debugPrint('Error during app startup: $e\n$stackTrace');
      emit(AppStartupState.error(_handleStartupException(e, stackTrace)));
    }
  }

  void _updateLoadingState(String message) {
    _currentLoadingMessage = message;
    emit(AppStartupState.loading(message: message));
  }

  Future<void> _initializeAnalytics() async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('Analytics initialized');
  }

  Future<void> _initializeLocalStorage() async {
    await Future.delayed(const Duration(milliseconds: 700));
    debugPrint('Local storage initialized');
  }

  Future<AuthRepository> _initializeAuth() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final authRepository = AuthRepository();
    debugPrint('Auth repository initialized');
    return authRepository;
  }

  Future<void> _initializeAdditionalServices() async {
    await Future.delayed(const Duration(milliseconds: 600));
    debugPrint('Additional services initialized');
  }

  AppException _handleStartupException(dynamic error, StackTrace stackTrace) {
    if (error is TimeoutException) {
      return AppException.network(
        message: 'Connection timed out during startup',
        code: 'startup_timeout',
        stackTrace: stackTrace,
        originalException: error,
      );
    } else if (error is AppException) {
      return error;
    } else {
      return AppException.unknown(
        message: 'Failed to initialize app: ${error.toString()}',
        code: 'startup_failure',
        stackTrace: stackTrace,
        originalException: error,
      );
    }
  }
}
