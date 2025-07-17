import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_yaml/easy_localization_yaml.dart';
import 'package:flutter/material.dart';
import 'package:frb_demo/models/theme_notifier.dart';
import 'package:frb_demo/src/rust/frb_generated.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await windowManager.ensureInitialized();
  await RustLib.init();
  WindowOptions windowOptions = WindowOptions(
    size: Size(800, 600),
    center: true,
    // backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setTitle('mainWindowTitle'.tr());
  });
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('zh', 'CN')],
        path: 'assets/translations',
        assetLoader: YamlAssetLoader(directory: 'assets/translations'),
        fallbackLocale: const Locale('en', 'US'),
        child: const MyApp(),
      ),
    ),
  );
}
