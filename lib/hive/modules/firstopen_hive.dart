//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/26
//
import 'package:hive_flutter/hive_flutter.dart';

import '../hive_boxes.dart';

class FirstOpenHive {
  const FirstOpenHive._();

  /// 目前写死了 3.0
  static const String _keyFirstOpen = 'firstOpen_3.0';
  static const String _keyFirstConnectVpn = 'firstConnectVpn_3.0';

  /// 判断当前版本是否是第一次打开
  static bool isFirstOpen(Box box) {
    return box.get(_keyFirstOpen, defaultValue: true);
  }

  /// 获取当前版本是否是第一次打开
  static bool getFirstOpen() {
    final box = Hive.box(HiveBoxes.firstOpenBox);
    return box.get(_keyFirstOpen, defaultValue: true);
  }

  /// 设置是否首次打开
  static Future<void> setFirstOpen(bool value) {
    final box = Hive.box(HiveBoxes.firstOpenBox);
    return box.put(_keyFirstOpen, value);
  }

  /// 获取当前版本是否是第一次连接VPN
  static bool getFirstConnectVpn() {
    final box = Hive.box(HiveBoxes.firstOpenBox);
    return box.get(_keyFirstConnectVpn, defaultValue: true);
  }

  /// 设置是否首次连接VPN
  static Future<void> setFirstConnectVpn(bool value) {
    final box = Hive.box(HiveBoxes.firstOpenBox);
    return box.put(_keyFirstConnectVpn, value);
  }

  /// 重置
  static void deleteFirstOpen() {
    final box = Hive.box(HiveBoxes.firstOpenBox);
    box.delete(_keyFirstOpen);
    box.delete(_keyFirstConnectVpn);
  }
}
