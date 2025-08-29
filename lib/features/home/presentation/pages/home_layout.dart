import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/colors.dart';

class HomeLayout extends StatelessWidget {
  final Widget child;
  const HomeLayout({super.key, required this.child});

  static final List<String> tabs = [
    '/home',
    '/sales',
    '/dashboard',
    '/settings',
  ];

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    // match which tab we’re currently on
    for (int i = 0; i < tabs.length; i++) {
      if (location.startsWith(tabs[i])) {
        return i;
      }
    }
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    context.go(tabs[index]);
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _getSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
        selectedItemColor: AppColors.accent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: "Inventory",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale),
            label: "Sales",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
