import 'package:enmay_flutter_starter/app/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState {
  final HomeStatus status;

  HomeState({required this.status});

  HomeState copyWith({HomeStatus? status}) {
    return HomeState(status: status ?? this.status);
  }
}

class HomeCubit extends Cubit<HomeState> {
  final AuthRepository authRepository;

  HomeCubit({required this.authRepository}) : super(HomeState(status: HomeStatus.initial));

  void logout() {
    emit(state.copyWith(status: HomeStatus.loading));
    authRepository.logout();
    emit(state.copyWith(status: HomeStatus.success));
  }
}
