import 'package:enmay_flutter_starter/app/core/exceptions/app_exception.dart';
import 'package:enmay_flutter_starter/app/data/repositories/auth_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_startup_state.freezed.dart';

@freezed
class AppStartupState with _$AppStartupState {
  const factory AppStartupState.initial() = _Initial;

  const factory AppStartupState.loading({@Default('Initializing...') String message}) = _Loading;

  const factory AppStartupState.loaded(LoadedState state) = _Loaded;

  const factory AppStartupState.error(AppException appException) = _Error;
}

/// State containing all initialized services that will be provided to the app
class LoadedState {
  final AuthRepository authRepository;
  // Add other repositories and services here as needed

  LoadedState({required this.authRepository});
}
