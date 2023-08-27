//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/6/4
//
import 'package:flutter/material.dart';
import 'package:canis/extensions/extensions.dart';

class AppSettings {
  final Appearance appearance;
  final ProxySettings proxySettings;
  final CommonSettings commonSettings;

  AppSettings({
    this.appearance = const Appearance(),
    this.proxySettings = const ProxySettings(),
    this.commonSettings = const CommonSettings(),
  });

  AppSettings copyWith({
    Appearance? appearance,
    ProxySettings? proxySettings,
    CommonSettings? commonSettings,
  }) {
    return AppSettings(
      appearance: appearance ?? this.appearance,
      proxySettings: proxySettings ?? this.proxySettings,
      commonSettings: commonSettings ?? this.commonSettings,
    );
  }

  factory AppSettings.fromJson(dynamic json) {
    return AppSettings(
      appearance: Appearance.fromJson(json['appearance']),
      proxySettings: ProxySettings.fromJson(json['proxySettings']),
      commonSettings: CommonSettings.fromJson(json['commonSettings']),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['appearance'] = appearance.toJson();
    map['proxySettings'] = proxySettings.toJson();
    map['commonSettings'] = commonSettings.toJson();
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

class CommonSettings {
  const CommonSettings({this.hideAppWhenStart = false, this.hideToTrayWhenClose = true});

  final bool hideToTrayWhenClose;
  final bool hideAppWhenStart;

  CommonSettings copyWith({
    bool? hideAppWhenStart,
    bool? hideToTrayWhenClose,
  }) {
    return CommonSettings(
      hideAppWhenStart: hideAppWhenStart ?? this.hideAppWhenStart,
      hideToTrayWhenClose: hideToTrayWhenClose ?? this.hideToTrayWhenClose,
    );
  }

  factory CommonSettings.fromJson(dynamic json) {
    return CommonSettings(
      hideAppWhenStart: json['hideAppWhenStart'],
      hideToTrayWhenClose: json['hideToTrayWhenClose'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hideAppWhenStart'] = hideAppWhenStart;
    map['hideToTrayWhenClose'] = hideToTrayWhenClose;
    return map;
  }
}

class ProxySettings {
  const ProxySettings(
      {this.inboundAllowAlan = false, this.inboundHttpPort = 0, this.inboundSocksPort = 0, this.isTunEnabled = false});

  final bool inboundAllowAlan;

  final int inboundHttpPort;

  final int inboundSocksPort;

  final bool isTunEnabled;

  ProxySettings copyWith({
    bool? inboundAllowAlan,
    int? inboundHttpPort,
    int? inboundSocksPort,
    bool? isTunEnabled,
  }) {
    return ProxySettings(
      inboundAllowAlan: inboundAllowAlan ?? this.inboundAllowAlan,
      inboundHttpPort: inboundHttpPort ?? this.inboundHttpPort,
      inboundSocksPort: inboundSocksPort ?? this.inboundSocksPort,
      isTunEnabled: isTunEnabled ?? this.isTunEnabled,
    );
  }

  factory ProxySettings.fromJson(dynamic json) {
    return ProxySettings(
      inboundAllowAlan: json['inboundAllowAlan'],
      inboundHttpPort: json['inboundHttpPort'],
      inboundSocksPort: json['inboundSocksPort'],
      isTunEnabled: json['isTunEnabled'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['inboundAllowAlan'] = inboundAllowAlan;
    map['inboundHttpPort'] = inboundHttpPort;
    map['inboundSocksPort'] = inboundSocksPort;
    map['isTunEnabled'] = isTunEnabled;
    return map;
  }
}
