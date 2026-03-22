import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/auth/login/bloc/event.dart';
import 'package:beaver/features/auth/login/bloc/state.dart';
import 'package:beaver/features/auth/login/data/repositories/repository.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/store/app/app.dart';
import 'package:beaver/common/websocket/ws_connection_manager.dart';
import 'package:beaver/di/injection.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository authRepository;

  LoginBloc({required this.authRepository}) : super(const LoginState()) {
    on<LoginSubmitEvent>(_onLoginSubmit);
  }

  Future<void> _onLoginSubmit(
    LoginSubmitEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      final response = await authRepository.login(event.email, event.password);
      if (response.code == 0 && response.result != null) {
        // 重要：登录成功后，必须立即初始化数据库和 AppStore
        await DatabaseManager.init(response.result!.userId);

        // 触发 AppStore 初始化全局数据 (对标 desktop.initApp)
        await getIt<AppStore>().initApp();

        emit(state.copyWith(status: LoginStatus.success));
      } else {
        emit(
          state.copyWith(
            status: LoginStatus.error,
            errorMessage: response.msg ?? '登录失败',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: LoginStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
