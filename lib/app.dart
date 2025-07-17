import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'models/theme_notifier.dart';
import 'pages/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;
    _updateWindowTitle(context);
    final themeNotifier = context.watch<ThemeNotifier>();
    return MaterialApp(
      title: 'title'.tr(),
      localizationsDelegates: [
        ...context.localizationDelegates,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // themeMode: ThemeMode.system,
      themeMode: themeNotifier.mode,
      theme: _lightTheme(), // 浅色主题
      darkTheme: _darkTheme(), // 深色主题
      // theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }

  void _updateWindowTitle(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      windowManager.setTitle('mainWindowTitle'.tr());
    });
  }

  ThemeData _lightTheme() => ThemeData(
    colorSchemeSeed: const Color.fromARGB(255, 0, 7, 133),
    brightness: Brightness.light,
    useMaterial3: true,
  );

  ThemeData _darkTheme() => ThemeData(
    colorSchemeSeed: const Color.fromARGB(255, 177, 220, 255),
    brightness: Brightness.dark,
    useMaterial3: true,
  );
}
