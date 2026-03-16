import 'package:beaver/features/theme/theme_page/data/models/theme.dart';

enum ThemeStatus { initial, loading, success, error }

class ThemeState {
  final ThemeStatus status;
  final List<ThemeConfig> availableThemes;
  final String currentTheme;
  final ThemeConfig? currentThemeConfig;
  final String? errorMessage;

  const ThemeState({
    this.status = ThemeStatus.initial,
    this.availableThemes = const [],
    this.currentTheme = 'default',
    this.currentThemeConfig,
    this.errorMessage,
  });

  ThemeState copyWith({
    ThemeStatus? status,
    List<ThemeConfig>? availableThemes,
    String? currentTheme,
    ThemeConfig? currentThemeConfig,
    String? errorMessage,
  }) {
    return ThemeState(
      status: status ?? this.status,
      availableThemes: availableThemes ?? this.availableThemes,
      currentTheme: currentTheme ?? this.currentTheme,
      currentThemeConfig: currentThemeConfig ?? this.currentThemeConfig,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
