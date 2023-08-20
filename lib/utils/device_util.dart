//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/23
//

import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceUtil {
  const DeviceUtil._();

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static final AndroidId _androidIdPlugin = AndroidId();

  static String? _deviceUuid;

  static Future<void> initDeviceInfo() async {
    if (Platform.isIOS) {
      final iosDeviceInfo = await _deviceInfoPlugin.iosInfo;
      _deviceUuid = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      final androidId = await _androidIdPlugin.getId();
      _deviceUuid = androidId; // unique ID on Android
    }
  }

  static String? getDeviceId() {
    return _deviceUuid;
  }
}
