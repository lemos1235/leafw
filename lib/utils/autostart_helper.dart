import 'dart:io';

import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AutostartHelper {
  static Future<bool> isAutoStartEnabled() async {
    final packageInfo = await PackageInfo.fromPlatform();
    launchAtStartup.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
    );
    return await launchAtStartup.isEnabled();
  }

  static Future<bool> enableAutoStart() async {
    final packageInfo = await PackageInfo.fromPlatform();
    launchAtStartup.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
    );
    return await launchAtStartup.enable();
  }

  static Future<bool> disableAutoStart() async {
    final packageInfo = await PackageInfo.fromPlatform();
    launchAtStartup.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
    );
    return launchAtStartup.disable();
  }
}
