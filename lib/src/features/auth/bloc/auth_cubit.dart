import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthState());

  final AuthRepository _authRepository;

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authRepository.login(email, password);
      emit(state.copyWith(status: AuthStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> register(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authRepository.register(email, password);
      emit(state.copyWith(status: AuthStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()));
    }
  }
}
