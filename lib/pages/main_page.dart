//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/8/19
//
import 'package:canis/pages/modal/proxy_add_modal.dart';
import 'package:canis/pages/proxies/proxies_page.dart';
import 'package:canis/pages/settings/settings_page.dart';
import 'package:canis/providers/proxies_provider.dart';
import 'package:canis/widgets/tapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int? _selectedIndex = 0;

  Widget _body = ProxiesPage();

  @override
  void initState() {
    super.initState();
    initProxies();
  }

  Future<void> initProxies() async {
    await context.read<ProxiesProvider>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: SvgPicture.asset(
                "assets/svgs/bird.svg",
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                width: 28,
                height: 28,
              ),
            ),
            selectedIndex: _selectedIndex,
            onDestinationSelected: handleDestinationChanged,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.border_all),
                label: Text('应用'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.add),
                label: Text('新增'),
              ),
            ],
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Tapper(
                    child: SvgPicture.asset(
                      "assets/svgs/tweak.svg",
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    onTap: handleSettings,
                  ),
                ),
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _body),
        ],
      ),
    );
  }

  void handleDestinationChanged(int index) {
    if (index == 0) {
      setState(() {
        _selectedIndex = index;
        _body = ProxiesPage();
      });
    }
    if (index == 1) {
      //新增节点弹窗
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              ProxyAddModal(),
            ],
          );
        },
      );
    }
  }

  void handleSettings() {
    setState(() {
      _selectedIndex = null;
      _body = SettingsPage();
    });
  }
}
