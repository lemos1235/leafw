import 'package:canis/hive/hive_boxes.dart';
import 'package:canis/model/app_settings.dart';
import 'package:canis/pages/main_page.dart';
import 'package:canis/providers/providers.dart';
import 'package:canis/providers/settings_provider.dart';
import 'package:canis/utils/net_util.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.level = Level.info;
  await Hive.initFlutter("Canis");
  await HiveBoxes.openBoxes();
  await NetUtil.init();
  runApp(MultiProvider(
    providers: providers,
    child: const CanisApp(),
  ));
}

class CanisApp extends StatefulWidget {
  const CanisApp({super.key});

  @override
  State<CanisApp> createState() => _CanisAppState();
}

class _CanisAppState extends State<CanisApp> {
  late AppSettings appSettings;

  @override
  void initState() {
    super.initState();
    // 初始化应用设置
    context.read<SettingsProvider>().initAppSettings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appSettings = context.watch<SettingsProvider>().getAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '小象IP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'NotoSansSC',
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF81C784)),
          useMaterial3: true,
          navigationRailTheme: const NavigationRailThemeData(
            backgroundColor: Color(0xFF252626),
            labelType: NavigationRailLabelType.none,
            indicatorColor: Colors.transparent,
            indicatorShape: CircleBorder(),
            selectedIconTheme: IconThemeData(
              color: Colors.white,
              fill: 0,
            ),
            unselectedIconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Color(0xFF222222),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          dividerTheme: const DividerThemeData(
            color: Color(0xFFEEEEEE),
          ),
          dialogTheme: DialogTheme(
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
          ),
          popupMenuTheme: PopupMenuThemeData(
            color: Colors.white,
          ),
          segmentedButtonTheme: SegmentedButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          )),
      darkTheme: ThemeData(
        fontFamily: 'NotoSansSC',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: const Color(0xFF81C784)),
        useMaterial3: true,
        bottomSheetTheme: const BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF212121),
        ),
        // scaffoldBackgroundColor: Color(0xFF1A1A1A),
        cardTheme: const CardTheme(
          color: Color(0xFF242424),
        ),
        dialogTheme: DialogTheme(
          shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2D2D2D),
        ),
      ),
      themeMode: appSettings.appearance.themeMode,
      home: const MainPage(),
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: child,
        );
      },
    );
  }
}
