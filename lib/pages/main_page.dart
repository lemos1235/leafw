//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/8/19
//
import 'package:canis/pages/modal/proxy_add_modal.dart';
import 'package:canis/pages/proxies/proxies_page.dart';
import 'package:canis/providers/proxies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    initProxies();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      closeSplash();
    });
  }

  Future<void> initProxies() async {
    await context.read<ProxiesProvider>().initialize();
  }

  Future<void> closeSplash() async {
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Stack(
            children: [
              NavigationRail(
                leading: Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  child: SvgPicture.asset(
                    "assets/svgs/logo.svg",
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
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/svgs/tweak.svg",
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ],
                ),
              )
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          const Expanded(child: ProxiesPage()),
        ],
      ),
    );
  }

  void handleDestinationChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 1) {
      //新增节点弹窗
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              children: [
                ProxyAddModal(),
              ],
            );
          });
    }
  }
}
