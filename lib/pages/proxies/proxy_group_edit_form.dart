//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/8/20
//
import 'package:canis/api/api.dart';
import 'package:canis/extensions/extensions.dart';
import 'package:canis/model/proxy_group.dart';
import 'package:canis/providers/proxies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProxyGroupEditForm extends StatefulWidget {
  const ProxyGroupEditForm({super.key, this.proxyGroup});

  final ProxyGroup? proxyGroup;

  @override
  State<ProxyGroupEditForm> createState() => _ProxyGroupEditFormState();
}

class _ProxyGroupEditFormState extends State<ProxyGroupEditForm> {
  late TextEditingController _subscriptionUrlController;

  late TextEditingController _refreshIntervalController;

  late TextEditingController _remarkController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _subscriptionUrlController = TextEditingController(text: widget.proxyGroup?.subscriptionUrl?.toString());
    _refreshIntervalController = TextEditingController(text: widget.proxyGroup?.refreshInterval?.toString());
    _remarkController = TextEditingController(text: widget.proxyGroup?.remark);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _subscriptionUrlController,
              decoration: InputDecoration(
                labelText: "订阅地址：",
                hintText: "必填，请输入订阅URL地址",
                // floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return '请输入订阅地址';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _refreshIntervalController,
              decoration: InputDecoration(
                labelText: "自动刷新：",
                hintText: "选填（单位秒）",
                // floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            TextFormField(
              controller: _remarkController,
              decoration: InputDecoration(
                labelText: "备注：",
                hintText: "长度不超过20字",
                // floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (String? value) {
                if (value != null && value.length > 20) {
                  return '备注文字不能超过20字';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(25),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                    child: Text("取消"),
                  ),
                  onTap: () => context.navigator.pop(),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(25),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                    child: Text(widget.proxyGroup == null ? "添加" : "保存"),
                  ),
                  onTap: saveProxyGroup,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //添加或保存代理组
  void saveProxyGroup() async {
    if (_formKey.currentState!.validate()) {
      //请求订阅地址
      final proxyGroupInfo =
      await fetchSubscriptionInfo(widget.proxyGroup?.id, _subscriptionUrlController.text);
      if (proxyGroupInfo != null) {
        if (widget.proxyGroup != null) {
          context.read<ProxiesProvider>().updateProxyGroup(proxyGroupInfo.copyWith(
            id: widget.proxyGroup!.id,
            refreshInterval: _refreshIntervalController.text.isNotEmpty
                ? int.parse(_refreshIntervalController.text)
                : null,
            remark: _remarkController.text,
          ));
          Navigator.of(context).pop();
        } else {
          var isExists = context.read<ProxiesProvider>().checkGroupIsExists(proxyGroupInfo.id);
          if (isExists) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("保存失败，当前分组已存在")));
            return;
          }
          final newProxyGroup = proxyGroupInfo.copyWith(
            refreshInterval: _refreshIntervalController.text.isNotEmpty
                ? int.parse(_refreshIntervalController.text)
                : null,
            remark: _remarkController.text,
          );
          context.read<ProxiesProvider>().addProxyGroup(newProxyGroup);
          Navigator.of(context).pop(newProxyGroup);
        }
      }
    }
  }

  Future<ProxyGroup?> fetchSubscriptionInfo(String? groupId, String subscriptionUrl) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 30),
                Text("更新中..."),
              ],
            ),
          ),
        );
      },
    );
    try {
      String? currentIp;
      if (groupId != null) {
        currentIp = context.read<ProxiesProvider>().getFirstIp(groupId);
      }
      final proxyGroup = await Api.getSubscription(subscriptionUrl, currentIp: currentIp);
      Navigator.of(context).pop();
      return proxyGroup;
    } catch (e) {
      print('获取订阅失败, $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("获取订阅失败")));
      Navigator.of(context).pop();
      return null;
    }
  }
}
