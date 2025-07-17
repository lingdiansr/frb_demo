import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsPageWrapper extends StatelessWidget {
  final BuildContext parentContext;
  const SettingsPageWrapper({Key? key, required this.parentContext})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsPage(parentContext: parentContext);
  }
}

class SettingsPage extends StatelessWidget {
  final BuildContext parentContext;
  const SettingsPage({Key? key, required this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final current = parentContext.locale;

    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('language'.tr(), style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButton<Locale>(
              value: current,
              items: parentContext.supportedLocales.map((locale) {
                final flag = locale.languageCode == 'zh' ? '🇨🇳' : '🇺🇸';
                return DropdownMenuItem<Locale>(
                  value: locale,
                  child: Text('$flag ${locale.languageCode}'),
                );
              }).toList(),
              onChanged: (newLocale) {
                if (newLocale != null) {
                  parentContext.setLocale(newLocale);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
