//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/13
//
import 'package:flutter/material.dart';
import 'package:canis/providers/filters_provider.dart';
import 'package:canis/providers/proxies_provider.dart';
import 'package:canis/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

ChangeNotifierProvider<T> buildProvider<T extends ChangeNotifier>(T value) {
  return ChangeNotifierProvider<T>.value(value: value);
}

List<SingleChildWidget> get providers => _providers;

final List<ChangeNotifierProvider<dynamic>> _providers = <ChangeNotifierProvider<dynamic>>[
  buildProvider<ProxiesProvider>(ProxiesProvider()),
  buildProvider<FiltersProvider>(FiltersProvider()),
  buildProvider<SettingsProvider>(SettingsProvider()),
];
