//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/13
//
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:canis/constant/filter_mode.dart';
import 'package:canis/model/filter_app.dart';

import '../hive_boxes.dart';

class FiltersHive {
  const FiltersHive._();

  static const String _keyFilterAppList = 'filterAppList';
  static const String _keyCurrentMode = 'currentMode';

  //获取当前激活的模式
  static FilterMode getCurrentMode() {
    final box = Hive.box(HiveBoxes.filtersBox);
    final data = box.get(_keyCurrentMode);
    if (data == null) {
      return FilterMode.off;
    }
    return FilterMode.getByValue(data);
  }

  //设置当前激活的模式
  static void setCurrentMode(FilterMode e) {
    final box = Hive.box(HiveBoxes.filtersBox);
    box.put(_keyCurrentMode, e.value);
  }

  //获取应用列表
  static List<FilterApp> getFilterAppList() {
    final box = Hive.box(HiveBoxes.filtersBox);
    final data = box.get(_keyFilterAppList);
    if (data == null) {
      return [];
    }
    List<String> appStrList = (data as List).cast<String>();
    return appStrList.map((e) => FilterApp.fromJson(jsonDecode(e))).toList();
  }

  //设置应用列表
  static void setFilterAppList(List<FilterApp> appList) {
    final box = Hive.box(HiveBoxes.filtersBox);
    final appStrList = appList.map((e) => jsonEncode(e.toJson())).toList();
    box.put(_keyFilterAppList, appStrList);
  }
}
