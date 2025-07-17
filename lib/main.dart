import 'package:flutter/material.dart';
import 'package:frb_demo/src/rust/api/simple.dart';
import 'package:frb_demo/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "hoi radio maker",
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
    MenuOption(Icons.home, 'Home'),
    MenuOption(Icons.favorite, 'Favorites'),
    MenuOption(Icons.history, 'History'),
    MenuOption(Icons.bookmark, 'Bookmarks'),
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
          : const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Menu',
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
            title: Text(option.label),
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
                  onPressed: () {
                    // Handle settings tap
                  },
                ),
              )
            : ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Handle settings tap
                },
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
                title: const Text('Collapse'),
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
