import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/auth/forget/bloc/event.dart';
import 'package:beaver/features/auth/forget/bloc/state.dart';
import 'package:beaver/features/auth/forget/data/repositories/repository.dart';

class ForgetBloc extends Bloc<ForgetEvent, ForgetState> {
  final ForgetRepository _repository;
  Timer? _countdownTimer;

  ForgetBloc(this._repository) : super(const ForgetState()) {
    on<SendVerificationCodeEvent>(_onSendVerificationCode);
    on<ResetPasswordEvent>(_onResetPassword);
    on<UpdateCountdownEvent>(_onUpdateCountdown);
    on<ResetCountdownEvent>(_onResetCountdown);
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }

  Future<void> _onSendVerificationCode(
    SendVerificationCodeEvent event,
    Emitter<ForgetState> emit,
  ) async {
    emit(state.copyWith(
      status: ForgetStatus.sendingCode,
      isCodeButtonDisabled: true,
    ));

    try {
      final success = await _repository.sendVerificationCode(event.request);
      if (success) {
        emit(state.copyWith(
          status: ForgetStatus.success,
          errorMessage: '验证码已发送',
        ));
        _startCountdown();
      } else {
        emit(state.copyWith(
          status: ForgetStatus.error,
          errorMessage: '发送失败',
          isCodeButtonDisabled: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ForgetStatus.error,
        errorMessage: '发送失败: $e',
        isCodeButtonDisabled: false,
      ));
    }
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<ForgetState> emit,
  ) async {
    emit(state.copyWith(status: ForgetStatus.resettingPassword));

    try {
      final success = await _repository.resetPassword(event.request);
      if (success) {
        emit(state.copyWith(
          status: ForgetStatus.success,
          errorMessage: '密码重置成功',
        ));
      } else {
        emit(state.copyWith(
          status: ForgetStatus.error,
          errorMessage: '重置失败',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ForgetStatus.error,
        errorMessage: '重置失败: $e',
      ));
    }
  }

  Future<void> _onUpdateCountdown(
    UpdateCountdownEvent event,
    Emitter<ForgetState> emit,
  ) async {
    if (state.countdown > 0) {
      emit(state.copyWith(
        countdown: state.countdown - 1,
      ));
    } else {
      _countdownTimer?.cancel();
      emit(state.copyWith(
        isCodeButtonDisabled: false,
        countdown: 60,
      ));
    }
  }

  Future<void> _onResetCountdown(
    ResetCountdownEvent event,
    Emitter<ForgetState> emit,
  ) async {
    _countdownTimer?.cancel();
    emit(state.copyWith(
      isCodeButtonDisabled: false,
      countdown: 60,
    ));
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(UpdateCountdownEvent());
    });
  }
}
