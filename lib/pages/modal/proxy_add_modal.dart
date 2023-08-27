//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/8/20
//
import 'package:canis/constant/proxy_type.dart';
import 'package:canis/extensions/extensions.dart';
import 'package:canis/pages/proxies/proxy_edit_form.dart';
import 'package:canis/pages/proxies/proxy_group_edit_form.dart';
import 'package:canis/widgets/tapper.dart';
import 'package:flutter/material.dart';

class ProxyAddModal extends StatefulWidget {
  const ProxyAddModal({super.key});

  @override
  State<ProxyAddModal> createState() => _ProxyAddModalState();
}

class _ProxyAddModalState extends State<ProxyAddModal> {
  ProxyType? _proxyType = ProxyType.local;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            for (final type in ProxyType.values)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Tapper(
                      child: Row(
                        children: [
                          Icon(
                            _proxyType == type ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                            color: context.colorScheme.primary,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(type.title),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _proxyType = type;
                        });
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 320),
          child: _proxyType == ProxyType.local ? ProxyEditForm() : ProxyGroupEditForm(),
        ),
      ],
    );
  }
}
