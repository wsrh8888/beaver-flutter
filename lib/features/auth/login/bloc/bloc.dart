import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/auth/login/bloc/event.dart';
import 'package:beaver/features/auth/login/bloc/state.dart';
import 'package:beaver/features/auth/login/data/repositories/repository.dart';
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
        final appStore = getIt<AppStore>();
        // 重要：登录成功后，必须立即初始化数据库，以便首页能读取到本地数据
        await appStore.initUserDatabase(response.result!.userId);

        // 1. 先跳转到首页 (通过 emit success 状态)
        emit(state.copyWith(status: LoginStatus.success));

        // 2. 异步连接 WebSocket (不再阻塞 UI 跳转)
        // 使用 Future.microtask 或直接调用，因为它已经是一个异步过程的开始
        Future.microtask(() {
          getIt<WsConnectionManager>().connectWithToken(response.result!.token);
        });

        // 3. 用户认为 AppStore.initApp 不需要在此调用 (对标 desktop.initApp)
        // await appStore.initApp();
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
