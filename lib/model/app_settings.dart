//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/6/4
//
import 'package:flutter/material.dart';
import 'package:canis/extensions/extensions.dart';

class AppSettings {
  final Appearance appearance;
  final ProxySettings proxySettings;

  AppSettings({
    this.appearance = const Appearance(),
    this.proxySettings = const ProxySettings(),
  });

  AppSettings copyWith({
    Appearance? appearance,
    ProxySettings? proxySettings,
  }) {
    return AppSettings(
      appearance: appearance ?? this.appearance,
      proxySettings: proxySettings ?? this.proxySettings,
    );
  }

  factory AppSettings.fromJson(dynamic json) {
    return AppSettings(
      appearance: Appearance.fromJson(json['appearance']),
      proxySettings: ProxySettings.fromJson(json['proxySettings']),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['appearance'] = appearance.toJson();
    map['proxySettings'] = proxySettings.toJson();
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

class ProxySettings {
  const ProxySettings({this.inboundAllowAlan = false, this.inboundHttpPort = 0, this.inboundSocksPort = 0});

  final bool inboundAllowAlan;

  final int inboundHttpPort;

  final int inboundSocksPort;

  ProxySettings copyWith({
    bool? inboundAllowAlan,
    int? inboundHttpPort,
    int? inboundSocksPort,
  }) {
    return ProxySettings(
      inboundAllowAlan: inboundAllowAlan ?? this.inboundAllowAlan,
      inboundHttpPort: inboundHttpPort ?? this.inboundHttpPort,
      inboundSocksPort: inboundSocksPort ?? this.inboundSocksPort,
    );
  }

  factory ProxySettings.fromJson(dynamic json) {
    return ProxySettings(
      inboundAllowAlan: json['inboundAllowAlan'],
      inboundHttpPort: json['inboundHttpPort'],
      inboundSocksPort: json['inboundSocksPort'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['inboundAllowAlan'] = inboundAllowAlan;
    map['inboundHttpPort'] = inboundHttpPort;
    map['inboundSocksPort'] = inboundSocksPort;
    return map;
  }
}
