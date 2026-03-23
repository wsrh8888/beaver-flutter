import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/setting/about/bloc/event.dart';
import 'package:beaver/features/setting/about/bloc/state.dart';
import 'package:beaver/features/setting/about/data/repositories/repository.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  final AboutRepository _repository;

  AboutBloc(this._repository) : super(const AboutState()) {
    on<LoadAppInfoEvent>(_onLoadAppInfo);
  }

  Future<void> _onLoadAppInfo(
    LoadAppInfoEvent event,
    Emitter<AboutState> emit,
  ) async {
    emit(state.copyWith(status: AboutStatus.loading));

    try {
      final appInfo = await _repository.getAppInfo();
      emit(state.copyWith(
        status: AboutStatus.success,
        appInfo: appInfo,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AboutStatus.error,
        errorMessage: '加载应用信息失败: $e',
      ));
    }
  }
}

