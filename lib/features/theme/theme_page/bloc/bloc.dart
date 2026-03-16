import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/theme/theme_page/bloc/event.dart';
import 'package:beaver/features/theme/theme_page/bloc/state.dart';
import 'package:beaver/features/theme/theme_page/data/repositories/repository.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository _repository;

  ThemeBloc(this._repository) : super(const ThemeState()) {
    on<LoadThemesEvent>(_onLoadThemes);
    on<SelectThemeEvent>(_onSelectTheme);
  }

  Future<void> _onLoadThemes(
    LoadThemesEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(status: ThemeStatus.loading));

    try {
      final availableThemes = await _repository.getAvailableThemes();
      final currentTheme = await _repository.getCurrentTheme();
      final currentThemeConfig = availableThemes.firstWhere(
        (theme) => theme.name == currentTheme,
        orElse: () => availableThemes.first,
      );

      emit(state.copyWith(
        status: ThemeStatus.success,
        availableThemes: availableThemes,
        currentTheme: currentTheme,
        currentThemeConfig: currentThemeConfig,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ThemeStatus.error,
        errorMessage: '加载主题失败: $e',
      ));
    }
  }

  Future<void> _onSelectTheme(
    SelectThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(status: ThemeStatus.loading));

    try {
      await _repository.setTheme(event.themeName);
      final currentThemeConfig = state.availableThemes.firstWhere(
        (theme) => theme.name == event.themeName,
        orElse: () => state.availableThemes.first,
      );

      emit(state.copyWith(
        status: ThemeStatus.success,
        currentTheme: event.themeName,
        currentThemeConfig: currentThemeConfig,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ThemeStatus.error,
        errorMessage: '设置主题失败: $e',
      ));
    }
  }
}
