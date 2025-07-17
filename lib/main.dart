import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_yaml/easy_localization_yaml.dart';
import 'package:flutter/material.dart';
import 'package:frb_demo/src/rust/api/simple.dart';
import 'package:frb_demo/src/rust/frb_generated.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await RustLib.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('zh', 'CN')],
      path: 'assets/translations',
      assetLoader: YamlAssetLoader(directory: 'assets/translations'),
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isCollapsed = false;
  int _selectedIndex = 0;

  final List<MenuOption> _topOptions = [
    MenuOption(Icons.home, 'home'),
    MenuOption(Icons.favorite, 'favorites'),
    MenuOption(Icons.history, 'history'),
    MenuOption(Icons.bookmark, 'bookmarks'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(),
          const VerticalDivider(width: 1),
          Expanded(
            child: Center(
              child: Text('Selected: ${_topOptions[_selectedIndex].label}'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isCollapsed ? 80 : 200,
      height: double.infinity,
      color: Colors.blueGrey[50],
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildMenuItems()),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 60,
      child: _isCollapsed
          ? const Center(child: Icon(Icons.menu, size: 30))
          : Padding(
              padding: EdgeInsets.only(left: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'menu'.tr(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
    );
  }

  Widget _buildMenuItems() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ..._topOptions.map(
            (option) => _buildMenuItem(option, _topOptions.indexOf(option)),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(MenuOption option, int index) {
    final label = option.label.tr();
    return _isCollapsed
        ? Center(
            child: IconButton(
              icon: Icon(option.icon),
              onPressed: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          )
        : ListTile(
            leading: Icon(option.icon),
            title: Text(label),
            selected: _selectedIndex == index,
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
          );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Divider(),
        _isCollapsed
            ? Center(
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => _openSettings(context),
                ),
              )
            : ListTile(
                leading: const Icon(Icons.settings),
                title: Text('settings'.tr()),
                onTap: () => _openSettings(context),
              ),
        _isCollapsed
            ? Center(
                child: IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                ),
              )
            : ListTile(
                leading: const Icon(Icons.chevron_left),
                title: Text('collapse'.tr()),
                onTap: () {
                  setState(() {
                    _isCollapsed = !_isCollapsed;
                  });
                },
              ),
      ],
    );
  }
}

class MenuOption {
  final IconData icon;
  final String label;

  MenuOption(this.icon, this.label);
}

void _openSettings(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => SettingsPageWrapper(parentContext: context),
    ),
  );
}

// 新增一个中间小部件，把正确的 context 传给 SettingsPage
class SettingsPageWrapper extends StatelessWidget {
  final BuildContext parentContext;
  const SettingsPageWrapper({Key? key, required this.parentContext})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 用 parentContext 拿到正确的 EasyLocalization context
    return SettingsPage(parentContext: parentContext);
  }
}

class SettingsPage extends StatelessWidget {
  final BuildContext parentContext; // 用来 setLocale
  const SettingsPage({Key? key, required this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final current = parentContext.locale; // 用 parentContext

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
                  parentContext.setLocale(newLocale); // 用 parentContext
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
