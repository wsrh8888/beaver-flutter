import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/setting/main/bloc/event.dart';
import 'package:beaver/features/setting/main/bloc/state.dart';
import 'package:beaver/features/setting/main/data/repositories/repository.dart';

class SettingMainBloc extends Bloc<SettingMainEvent, SettingMainState> {
  final SettingMainRepository _repository;

  SettingMainBloc(this._repository) : super(const SettingMainState()) {
    on<LoadSettingItemsEvent>(_onLoadSettingItems);
    on<ShowLogoutDialogEvent>(_onShowLogoutDialog);
    on<HideLogoutDialogEvent>(_onHideLogoutDialog);
    on<LogoutEvent>(_onLogout);
  }

  void _onLoadSettingItems(
    LoadSettingItemsEvent event,
    Emitter<SettingMainState> emit,
  ) {
    emit(state.copyWith(status: SettingMainStatus.loading));
    try {
      final items = _repository.getSettingItems();
      emit(state.copyWith(
        status: SettingMainStatus.success,
        settingItems: items,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingMainStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onShowLogoutDialog(
    ShowLogoutDialogEvent event,
    Emitter<SettingMainState> emit,
  ) {
    emit(state.copyWith(showLogoutDialog: true));
  }

  void _onHideLogoutDialog(
    HideLogoutDialogEvent event,
    Emitter<SettingMainState> emit,
  ) {
    emit(state.copyWith(showLogoutDialog: false));
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<SettingMainState> emit,
  ) async {
    // 这里执行退出登录逻辑
    emit(state.copyWith(status: SettingMainStatus.loading));
    try {
      // 模拟退出登录
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: SettingMainStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: SettingMainStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
