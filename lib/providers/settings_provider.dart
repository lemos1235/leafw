//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/6/4
//
import 'package:canis/hive/modules/settings_hive.dart';
import 'package:canis/model/app_settings.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  AppSettings appSettings = AppSettings();

  AppSettings initAppSettings() {
    final settings = SettingsHive.getSettings();
    if (settings != null) {
      appSettings = settings;
    }
    return appSettings;
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

  void updateProxySettings({
    bool? inboundAllowAlan,
    int? inboundHttpPort,
    int? inboundSocksPort,
  }) {
    final settings = appSettings.copyWith(
      proxySettings: appSettings.proxySettings.copyWith(
        inboundAllowAlan: inboundAllowAlan,
        inboundHttpPort: inboundHttpPort,
        inboundSocksPort: inboundSocksPort,
      ),
    );
    setAppSettings(settings);
  }

  void toggleHideInSystemTray(bool hide) {
    final settings = appSettings.copyWith(
      commonSettings: appSettings.commonSettings.copyWith(
        hideToTrayWhenClose: hide,
      ),
    );
    setAppSettings(settings);
  }
}
