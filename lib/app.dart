import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'models/theme_notifier.dart';
import 'pages/home_page.dart';
import 'models/theme_notifier.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    return MaterialApp(
      title: "title".tr(),
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

  ThemeData _lightTheme() => ThemeData(
    colorSchemeSeed: Colors.blue,
    brightness: Brightness.light,
    useMaterial3: true,
  );

  ThemeData _darkTheme() => ThemeData(
    colorSchemeSeed: Colors.blue,
    brightness: Brightness.dark,
    useMaterial3: true,
  );
}
