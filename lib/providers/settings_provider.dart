//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/6/4
//
import 'package:canis/hive/modules/settings_hive.dart';
import 'package:canis/model/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:proxy_manager/proxy_manager.dart';

class SettingsProvider with ChangeNotifier {
  AppSettings appSettings = AppSettings();

  //初始化APP设置
  AppSettings initAppSettings() {
    final settings = SettingsHive.getSettings();
    if (settings != null) {
      appSettings = settings;
    }
    setupSystemProxy(appSettings.proxySettings);
    return appSettings;
  }

  //获取APP设置
  AppSettings getAppSettings() {
    return appSettings;
  }

  //更新APP设置
  void setAppSettings(AppSettings settings) {
    appSettings = settings;
    SettingsHive.setSettings(settings);
    notifyListeners();
  }

  //切换APP主题
  void toggleThemeMode(ThemeMode themeMode) {
    final settings = appSettings.copyWith(
      appearance: appSettings.appearance.copyWith(themeMode: themeMode),
    );
    setAppSettings(settings);
  }

  //切换是否隐藏到托盘
  void toggleHideInSystemTray(bool hide) {
    final settings = appSettings.copyWith(
      commonSettings: appSettings.commonSettings.copyWith(
        hideToTrayWhenClose: hide,
      ),
    );
    setAppSettings(settings);
  }

  //更新代理设置
  void updateProxySettings({
    bool? inboundSystemProxy,
    bool? inboundAllowAlan,
    int? inboundHttpPort,
    int? inboundSocksPort,
    bool? isTunEnabled,
  }) {
    final settings = appSettings.copyWith(
      proxySettings: appSettings.proxySettings.copyWith(
        inboundSystemProxy: inboundSystemProxy,
        inboundAllowAlan: inboundAllowAlan,
        inboundHttpPort: inboundHttpPort,
        inboundSocksPort: inboundSocksPort,
        isTunEnabled: isTunEnabled,
      ),
    );
    setAppSettings(settings);
    if (inboundSystemProxy != null || inboundHttpPort != null) {
      setupSystemProxy(settings.proxySettings);
    }
  }

  //设置系统代理
  void setupSystemProxy(ProxySettings proxySettings) {
    ProxyManager proxyManager = ProxyManager();
    if (proxySettings.inboundHttpPort > 0) {
      if (proxySettings.inboundSystemProxy) {
        proxyManager.setAsSystemProxy(ProxyTypes.http, '127.0.0.1', proxySettings.inboundHttpPort);
      } else {
        proxyManager.cleanSystemProxy();
      }
    } else {
      proxyManager.cleanSystemProxy();
    }
  }
}
