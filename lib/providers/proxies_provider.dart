//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/13
//
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:canis/api/api.dart';
import 'package:canis/hive/modules/proxies_hive.dart';
import 'package:canis/model/proxy.dart';
import 'package:canis/model/proxy_group.dart';
import 'package:flutter_leaf/flutter_leaf.dart';
import 'package:flutter_leaf/state.dart';

class ProxiesProvider with ChangeNotifier {
  List<ProxyGroup> proxyGroupList = [];

  /// 自动刷新定时器
  /// 当前节点指vpn状态是连接状态下的当前被激活的节点
  /// 需要定时刷新的条件：当前节点定时刷新间隔大于0
  /// 需要取消定时刷新的情况：
  /// 1.当前vpn状态由连接改为未连接
  /// 2.当前节点由需要自动刷新改为不需要自动刷新（包括当前节点发生切换和当前节点自身发生更新两种情况）
  /// 3.当前节点需要更改刷新间隔（暂不明确考虑该情况，节点更新即重置）
  /// 4.自动刷新的节点被删除了
  Timer? autoRefreshTimer;

  String? currentId;

  String? currentGroupId;

  FlutterLeafState vpnState = FlutterLeafState.disconnected;

  ///代理节点初始化
  Future<void> initialize() async {
    currentId = ProxiesHive.getCurrentId();
    currentGroupId = ProxiesHive.getCurrentGroupId();
    proxyGroupList = ProxiesHive.getProxyGroupList();
    // FlutterLeaf.prepare();
    // final flutterVpnState = await FlutterLeaf.currentState;
    // vpnState = flutterVpnState;
    // notifyListeners();
    // // 定时刷新
    // if (vpnState == FlutterLeafState.connected) {
    //   for (final group in proxyGroupList) {
    //     if (group.id == currentGroupId) {
    //       _handleAutoRefresh(group);
    //     }
    //   }
    // }
    // FlutterLeaf.onStateChanged.listen((s) {
    //   vpnState = s;
    //   notifyListeners();
    //   if (vpnState == FlutterLeafState.disconnected) {
    //     autoRefreshTimer?.cancel();
    //   } else if (vpnState == FlutterLeafState.connected) {
    //     final newProxyGroup = proxyGroupList.firstWhere((element) => element.id == currentGroupId);
    //     _handleAutoRefresh(newProxyGroup);
    //   }
    // });
  }

  ///获取当前vpn状态
  FlutterLeafState getCurrentVpnState() {
    return vpnState;
  }

  ///获取代理组列表
  List<ProxyGroup> getProxyGroupList() {
    //这里每条数据复制一份，防止在编辑页操作时，直接更新了原始值
    return proxyGroupList.map((g) {
      if (g.id == currentGroupId) {
        final proxyList = g.proxyList.map((p) {
          if (p.id == currentId) {
            return p.copyWith(isCurrent: true);
          } else {
            return p.copyWith(isCurrent: false);
          }
        }).toList();
        return g.copyWith(isCurrent: true, proxyList: proxyList);
      } else {
        final proxyList = g.proxyList.map((p) {
          return p.copyWith(isCurrent: false);
        }).toList();
        return g.copyWith(isCurrent: false, proxyList: proxyList);
      }
    }).toList();
  }

  ///设置当前代理组和代理节点
  void setCurrent(String id, String groupId) {
    currentId = id;
    if (groupId != currentGroupId) {
      //当前代理组更新了，自动刷新订阅也需要更新
      currentGroupId = groupId;
      final newProxyGroup = proxyGroupList.firstWhere((element) => element.id == currentGroupId);
      _handleAutoRefresh(newProxyGroup);
    }
    ProxiesHive.setCurrentId(id);
    ProxiesHive.setCurrentGroupId(groupId);
    notifyListeners();
  }

  ///获取当前代理组
  ProxyGroup? getProxyGroup(String groupId) {
    return proxyGroupList.firstWhereOrNull((e) => e.id == groupId);
  }

  ///检查当前分组是否已存在
  ///手动/扫码添加订阅的时候需要判断，如果已存在，则不让添加新分组
  bool checkGroupIsExists(String groupId) {
    return proxyGroupList.indexWhere((element) => element.id == groupId) != -1;
  }

  ///添加新代理组
  ///初次添加，第一个代理节点自动为默认代理
  void addProxyGroup(ProxyGroup newProxyGroup) {
    final oldGroupList = proxyGroupList;
    proxyGroupList = [...oldGroupList, newProxyGroup];
    if (oldGroupList.isEmpty && newProxyGroup.proxyList.isNotEmpty) {
      setCurrent(newProxyGroup.proxyList.first.id, newProxyGroup.id);
    }
    ProxiesHive.setProxyGroupList(proxyGroupList);
    notifyListeners();
  }

  ///删除代理组
  void deleteProxyGroup(String groupId) {
    final filtered = proxyGroupList.whereNotIndexed((index, element) => element.id == groupId).toList();
    proxyGroupList = filtered;
    ProxiesHive.setProxyGroupList(proxyGroupList);
    notifyListeners();
  }

  ///更新代理组
  void updateProxyGroup(ProxyGroup groupItem) {
    final cloned = ProxyGroup.clone(groupItem);
    final groupIndex = proxyGroupList.indexWhere((e) => e.id == groupItem.id);
    proxyGroupList[groupIndex] = cloned;
    ProxiesHive.setProxyGroupList(proxyGroupList);
    notifyListeners();
    //定时刷新
    if (groupItem.id == currentGroupId) {
      _handleAutoRefresh(cloned);
    }
  }

  ///获取当前代理
  Proxy? getCurrentProxy() {
    if (currentGroupId != null && currentId != null) {
      final proxyGroup = proxyGroupList.firstWhereOrNull((element) => element.id == currentGroupId);
      if (proxyGroup != null) {
        return proxyGroup.proxyList.firstWhereOrNull((element) => element.id == currentId);
      }
    }
    return null;
  }

  ///添加代理
  void addProxy(Proxy newProxy) {
    final oldGroupList = proxyGroupList;
    final groupIndex = oldGroupList.indexWhere((e) => e.id == newProxy.groupId);
    if (groupIndex != -1) {
      final oldGroup = proxyGroupList[groupIndex];
      proxyGroupList[groupIndex] = oldGroup.copyWith(proxyList: [...oldGroup.proxyList, newProxy]);
      ProxiesHive.setProxyGroupList(proxyGroupList);
      notifyListeners();
    } else {
      //默认分组 <=> 本地节点
      final newProxyGroup = ProxyGroup(
        id: newProxy.groupId,
        groupName: "本地节点",
        type: ProxyGroupType.local,
        proxyList: [newProxy],
      );
      proxyGroupList = [...oldGroupList, newProxyGroup];
      if (oldGroupList.isEmpty) {
        setCurrent(newProxy.id, newProxy.groupId);
      }
      ProxiesHive.setProxyGroupList(proxyGroupList);
      notifyListeners();
    }
  }

  ///删除代理
  void deleteProxy(String id, String groupId) {
    final groupIndex = proxyGroupList.indexWhere((e) => e.id == groupId);
    final proxyGroup = proxyGroupList[groupIndex];
    final filtered = proxyGroup.proxyList.whereNotIndexed((index, element) => element.id == id).toList();
    proxyGroupList[groupIndex] = proxyGroup.copyWith(proxyList: filtered);
    ProxiesHive.setProxyGroupList(proxyGroupList);
    notifyListeners();
  }

  ///更新代理
  void updateProxy(Proxy proxy) {
    final groupIndex = proxyGroupList.indexWhere((e) => e.id == proxy.groupId);
    final proxyGroup = proxyGroupList[groupIndex];
    List<Proxy> cloneList = List.from(proxyGroup.proxyList);
    final index = cloneList.indexWhere((element) => element.id == proxy.id);
    cloneList[index] = proxy;
    proxyGroupList[groupIndex] = proxyGroup.copyWith(proxyList: cloneList);
    ProxiesHive.setProxyGroupList(proxyGroupList);
    if (vpnState == FlutterLeafState.connected && proxy.groupId == currentGroupId && proxy.id == currentId) {
      FlutterLeaf.switchProxy(configContent: proxy.toConfig());
    }
    notifyListeners();
  }

  ///更新某分组的代理节点列表
  void _updateProxyList(int groupIndex, ProxyGroup newGroup) {
    final oldGroup = proxyGroupList[groupIndex];
    final finalGroup = oldGroup.copyWith(
      expire: newGroup.expire,
      proxyList: newGroup.proxyList,
    );
    proxyGroupList[groupIndex] = finalGroup;
    ProxiesHive.setProxyGroupList(proxyGroupList);
    notifyListeners();
    //切换代理
    if (vpnState == FlutterLeafState.connected && finalGroup.id == currentGroupId) {
      final proxy = finalGroup.proxyList.firstWhereOrNull((e) => e.id == currentId);
      if (proxy != null) {
        FlutterLeaf.switchProxy(configContent: proxy.toConfig());
      } else {
        //如果当前组下的代理由于更新而被删除了，则断开连接
        FlutterLeaf.disconnect();
      }
    }
  }

  ///获取当前正在使用的IP
  String? getUsingIp() {
    if (vpnState == FlutterLeafState.connected) {
      var currentProxy = getCurrentProxy();
      if (currentProxy != null) {
        return "${currentProxy.host}:${currentProxy.port}";
      }
    }
    return null;
  }

  ///获取订阅列表中的第一个IP
  String? getFirstIp(String groupId) {
    final group = proxyGroupList.firstWhereOrNull((element) => element.id == groupId);
    Proxy? proxy = group?.proxyList.firstOrNull;
    return proxy != null ? "${proxy.host}:${proxy.port}" : null;
  }

  ///更新订阅
  void updateSubscription(ProxyGroup subscription) {
    final groupIndex = proxyGroupList.indexWhere((e) => e.id == subscription.id);
    if (groupIndex != -1) {
      _updateProxyList(groupIndex, subscription);
    }
  }

  ///处理订阅列表自动刷新
  void _handleAutoRefresh(ProxyGroup newOne) {
    if (vpnState != FlutterLeafState.connected) {
      return;
    }
    //将旧的定时器取消（分两种情况：当前节点由自动刷新改为不需要自动刷新；当前节点需要创建新的自动刷新任务）
    autoRefreshTimer?.cancel();
    final refreshInterval = newOne.refreshInterval;
    if (refreshInterval != null && refreshInterval > 0) {
      try {
        //创建新的定时任务
        final timer = Timer.periodic(Duration(seconds: refreshInterval), (timer) async {
          final groupIndex = proxyGroupList.indexWhere((e) => e.id == newOne.id);
          if (groupIndex == -1) {
            timer.cancel();
            return;
          }
          //请求最新订阅
          final subscription = await Api.getSubscription(newOne.subscriptionUrl!, currentIp: getFirstIp(newOne.id));
          if (newOne.id == subscription.id) {
            _updateProxyList(groupIndex, subscription);
          } else {
            //只有同一个分组可以更新代理节点列表，否则停止更新
            timer.cancel();
          }
        });
        autoRefreshTimer = timer;
      } catch (_) {}
    }
  }
}
