//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/6/4
//
import 'package:flutter/material.dart';
import 'package:canis/hive/modules/settings_hive.dart';
import 'package:canis/model/app_settings.dart';

class SettingsProvider with ChangeNotifier {
  AppSettings appSettings = AppSettings();

  void initAppSettings() {
    final settings = SettingsHive.getSettings();
    if (settings != null) {
      appSettings = settings;
    }
  }

  AppSettings getAppSettings() {
    return appSettings;
  }

  void setAppSettings(AppSettings settings) {
    appSettings = settings;
    SettingsHive.setSettings(settings);
    notifyListeners();
  }

  void toggleThemeMode(ThemeMode themeMode) {
    final settings = appSettings.copyWith(
      appearance: appSettings.appearance.copyWith(themeMode: themeMode),
    );
    setAppSettings(settings);
  }
}
