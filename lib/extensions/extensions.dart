//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/6/4
//
import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get bottomInsets => mediaQuery.viewInsets.bottom;

  double get bottomPadding => mediaQuery.padding.bottom;

  ThemeData get theme => Theme.of(this);

  Brightness get brightness => theme.brightness;

  bool get isDark => theme.brightness == Brightness.dark;

  TextTheme get textTheme => theme.textTheme;

  IconThemeData get iconTheme => IconTheme.of(this);

  AppBarTheme get appBarTheme => AppBarTheme.of(this);

  Color get themeColor => theme.colorScheme.secondary;

  ColorScheme get colorScheme => theme.colorScheme;

  Color get surfaceColor => colorScheme.surface;
}

extension ThemeModeExtension on ThemeMode {
  String get humanName {
    switch (this) {
      case ThemeMode.system:
        return "跟随系统";
      case ThemeMode.light:
        return "浅色";
      case ThemeMode.dark:
        return "深色";
    }
  }

  static ThemeMode getByIndex(int index) {
    for (final v in ThemeMode.values) {
      if (v.index == index) {
        return v;
      }
    }
    return ThemeMode.system;
  }
}
