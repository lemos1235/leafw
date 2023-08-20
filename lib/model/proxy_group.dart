//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/21
//
import 'package:canis/model/proxy.dart';

enum ProxyGroupType {
  local,
  subscription,
}

class ProxyGroup {
  final String id;
  final String groupName;
  final ProxyGroupType type;
  final String? subscriptionUrl;
  final int? refreshInterval;
  final int? expire;
  final String? remark;

  List<Proxy> proxyList;

  bool isCurrent = false;

  ProxyGroup({
    required this.id,
    required this.groupName,
    required this.type,
    this.subscriptionUrl,
    this.refreshInterval,
    this.expire,
    this.remark,
    this.proxyList = const [],
    this.isCurrent = false,
  });

  ProxyGroup copyWith({
    String? id,
    String? groupName,
    ProxyGroupType? type,
    String? subscriptionUrl,
    int? refreshInterval,
    int? expire,
    String? remark,
    List<Proxy>? proxyList,
    bool? isCurrent,
  }) {
    return ProxyGroup(
      id: id ?? this.id,
      groupName: groupName ?? this.groupName,
      type: type ?? this.type,
      subscriptionUrl: subscriptionUrl ?? this.subscriptionUrl,
      refreshInterval: refreshInterval ?? this.refreshInterval,
      expire: expire ?? this.expire,
      remark: remark ?? this.remark,
      proxyList: proxyList ?? this.proxyList,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }

  factory ProxyGroup.clone(ProxyGroup group) {
    return ProxyGroup(
      id: group.id,
      groupName: group.groupName,
      type: group.type,
      subscriptionUrl: group.subscriptionUrl,
      refreshInterval: group.refreshInterval,
      expire: group.expire,
      remark: group.remark,
      proxyList: group.proxyList,
    );
  }

  factory ProxyGroup.fromJson(dynamic json) {
    final proxyGroup = ProxyGroup(
      id: json['id'],
      groupName: json['groupName'],
      type: ProxyGroupType.values[json['type']],
      subscriptionUrl: json['subscriptionUrl'],
      refreshInterval: json['refreshInterval'],
      expire: json['expire'],
      remark: json['remark'],
    );
    if (json['proxyList'] != null) {
      List<Proxy> proxyList = [];
      json['proxyList'].forEach((v) {
        proxyList.add(Proxy.fromJson(v));
      });
      proxyGroup.proxyList = proxyList;
    }
    return proxyGroup;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['groupName'] = groupName;
    map['type'] = type.index;
    map['subscriptionUrl'] = subscriptionUrl;
    map['refreshInterval'] = refreshInterval;
    map['expire'] = expire;
    map['remark'] = remark;
    map['proxyList'] = proxyList.map((v) => v.toJson()).toList();
    return map;
  }
}
