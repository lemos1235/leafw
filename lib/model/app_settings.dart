//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/6/4
//
import 'package:flutter/material.dart';
import 'package:canis/extensions/extensions.dart';

class AppSettings {
  final Appearance appearance;

  AppSettings({
    this.appearance = const Appearance(),
  });

  AppSettings copyWith({
    Appearance? appearance,
  }) {
    return AppSettings(
      appearance: appearance ?? this.appearance,
    );
  }

  factory AppSettings.fromJson(dynamic json) {
    return AppSettings(
      appearance: Appearance.fromJson(json['appearance']),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['appearance'] = appearance.toJson();
    return map;
  }
}

class Appearance {
  const Appearance({
    this.themeMode = ThemeMode.system,
  });

  final ThemeMode themeMode;

  Appearance copyWith({
    ThemeMode? themeMode,
  }) {
    return Appearance(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  factory Appearance.fromJson(dynamic json) {
    return Appearance(
      themeMode: ThemeModeExtension.getByIndex(json['themeMode']),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['themeMode'] = themeMode.index;
    return map;
  }
}
