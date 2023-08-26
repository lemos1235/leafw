//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/12
//
import 'package:canis/model/app_settings.dart';

class Proxy {
  final String id;
  final String scheme;
  final String host;
  final int port;
  final String? username;
  final String? password;
  final String? label;
  final String groupId;

  bool isCurrent = false;

  //获取名称
  String getName() {
    return (label?.isNotEmpty ?? false) ? label! : host.split(".").last;
  }

  // 转换成配置模板
  String toConfig(ProxySettings proxySettings) {
    final s = StringBuffer();
    s.writeln("[General]");
    s.writeln("loglevel = debug");
    // s.writeln("dns-server = 114.114.114.114");
    //tun
    if (proxySettings.isTunEnabled) {
      s.writeln("tun = auto");
    }
    //端口监听
    if (proxySettings.inboundHttpPort > 0) {
      if (proxySettings.inboundAllowAlan) {
        s.writeln("interface = 0.0.0.0");
      } else {
        s.writeln("interface = 127.0.0.1");
      }
      s.writeln("port = ${proxySettings.inboundHttpPort}");
    }
    if (proxySettings.inboundSocksPort > 0) {
      if (proxySettings.inboundAllowAlan) {
        s.writeln("socks-interface = 0.0.0.0");
      } else {
        s.writeln("socks-interface = 127.0.0.1");
      }
      s.writeln("socks-port = ${proxySettings.inboundSocksPort}");
    }
    s.writeln("[Proxy]");
    s.writeln("Direct = direct");
    //代理
    s.write("SOCKS5 = socks,$host,$port");
    if ((username?.isNotEmpty ?? false) && (password?.isNotEmpty ?? false)) {
      s.write(",username=$username,password=$password");
    }
    s.writeln();
    //规则
    s.writeln("[Rule]");
    s.writeln("FINAL, SOCKS5");
    print('configContent:\n####\n${s.toString()}####\n');
    return s.toString();
  }

  Proxy({
    required this.id,
    required this.scheme,
    required this.host,
    required this.port,
    this.username,
    this.password,
    this.label,
    this.groupId = "0",
    this.isCurrent = false,
  });

  Proxy copyWith({
    String? id,
    String? scheme,
    String? host,
    int? port,
    String? username,
    String? password,
    String? label,
    String? groupId,
    bool? isCurrent,
  }) {
    return Proxy(
      id: id ?? this.id,
      scheme: scheme ?? this.scheme,
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      label: label ?? this.label,
      groupId: groupId ?? this.groupId,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }

  factory Proxy.fromJson(dynamic json) {
    return Proxy(
      id: json['id'],
      scheme: json['scheme'],
      host: json['host'],
      port: json['port'],
      username: json['username'],
      password: json['password'],
      label: json['label'],
      groupId: json['groupId'] ?? "-1",
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['scheme'] = scheme;
    map['host'] = host;
    map['port'] = port;
    map['username'] = username;
    map['password'] = password;
    map['label'] = label;
    map['groupId'] = groupId;
    return map;
  }
}
