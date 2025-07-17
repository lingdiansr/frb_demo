import 'package:flutter/material.dart';

import '../models/menu_option.dart';
import '../widgets/sidebar.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          Sidebar(
            topOptions: _topOptions,
            selectedIndex: _selectedIndex,
            onItemSelected: (index) => setState(() => _selectedIndex = index),
            onSettingsTap: () => _openSettings(context),
          ),
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

  void _openSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsPageWrapper(parentContext: context),
      ),
    );
  }
}
