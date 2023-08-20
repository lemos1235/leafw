//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/13
//
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:canis/model/proxy_group.dart';

import '../hive_boxes.dart';

class ProxiesHive {
  const ProxiesHive._();

  static const String _keyProxyGroupList = 'proxyGroupList';
  static const String _keyCurrentId = 'currentId';
  static const String _keyCurrentGroupId = 'currentGroupId';

  //获取当前激活的代理ID
  static String? getCurrentId() {
    final box = Hive.box(HiveBoxes.proxiesBox);
    return box.get(_keyCurrentId);
  }

  //设置当前激活的代理ID
  static void setCurrentId(String e) {
    final box = Hive.box(HiveBoxes.proxiesBox);
    box.put(_keyCurrentId, e);
  }

  //获取当前激活的代理组ID
  static String? getCurrentGroupId() {
    final box = Hive.box(HiveBoxes.proxiesBox);
    return box.get(_keyCurrentGroupId);
  }

  //设置当前激活的代理组ID
  static void setCurrentGroupId(String e) {
    final box = Hive.box(HiveBoxes.proxiesBox);
    box.put(_keyCurrentGroupId, e);
  }

  //获取代理组列表
  static List<ProxyGroup> getProxyGroupList() {
    final box = Hive.box(HiveBoxes.proxiesBox);
    final data = box.get(_keyProxyGroupList);
    if (data == null) {
      return [];
    }
    List<String> proxyGroupStrList = (data as List).cast<String>();
    return proxyGroupStrList.map((e) => ProxyGroup.fromJson(jsonDecode(e))).toList();
  }

  //设置代理组列表
  static void setProxyGroupList(List<ProxyGroup> proxyGroupList) {
    final box = Hive.box(HiveBoxes.proxiesBox);
    final proxyGroupStrList = proxyGroupList.map((e) => jsonEncode(e.toJson())).toList();
    box.put(_keyProxyGroupList, proxyGroupStrList);
  }
}
