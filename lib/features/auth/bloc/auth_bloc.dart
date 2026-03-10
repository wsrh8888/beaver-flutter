import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState()) {
    on<AuthLoginEvent>(_onLogin);
    on<AuthRegisterEvent>(_onRegister);
    on<AuthLogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    try {
      final response = await _authRepository.login(event.username, event.password);
      
      if (response.code == 0 && response.result != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          token: response.result,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: response.msg,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: '网络请求失败: $e',
      ));
    }
  }

  Future<void> _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    await _authRepository.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> _onRegister(AuthRegisterEvent event, Emitter<AuthState> emit) async {
     emit(state.copyWith(status: AuthStatus.loading));
     
     final response = await _authRepository.register(event.username, event.password);
     
     if (response.code == 0) {
       add(AuthLoginEvent(username: event.username, password: event.password));
     } else {
       emit(state.copyWith(
         status: AuthStatus.error,
         errorMessage: response.msg,
       ));
     }
  }
}
