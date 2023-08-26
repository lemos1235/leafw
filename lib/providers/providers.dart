//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/13
//
import 'package:canis/providers/filters_provider.dart';
import 'package:canis/providers/proxies_provider.dart';
import 'package:canis/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providers => _providers;

final List<InheritedProvider<dynamic>> _providers = <InheritedProvider<dynamic>>[
  ChangeNotifierProvider<SettingsProvider>.value(value: SettingsProvider()),
  ChangeNotifierProvider<FiltersProvider>.value(value: FiltersProvider()),
  ChangeNotifierProxyProvider<SettingsProvider, ProxiesProvider>(
    create: (ctx) => ProxiesProvider(settingsProvider: SettingsProvider()),
    update: (ctx, settingsProvider, previous) {
      if (previous != null) {
        previous.settingsProvider = settingsProvider;
        return previous;
      } else {
        return ProxiesProvider(settingsProvider: settingsProvider);
      }
    },
  )
];
