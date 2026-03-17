import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/auth/login/bloc/event.dart';
import 'package:beaver/features/auth/login/bloc/state.dart';
import 'package:beaver/features/auth/login/data/repositories/repository.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository authRepository;
  
  LoginBloc({required this.authRepository}) : super(const LoginState()) {
    on<LoginSubmitEvent>(_onLoginSubmit);
  }
  
  Future<void> _onLoginSubmit(LoginSubmitEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));
    
    try {
      await authRepository.login(event.email, event.password);
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
