//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/13
//
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:canis/constant/filter_mode.dart';
import 'package:canis/hive/modules/filters_hive.dart';
import 'package:canis/model/filter_app.dart';

class FiltersProvider with ChangeNotifier {
  List<FilterApp> filterAppList = [];

  List<AppInfo> installedAppList = [];

  List<String> internalPackageNames = [
    'club.lemos.canis',
    'com.github.kr328.clash',
    'com.github.shadowsocks'
  ];

  FilterMode currentMode = FilterMode.off;

  Future<void> initialize() async {
    filterAppList = FiltersHive.getFilterAppList();
    currentMode = FiltersHive.getCurrentMode();
    installedAppList = await initializeInstalledAppList();
    notifyListeners();
  }

  //获取内置应用
  List<String> getInternalPackageNames() {
    return internalPackageNames;
  }

  //初始化已安装应用
  Future<List<AppInfo>> initializeInstalledAppList() async {
    final installedApp = (await InstalledApps.getInstalledApps(true, true));
    final visibleAppList =
        installedApp.where((element) => !internalPackageNames.contains(element.packageName)).toList();
    syncFilterAppList(visibleAppList);
    return visibleAppList;
  }

  //获取已安装应用列表
  List<AppInfo> getInstalledAppList() {
    return installedAppList;
  }

  //获取当前模式
  FilterMode getFilterMode() {
    return currentMode;
  }

  //设置当前模式
  void setFilterMode(FilterMode mode) {
    currentMode = mode;
    FiltersHive.setCurrentMode(mode);
    notifyListeners();
  }

  //获取应用列表
  String getFilterPackageNames() {
    return filterAppList.map((e) => e.packageName).join(",");
  }

  //获取应用列表
  List<FilterApp> getFilterAppList() {
    return filterAppList;
  }

  //更新应用列表
  void setFilterAppList(List<FilterApp> appList) {
    filterAppList = appList;
    FiltersHive.setFilterAppList(appList);
    notifyListeners();
  }

  //同步拦截应用列表（过滤已卸载的），并返回当前拦截的应用列表
  void syncFilterAppList(List<AppInfo> installedApps) {
    final installedNames = installedApps.map((e) => e.packageName).toSet();
    final appList = filterAppList.where((a) => installedNames.contains(a.packageName)).toList();
    if (appList.length != filterAppList.length) {
      setFilterAppList(appList);
    }
  }

  //添加到拦截应用列表
  void addAppToFilters(String packageName) {
    final appList = [...filterAppList, FilterApp(packageName: packageName)];
    setFilterAppList(appList);
  }

  //从拦截应用列表移除
  void removeAppFromFilters(String packageName) {
    final appList = filterAppList.whereNot((element) => element.packageName == packageName).toList();
    setFilterAppList(appList);
  }
}
