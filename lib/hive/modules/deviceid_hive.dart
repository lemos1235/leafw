
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../hive_boxes.dart';

class DeviceIdOpenHive {
  const DeviceIdOpenHive._();

  /// 设备ID
  static const String _keyDeviceId = 'deviceid';

  /// 获取当前设备ID
  static String getDeviceId() {
    final box = Hive.box(HiveBoxes.deviceIdOpenBox);
    if (box.isNotEmpty) {
      final id = box.get(_keyDeviceId);
      if (id != null) {
        return id;
      }
    }
    final id = Uuid().toString();
    setDeviceId(id);
    return id;
  }

  /// 设置设备ID
  static Future<void> setDeviceId(String value) {
    final box = Hive.box(HiveBoxes.deviceIdOpenBox);
    return box.put(_keyDeviceId, value);
  }

}