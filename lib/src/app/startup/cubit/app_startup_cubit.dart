import 'dart:async';

import 'package:enmay_flutter_starter/src/core/exceptions/legacy/app_exception.dart';
import 'package:enmay_flutter_starter/src/data/repositories/auth_repository.dart';
import 'package:enmay_flutter_starter/src/app/startup/cubit/app_startup_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppStartupCubit extends Cubit<AppStartupState> {
  AppStartupCubit() : super(const AppStartupState.initial());

  String _currentLoadingMessage = 'Starting initialization...';

  String get currentLoadingMessage => _currentLoadingMessage;

  Future<void> initializeServices() async {
    _updateLoadingState('Starting initialization...');

    try {
      await _initializeAnalytics();
      await _initializeLocalStorage();

      _updateLoadingState('Initializing authentication...');
      final authRepository = await _initializeAuth();

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
    _updateLoadingState('Initializing analytics...');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _initializeLocalStorage() async {
    _updateLoadingState('Initializing local storage...');
    await Future.delayed(const Duration(milliseconds: 700));
  }

  Future<AuthRepository> _initializeAuth() async {
    _updateLoadingState('Initializing authentication...');
    await Future.delayed(const Duration(milliseconds: 800));
    final authRepository = AuthRepository();
    return authRepository;
  }

  Future<void> _initializeAdditionalServices() async {
    _updateLoadingState('Initializing additional services...');
    await Future.delayed(const Duration(milliseconds: 600));
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
