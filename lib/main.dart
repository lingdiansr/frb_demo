import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_yaml/easy_localization_yaml.dart';
import 'package:flutter/material.dart';
import 'package:frb_demo/models/theme_notifier.dart';
import 'package:frb_demo/src/rust/frb_generated.dart';
import 'package:provider/provider.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await RustLib.init();

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
