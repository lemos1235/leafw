//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/8/22
//
import 'package:canis/extensions/extensions.dart';
import 'package:canis/model/app_settings.dart';
import 'package:canis/providers/settings_provider.dart';
import 'package:canis/utils/autostart_helper.dart';
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
  //应用设置
  late AppSettings appSettings;

  //表单设置
  late TextEditingController _socksPortController;
  late TextEditingController _httpPortController;

  //开机自启
  bool _isAutoStartOn = false;

  @override
  void initState() {
    super.initState();
    final appSettings = context.read<SettingsProvider>().getAppSettings();
    _socksPortController = TextEditingController(text: appSettings.proxySettings.inboundSocksPort.toString());
    _httpPortController = TextEditingController(text: appSettings.proxySettings.inboundHttpPort.toString());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      handleAutoStart();
    });
  }

  //开机启动
  void handleAutoStart() async {
    final autoStartOn = await AutostartHelper.isAutoStartEnabled();
    setState(() {
      _isAutoStartOn = autoStartOn;
    });
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
                                  value: _isAutoStartOn,
                                  onChanged: (val) {
                                    setState(() {
                                      _isAutoStartOn = val;
                                      if (_isAutoStartOn) {
                                        AutostartHelper.enableAutoStart();
                                      } else {
                                        AutostartHelper.disableAutoStart();
                                      }
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
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("关闭后隐藏到托盘"),
                          SizedBox(
                            height: 28,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Switch(
                                  value: appSettings.commonSettings.hideToTrayWhenClose,
                                  onChanged: (val) {
                                    context.read<SettingsProvider>().toggleHideInSystemTray(val);
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 80),
                    Spacer(),
                  ],
                )
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
                                  value: appSettings.proxySettings.inboundAllowAlan,
                                  onChanged: (val) {
                                    context.read<SettingsProvider>().updateProxySettings(inboundAllowAlan: val);
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
                            child: Focus(
                              onFocusChange: (gainsFocus) {
                                if (!gainsFocus) {
                                  saveProxySettings();
                                }
                              },
                              child: TextField(
                                controller: _socksPortController,
                                style: TextStyle(fontSize: 13),
                                strutStyle: StrutStyle(fontSize: 13.0),
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isCollapsed: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                ),
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
                            child: Focus(
                              onFocusChange: (gainsFocus) {
                                if (!gainsFocus) {
                                  saveProxySettings();
                                }
                              },
                              child: TextField(
                                controller: _httpPortController,
                                style: TextStyle(fontSize: 13),
                                strutStyle: StrutStyle(fontSize: 13.0),
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isCollapsed: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                ),
                              ),
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
                          Text("设置为系统代理"),
                          SizedBox(
                            height: 28,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Switch(
                                value: appSettings.proxySettings.inboundSystemProxy,
                                onChanged: (val) {
                                  context.read<SettingsProvider>().updateProxySettings(inboundSystemProxy: val);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
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
                          Text("全局代理"),
                          SizedBox(
                            height: 28,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Switch(
                                  value: appSettings.proxySettings.isTunEnabled,
                                  onChanged: (val) {
                                    context.read<SettingsProvider>().updateProxySettings(isTunEnabled: val);
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 80),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //保存代理设置
  void saveProxySettings() {
    final httpPortText = _httpPortController.text;
    final socksPortText = _socksPortController.text;
    context.read<SettingsProvider>().updateProxySettings(
          inboundHttpPort: int.parse(httpPortText),
          inboundSocksPort: int.parse(socksPortText),
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
