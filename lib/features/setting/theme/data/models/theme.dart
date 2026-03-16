import 'package:flutter/material.dart';

class ThemeConfig {
  final String name;
  final String label;
  final ThemeColors colors;

  const ThemeConfig({
    required this.name,
    required this.label,
    required this.colors,
  });
}

class ThemeColors {
  final Color primary;
  final Color background;
  final Color textBody;
  final Color divider;

  const ThemeColors({
    required this.primary,
    required this.background,
    required this.textBody,
    required this.divider,
  });
}
