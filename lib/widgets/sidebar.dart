import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../models/menu_option.dart';

class Sidebar extends StatefulWidget {
  final List<MenuOption> topOptions;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onSettingsTap;

  const Sidebar({
    required this.topOptions,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onSettingsTap,
    super.key,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.only(left: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'menu'.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildMenuItems() {
    return SingleChildScrollView(
      child: Column(
        children: widget.topOptions.map((option) {
          final index = widget.topOptions.indexOf(option);
          return _buildMenuItem(option, index);
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem(MenuOption option, int index) {
    final label = option.label.tr();
    return _isCollapsed
        ? Center(
            child: IconButton(
              icon: Icon(option.icon),
              onPressed: () => widget.onItemSelected(index),
            ),
          )
        : ListTile(
            leading: Icon(option.icon),
            title: Text(label),
            selected: widget.selectedIndex == index,
            onTap: () => widget.onItemSelected(index),
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
                  onPressed: widget.onSettingsTap,
                ),
              )
            : ListTile(
                leading: const Icon(Icons.settings),
                title: Text('settings'.tr()),
                onTap: widget.onSettingsTap,
              ),
        _isCollapsed
            ? Center(
                child: IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _toggleCollapse,
                ),
              )
            : ListTile(
                leading: const Icon(Icons.chevron_left),
                title: Text('collapse'.tr()),
                onTap: _toggleCollapse,
              ),
      ],
    );
  }

  void _toggleCollapse() {
    setState(() => _isCollapsed = !_isCollapsed);
  }
}
