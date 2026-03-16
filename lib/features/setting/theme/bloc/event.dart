abstract class ThemeEvent {
  const ThemeEvent();
}

class LoadThemesEvent extends ThemeEvent {
  const LoadThemesEvent();
}

class SelectThemeEvent extends ThemeEvent {
  final String themeName;

  const SelectThemeEvent(this.themeName);
}
