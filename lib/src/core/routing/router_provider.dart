import 'package:flutter_riverpod_app/src/shared/widgets/main_navigation_shell.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/location/presentation/ride_booking_page.dart';
import '../../features/todos/presentation/todo_screen.dart';
part 'router_provider.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.accessToken != null;
      // List all public routes
      final publicRoutes = ['/login', '/register', '/reset-password'];
      final isPublic = publicRoutes.contains(state.matchedLocation);

      if (!isLoggedIn && !isPublic) return '/login';
      if (isLoggedIn && isPublic) return '/';
      return null;
    },
    routes: [
      // 1. PUBLIC ROUTE (No Sidebar)
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const LoginScreen(),
      ),

      // 2. AUTHORIZED ROUTES (With Sidebar)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const TodoScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/rider-booking',
                builder: (context, state) => const RideBookingPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
