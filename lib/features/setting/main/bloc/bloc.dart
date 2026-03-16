import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/setting/main/bloc/event.dart';
import 'package:beaver/features/setting/main/bloc/state.dart';
import 'package:beaver/features/setting/main/data/repositories/repository.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final SettingRepository _repository;

  SettingBloc(this._repository) : super(const SettingState()) {
    on<LoadSettingItemsEvent>(_onLoadSettingItems);
    on<ShowLogoutDialogEvent>(_onShowLogoutDialog);
    on<HideLogoutDialogEvent>(_onHideLogoutDialog);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLoadSettingItems(
    LoadSettingItemsEvent event,
    Emitter<SettingState> emit,
  ) async {
    emit(state.copyWith(status: SettingStatus.loading));

    try {
      final settingItems = await _repository.getSettingItems();
      emit(state.copyWith(
        status: SettingStatus.success,
        settingItems: settingItems,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingStatus.error,
        errorMessage: '加载设置项失�? $e',
      ));
    }
  }

  Future<void> _onShowLogoutDialog(
    ShowLogoutDialogEvent event,
    Emitter<SettingState> emit,
  ) async {
    emit(state.copyWith(showLogoutDialog: true));
  }

  Future<void> _onHideLogoutDialog(
    HideLogoutDialogEvent event,
    Emitter<SettingState> emit,
  ) async {
    emit(state.copyWith(showLogoutDialog: false));
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<SettingState> emit,
  ) async {
    // 模拟登出逻辑
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(showLogoutDialog: false));
  }
}

