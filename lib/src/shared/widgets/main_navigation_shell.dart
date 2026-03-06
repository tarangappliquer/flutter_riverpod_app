import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/presentation/widgets/profile_header.dart';

class MainNavigationShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(navigationShell.currentIndex)),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => AppTheme.showThemeSelector(context, ref),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const ProfileHeader(),
            const Divider(),
            _drawerTile(context, 0, 'Tasks', Icons.list),
            _drawerTile(context, 1, 'Ride Booking', Icons.map),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () => ref.read(authControllerProvider.notifier).logout(),
            ),
          ],
        ),
      ),
      body: navigationShell,
    );
  }

  String _getTitle(int index) => index == 0 ? 'My Tasks' : 'Book a Ride';

  Widget _drawerTile(
    BuildContext context,
    int index,
    String title,
    IconData icon,
  ) {
    return ListTile(
      selected: navigationShell.currentIndex == index,
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        navigationShell.goBranch(index);
        context.pop(); // Close drawer
      },
    );
  }
}
