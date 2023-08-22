//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/8/22
//
import 'package:canis/extensions/extensions.dart';
import 'package:canis/model/app_settings.dart';
import 'package:canis/providers/settings_provider.dart';
import 'package:canis/widgets/shadow_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

const double kSettingsSubMenuWidth = 150.0;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsMenuIndex _menuIndex = SettingsMenuIndex.general;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SettingsMenu(
          current: _menuIndex,
          onChanged: (value) {
            setState(() {
              _menuIndex = value;
            });
          },
        ),
        Expanded(
          child: SettingsContent(
            menuIndex: _menuIndex,
          ),
        ),
      ],
    );
  }
}

enum SettingsMenuIndex {
  general,
  advanced,
}

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({super.key, required this.onChanged, required this.current});

  final void Function(SettingsMenuIndex) onChanged;

  final SettingsMenuIndex current;

  @override
  Widget build(BuildContext context) {
    Color bgColor = context.isDark ? Color(0xFF2D2D2D) : Color(0xFFF6F7F8);
    Color selectedTextColor = context.isDark ? Color(0xFF4B4B4B) : Color(0xFFEAECF0);
    return Material(
      color: bgColor,
      child: Container(
        alignment: Alignment.topLeft,
        width: kSettingsSubMenuWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 20, bottom: 30),
                child: Text("设置", style: context.textTheme.titleLarge),
              ),
              ListTile(
                title: Text("基础设置"),
                shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
                selectedTileColor: selectedTextColor,
                selectedColor: context.colorScheme.primary,
                selected: SettingsMenuIndex.general == current,
                onTap: () {
                  onChanged(SettingsMenuIndex.general);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsContent extends StatefulWidget {
  const SettingsContent({super.key, required this.menuIndex});

  final SettingsMenuIndex menuIndex;

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  @override
  Widget build(BuildContext context) {
    return widget.menuIndex == SettingsMenuIndex.general ? GeneralSettings() : AdvancedSettings();
  }
}

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  bool _isBootStartup = false;

  bool _allowLan = false;

  late AppSettings appSettings;

  late TextEditingController _socksPortController;
  late TextEditingController _httpPortController;

  @override
  void initState() {
    super.initState();
    _socksPortController = TextEditingController(text: "10808");
    _httpPortController = TextEditingController(text: "10808");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appSettings = context.watch<SettingsProvider>().getAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 10),
        ShadowCard(
          margin: EdgeInsets.only(bottom: 15, left: 10, right: 10),
          color: context.theme.cardTheme.color,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("开机时启动"),
                          SizedBox(
                            height: 28,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Switch(
                                  value: _isBootStartup,
                                  onChanged: (val) {
                                    setState(() {
                                      _isBootStartup = val;
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 80),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("主题"),
                          SizedBox(
                            height: 28,
                            child: FittedBox(
                                fit: BoxFit.fill,
                                child: SegmentedButton<ThemeMode>(
                                  selected: {appSettings.appearance.themeMode},
                                  segments: [
                                    for (final mode in ThemeMode.values)
                                      ButtonSegment(
                                        value: mode,
                                        label: Text(mode.humanName),
                                      )
                                  ],
                                  onSelectionChanged: (Set<ThemeMode> val) {
                                    context.read<SettingsProvider>().toggleThemeMode(val.first);
                                  },
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        ShadowCard(
          margin: EdgeInsets.only(bottom: 15, left: 10, right: 10),
          color: context.theme.cardTheme.color,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("局域网代理共享"),
                          SizedBox(
                            height: 28,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Switch(
                                  value: _allowLan,
                                  onChanged: (val) {
                                    setState(() {
                                      _allowLan = val;
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 80),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("SOCKS5 代理端口"),
                          SizedBox(
                            width: 74,
                            child: TextField(
                              controller: _socksPortController,
                              style: TextStyle(fontSize: 14),
                              strutStyle: StrutStyle(fontSize: 14.0),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isCollapsed: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("HTTP 代理端口"),
                          SizedBox(
                            width: 74,
                            child: TextField(
                              controller: _httpPortController,
                              style: TextStyle(fontSize: 14),
                              strutStyle: StrutStyle(fontSize: 14.0),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isCollapsed: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 80),
                    Expanded(child: Row()),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AdvancedSettings extends StatefulWidget {
  const AdvancedSettings({super.key});

  @override
  State<AdvancedSettings> createState() => _AdvancedSettingsState();
}

class _AdvancedSettingsState extends State<AdvancedSettings> {
  @override
  Widget build(BuildContext context) {
    return const Text("Advanced");
  }
}
