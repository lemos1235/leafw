//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/8/19
//
import 'package:canis/api/api.dart';
import 'package:canis/constant/proxy_type.dart';
import 'package:canis/extensions/extensions.dart';
import 'package:canis/model/proxy.dart';
import 'package:canis/model/proxy_group.dart';
import 'package:canis/pages/proxies/proxy_edit_form.dart';
import 'package:canis/pages/proxies/proxy_group_edit_form.dart';
import 'package:canis/providers/proxies_provider.dart';
import 'package:canis/widgets/shadow_card.dart';
import 'package:canis/widgets/tapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_leaf/flutter_leaf.dart';
import 'package:flutter_leaf/state.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

const double kProxyTypeMenuWidth = 150.0;

enum ProxyGroupItemMenu { edit, delete }

class ProxiesPage extends StatefulWidget {
  const ProxiesPage({super.key});

  @override
  State<ProxiesPage> createState() => _ProxiesPageState();
}

class _ProxiesPageState extends State<ProxiesPage> {
  ProxyType _proxyType = ProxyType.local;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProxyTypesMenu(
          current: _proxyType,
          onChanged: (value) {
            setState(() {
              _proxyType = value;
            });
          },
        ),
        Expanded(
          child: ProxiesContent(
            proxyType: _proxyType,
          ),
        ),
      ],
    );
  }
}

class ProxyTypesMenu extends StatefulWidget {
  const ProxyTypesMenu({super.key, required this.current, required this.onChanged});

  final void Function(ProxyType) onChanged;

  final ProxyType current;

  @override
  State<ProxyTypesMenu> createState() => _ProxyTypesMenuState();
}

class _ProxyTypesMenuState extends State<ProxyTypesMenu> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFF6F7F8),
      child: Container(
        alignment: Alignment.topLeft,
        width: kProxyTypeMenuWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 20, bottom: 30),
                child: Text("类型", style: context.textTheme.titleLarge),
              ),
              for (final type in ProxyType.values)
                ListTile(
                  title: Text(type.title),
                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  selectedTileColor: Color(0xFFEAECF0),
                  selectedColor: context.colorScheme.primary,
                  selected: type == widget.current,
                  onTap: () {
                    widget.onChanged(type);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProxiesContent extends StatefulWidget {
  const ProxiesContent({super.key, required this.proxyType});

  final ProxyType proxyType;

  @override
  State<ProxiesContent> createState() => _ProxiesContentState();
}

class _ProxiesContentState extends State<ProxiesContent> {
  late List<ProxyGroup> proxyGroupList;

  late FlutterLeafState vpnState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    proxyGroupList = context.watch<ProxiesProvider>().getProxyGroupList();
    vpnState = context.watch<ProxiesProvider>().getCurrentVpnState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final group = proxyGroupList[index];
        if (group.type.index != widget.proxyType.value) {
          return SizedBox.shrink();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.proxyType == ProxyType.subscription ? _buildGroupTitle(group) : SizedBox(height: 10),
            ProxyList(
              proxyList: group.proxyList,
              vpnState: vpnState,
            ),
          ],
        );
      },
      itemCount: proxyGroupList.length,
    );
  }

  Widget _buildGroupTitle(ProxyGroup group) {
    final vpnStatusIcon = Icon(
      Icons.circle,
      size: 8,
      color: (group.isCurrent && vpnState == FlutterLeafState.connected)
          ? context.colorScheme.primary
          : Colors.grey,
    );
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 15, right: 10, top: 10, bottom: 10),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text((group.remark?.isNotEmpty ?? false) ? group.remark! : group.groupName),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: vpnStatusIcon,
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RefreshSubscriptionButton(
                      groupId: group.id,
                      subscriptionUrl: group.subscriptionUrl!,
                    ),
                    SizedBox(width: 4),
                    PopupMenuButton<ProxyGroupItemMenu>(
                      padding: EdgeInsets.all(3),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Icon(
                          LucideIcons.moreVertical,
                          color: context.isDark ? Colors.white70 : Colors.black87,
                          size: 18,
                        ),
                      ),
                      onSelected: (ProxyGroupItemMenu item) {
                        if (item == ProxyGroupItemMenu.edit) {
                          showEditDialog(group);
                        } else if (item == ProxyGroupItemMenu.delete) {
                          showDeleteDialog(group.id);
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<ProxyGroupItemMenu>>[
                        if (group.type != ProxyGroupType.local)
                          const PopupMenuItem<ProxyGroupItemMenu>(
                            value: ProxyGroupItemMenu.edit,
                            child: Text('编辑'),
                          ),
                        const PopupMenuItem<ProxyGroupItemMenu>(
                          value: ProxyGroupItemMenu.delete,
                          child: Text('删除'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteDialog(String groupId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "警告",
            style: TextStyle(fontSize: 18),
          ),
          content: Text("确认删除此订阅组？"),
          actions: <Widget>[
            TextButton(
              onPressed: () => context.navigator.pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ProxiesProvider>().deleteProxyGroup(groupId);
                context.navigator.pop();
              },
              child: const Text('确认'),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(ProxyGroup proxyGroup) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 320),
              child: ProxyGroupEditForm(
                proxyGroup: proxyGroup,
              ),
            )
          ],
        );
      },
    );
  }
}

class RefreshSubscriptionButton extends StatefulWidget {
  const RefreshSubscriptionButton({Key? key, required this.groupId, required this.subscriptionUrl})
      : super(key: key);

  final String groupId;

  final String subscriptionUrl;

  @override
  State<RefreshSubscriptionButton> createState() => _RefreshSubscriptionButtonState();
}

class _RefreshSubscriptionButtonState extends State<RefreshSubscriptionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Tapper(
      onTap: _refreshSubscription,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 7),
        child: RotationTransition(
          turns: _controller,
          child: Icon(
            LucideIcons.refreshCw,
            color: context.isDark ? Colors.white70 : Colors.black87,
            size: 16,
          ),
        ),
      ),
    );
  }

  void _refreshSubscription() async {
    if (_controller.isAnimating) {
      return;
    }
    _controller.repeat();
    try {
      final currentIp = context.read<ProxiesProvider>().getFirstIp(widget.groupId);
      var dataList = await Future.wait([
        Api.getSubscription(widget.subscriptionUrl, currentIp: currentIp),
        Future.delayed(Duration(seconds: 2)),
      ]);
      final subscription = dataList.first;
      if (widget.groupId == subscription.id) {
        context.read<ProxiesProvider>().updateSubscription(subscription);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("已更新")));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("分组错误")));
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("更新失败")));
      }
    } finally {
      if (mounted) {
        _controller.reset();
      }
    }
  }
}

class ProxyList extends StatefulWidget {
  const ProxyList({super.key, required this.proxyList, required this.vpnState});

  final List<Proxy> proxyList;

  final FlutterLeafState vpnState;

  @override
  State<ProxyList> createState() => _ProxyListState();
}

class _ProxyListState extends State<ProxyList> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final proxy in widget.proxyList) buildProxyItem(proxy),
      ],
    );
  }

  Widget buildProxyItem(Proxy proxy) {
    final itemContent = Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                proxy.getName(),
                style: TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tapper(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        LucideIcons.trash2,
                        size: 16,
                      ),
                    ),
                    onTap: () {
                      showDeleteDialog(proxy);
                    },
                  ),
                  Tapper(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        LucideIcons.edit3,
                        size: 16,
                      ),
                    ),
                    onTap: () {
                      showEditDialog(proxy);
                    },
                  ),
                ],
              ),
            ],
          ),
          Divider(color: context.isDark ? Colors.black54 : Color(0xFFEEEEEE)),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text("地址："),
                    Text(proxy.host),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text("端口："),
                    Text(proxy.port.toString()),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text("协议："),
                    Text(proxy.scheme),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text("认证："),
                    Text((proxy.username?.isNotEmpty ?? false) ? "有" : "无"),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
    if (proxy.isCurrent) {
      return Theme(
        data: context.theme.copyWith(
          textTheme: context.theme.textTheme.copyWith(
            bodyMedium: TextStyle(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        child: ShadowCard(
          margin: EdgeInsets.only(bottom: 15, left: 10, right: 10),
          color: context.theme.cardTheme.color,
          child: itemContent,
        ),
      );
    } else {
      return Tapper(
        onTap: () => switchProxy(proxy),
        child: ShadowCard(
          margin: EdgeInsets.only(bottom: 15, left: 10, right: 10),
          color: context.theme.cardTheme.color,
          child: itemContent,
        ),
      );
    }
  }

  void switchProxy(Proxy proxy) async {
    context.read<ProxiesProvider>().setCurrent(proxy.id, proxy.groupId);
    if (widget.vpnState == FlutterLeafState.connected) {
      FlutterLeaf.switchProxy(configContent: proxy.toConfig());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("已切换")));
    }
  }

  void showDeleteDialog(Proxy proxy) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "警告",
            style: TextStyle(fontSize: 18),
          ),
          content: Text("确认删除此节点？"),
          actions: <Widget>[
            TextButton(
              onPressed: () => context.navigator.pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ProxiesProvider>().deleteProxy(proxy.id, proxy.groupId);
                context.navigator.pop();
              },
              child: const Text('确认'),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(Proxy proxy) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 320),
              child: ProxyEditForm(
                proxy: proxy,
              ),
            )
          ],
        );
      },
    );
  }
}
