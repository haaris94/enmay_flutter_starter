import 'package:enmay_flutter_starter/app/core/exceptions/app_exception.dart';
import 'package:enmay_flutter_starter/app/data/repositories/auth_repository.dart';
import 'package:enmay_flutter_starter/app/features/startup/bloc/app_startup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppStartupCubit extends Cubit<AppStartupState> {
  AppStartupCubit() : super(const AppStartupState.initial());

  Future<void> initializeServices() async {
    emit(const AppStartupState.loading());

    try {
      await Future.delayed(const Duration(seconds: 2));

      AuthRepository authRepository = AuthRepository();

      emit(AppStartupState.loaded(LoadedState(
        authRepository: authRepository,
      )));
    } catch (e) {
      emit(AppStartupState.error(AppException(
        message: e.toString(),
        code: 'app_startup_error',
      )));
    }
  }
}
