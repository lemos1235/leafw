//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/8/19
//
import 'package:canis/constant/proxy_type.dart';
import 'package:canis/extensions/extensions.dart';
import 'package:canis/model/proxy.dart';
import 'package:canis/providers/proxies_provider.dart';
import 'package:canis/widgets/tapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProxyEditForm extends StatefulWidget {
  const ProxyEditForm({super.key, this.proxy});

  final Proxy? proxy;

  @override
  State<ProxyEditForm> createState() => _ProxyEditFormState();
}

class _ProxyEditFormState extends State<ProxyEditForm> with TickerProviderStateMixin {
  late TextEditingController _hostController;

  late TextEditingController _portController;

  late TextEditingController _usernameController;

  late TextEditingController _passwordController;

  bool _passwordObscure = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _hostController = TextEditingController(text: widget.proxy?.host);
    _portController = TextEditingController(text: widget.proxy?.port.toString());
    _usernameController = TextEditingController(text: widget.proxy?.username);
    _passwordController = TextEditingController(text: widget.proxy?.password);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 320),
      child: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _hostController,
                decoration: InputDecoration(
                  labelText: "地址：",
                  hintText: "必填，请输入节点的IP地址",
                  // floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return '请输入地址';
                  }
                  try {
                    Uri.parseIPv4Address(value);
                  } catch (e) {
                    return '请输入正确的IP地址';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _portController,
                decoration: InputDecoration(
                  labelText: "端口：",
                  hintText: "必填， 1-65535",
                  // floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return '请输入端口';
                  }
                  if (int.parse(value) < 1 || int.parse(value) > 65535) {
                    return '端口范围须在 1-65535';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "用户：",
                  hintText: "可选的",
                  // floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: _passwordObscure,
                decoration: InputDecoration(
                  labelText: "密码：",
                  hintText: "可选，最大长度128",
                  // floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Tapper(
                      onTap: () {
                        setState(() {
                          _passwordObscure = !_passwordObscure;
                        });
                      },
                      child: Icon(
                        _passwordObscure ? Icons.visibility_off : Icons.visibility,
                        size: 18,
                      )),
                ),
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
                      child: Text(widget.proxy == null ? "添加" : "保存"),
                    ),
                    onTap: saveProxy,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //添加或保存代理
  void saveProxy() {
    if (_formKey.currentState!.validate()) {
      if (widget.proxy != null) {
        context.read<ProxiesProvider>().updateProxy(
          widget.proxy!.copyWith(
            host: _hostController.text,
            port: int.parse(_portController.text),
            username: _usernameController.text,
            password: _passwordController.text,
          ),
        );
        Navigator.of(context).pop();
      } else {
        Proxy newProxy = Proxy(
          id: Uuid().v4(),
          scheme: "socks",
          host: _hostController.text,
          port: int.parse(_portController.text),
          username: _usernameController.text,
          password: _passwordController.text,
          groupId: "0",
        );
        context.read<ProxiesProvider>().addProxy(newProxy);
        Navigator.of(context).pop(newProxy);
      }
    }
  }
}
