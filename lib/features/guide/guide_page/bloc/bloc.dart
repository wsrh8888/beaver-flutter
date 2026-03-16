import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/guide/guide_page/bloc/event.dart';
import 'package:beaver/features/guide/guide_page/bloc/state.dart';
import 'package:beaver/features/guide/guide_page/data/repositories/repository.dart';

class GuideBloc extends Bloc<GuideEvent, GuideState> {
  final GuideRepository _repository;

  GuideBloc(this._repository) : super(const GuideState()) {
    on<LoadGuideConfigEvent>(_onLoadGuideConfig);
    on<NavigateToRegisterEvent>(_onNavigateToRegister);
    on<NavigateToLoginEvent>(_onNavigateToLogin);
  }

  Future<void> _onLoadGuideConfig(
    LoadGuideConfigEvent event,
    Emitter<GuideState> emit,
  ) async {
    emit(state.copyWith(status: GuideStatus.loading));

    try {
      final guideConfig = await _repository.getGuideConfig();
      emit(state.copyWith(
        status: GuideStatus.success,
        guideConfig: guideConfig,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GuideStatus.error,
        errorMessage: '加载引导页配置失败: $e',
      ));
    }
  }

  Future<void> _onNavigateToRegister(
    NavigateToRegisterEvent event,
    Emitter<GuideState> emit,
  ) async {
    // 导航到注册页面
  }

  Future<void> _onNavigateToLogin(
    NavigateToLoginEvent event,
    Emitter<GuideState> emit,
  ) async {
    // 导航到登录页面
  }
}
