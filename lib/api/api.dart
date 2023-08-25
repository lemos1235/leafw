//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/22
//
import 'package:canis/hive/modules/deviceid_hive.dart';
import 'package:dio/dio.dart';
import 'package:canis/model/upgrade_info.dart';
import 'package:canis/model/proxy_group.dart';
import 'package:canis/utils/net_util.dart';

class Api {
  Api._();

  ///获取订阅
  static Future<ProxyGroup> getSubscription(String subscriptionUrl, {String? currentIp}) async {
    final rawUrl = Uri.parse(subscriptionUrl);
    Map<String, String?> params = Map.from(rawUrl.queryParameters);
    final deviceId = DeviceIdOpenHive.getDeviceId();
    params["macAddr"] = deviceId;
    if (currentIp?.isNotEmpty ?? false) {
      params["curProxyIp"] = currentIp;
    }
    final response = await NetUtil.getUri(rawUrl.replace(queryParameters: params));
    final r = response.data;
    if (r != null) {
      r["subscriptionUrl"] = subscriptionUrl;
    }
    return ProxyGroup.fromJson(r);
  }

  ///获取APP版本更新
  static Future<UpgradeInfo> getAppUpgradeInfo() async {
    final response =
        await NetUtil.getUri(Uri.parse("https://api.xiaoxiangdaili.com/client/android/getAppVersion"));
    return UpgradeInfo.fromJson(response.data);
  }

  ///下载 apk 文件
  static Future<Response> downloadApkFile(String apkUrl, String apkPath,
      {ProgressCallback? onReceiveProgress}) async {
    final response = await NetUtil.downloadFile(apkUrl, apkPath, onReceiveProgress: onReceiveProgress);
    return response;
  }
}
