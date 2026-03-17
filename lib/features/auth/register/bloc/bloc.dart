import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/auth/register/bloc/event.dart';
import 'package:beaver/features/auth/register/bloc/state.dart';
import 'package:beaver/features/auth/register/data/repositories/repository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository authRepository;
  
  RegisterBloc({required this.authRepository}) : super(const RegisterState()) {
    on<RegisterSubmitEvent>(_onRegisterSubmit);
  }
  
  Future<void> _onRegisterSubmit(RegisterSubmitEvent event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    
    try {
      await authRepository.register(
        event.email,
        event.password,
        event.confirmPassword,
      );
      emit(state.copyWith(status: RegisterStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: RegisterStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
