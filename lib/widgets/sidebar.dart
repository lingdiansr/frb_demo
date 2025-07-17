import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../models/menu_option.dart';

class Sidebar extends StatelessWidget {
  final List<MenuOption> topOptions;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onSettingsTap;
  final bool isCollapsed;
  final ValueChanged<bool> onToggle;

  const Sidebar({
    required this.topOptions,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onSettingsTap,
    required this.isCollapsed,
    required this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCollapsed ? 80 : 200,
      height: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
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
      child: isCollapsed
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
        children: topOptions.map((option) {
          final index = topOptions.indexOf(option);
          return _buildMenuItem(option, index);
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem(MenuOption option, int index) {
    final label = option.label.tr();
    return isCollapsed
        ? Center(
            child: IconButton(
              icon: Icon(option.icon),
              onPressed: () => onItemSelected(index),
            ),
          )
        : ListTile(
            leading: Icon(option.icon),
            title: Text(label),
            selected: selectedIndex == index,
            onTap: () => onItemSelected(index),
          );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Divider(),
        isCollapsed
            ? Center(
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: onSettingsTap,
                ),
              )
            : ListTile(
                leading: const Icon(Icons.settings),
                title: Text('settings'.tr()),
                onTap: onSettingsTap,
              ),
        isCollapsed
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
    // setState(() => isCollapsed = !isCollapsed);
    onToggle(!isCollapsed);
  }
}
