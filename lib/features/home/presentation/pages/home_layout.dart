import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/colors.dart';

class HomeLayout extends StatelessWidget {
  final Widget child;

  const HomeLayout({super.key, required this.child});

  static final List<String> tabs = ['/home', '/sales', '/dashboard', '/brand'];

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
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? AppColors.primary
                : AppColors.accent,
        color:
            Theme.of(context).brightness == Brightness.dark
                ? AppColors.dark
                : AppColors.surface,
        // selectedItemColor: AppColors.accent,
        // unselectedItemColor: Colors.grey,
        // type: BottomNavigationBarType.fixed,
        // showSelectedLabels: true,
        // showUnselectedLabels: false,
        items: [
          Icon(
            Icons.inventory_2_rounded,
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? AppColors.accent
                    : AppColors.primary,
          ),
          Icon(
            Icons.point_of_sale_rounded,
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? AppColors.accent
                    : AppColors.primary,
          ),
          Icon(
            Icons.analytics_rounded,
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? AppColors.accent
                    : AppColors.primary,
          ),
          Icon(
            Icons.shopping_bag_rounded,
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? AppColors.accent
                    : AppColors.primary,
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.inventory_2_rounded),
          //   label: "Inventory",
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.point_of_sale_rounded),
          //   label: "Sales",
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.analytics_rounded),
          //   label: "Dashboard",
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.shopping_bag_rounded),
          //   label: "Brand",
          // ),
        ],
      ),
    );
  }
}
