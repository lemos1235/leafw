//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/6/6
//
import 'package:hive_flutter/hive_flutter.dart';
import 'package:canis/model/app_settings.dart';

import '../hive_boxes.dart';

class SettingsHive {
  const SettingsHive._();

  static const String _keySettings = 'settings';

  /// 获取当前设置
  static AppSettings? getSettings() {
    final box = Hive.box(HiveBoxes.settingsOpenBox);
    final json = box.get(_keySettings);
    return json != null ? AppSettings.fromJson(json) : null;
  }

  /// 保存当前设置
  static Future<void> setSettings(AppSettings value) {
    final box = Hive.box(HiveBoxes.settingsOpenBox);
    return box.put(_keySettings, value.toJson());
  }
}
