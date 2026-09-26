import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShellScreen extends StatelessWidget {
  final Widget child;

  const MainShellScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (int index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.wb_sunny_outlined), selectedIcon: Icon(Icons.wb_sunny), label: 'اليوم'),
          NavigationDestination(icon: Icon(Icons.mosque_outlined), selectedIcon: Icon(Icons.mosque), label: 'الصلاة'),
          NavigationDestination(icon: Icon(Icons.center_focus_strong_outlined), selectedIcon: Icon(Icons.center_focus_strong), label: 'التركيز'),
          NavigationDestination(icon: Icon(Icons.alarm_outlined), selectedIcon: Icon(Icons.alarm), label: 'المنبهات'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'الإعدادات'),
        ],
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/prayer')) {
      return 1;
    }
    if (location.startsWith('/focus')) {
      return 2;
    }
    if (location.startsWith('/alarms')) {
      return 3;
    }
    if (location.startsWith('/settings')) {
      return 4;
    }
    return 0; // Default home
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/prayer');
        break;
      case 2:
        GoRouter.of(context).go('/focus');
        break;
      case 3:
        GoRouter.of(context).go('/alarms');
        break;
      case 4:
        GoRouter.of(context).go('/settings');
        break;
    }
  }
}
