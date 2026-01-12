import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/navigation/navigation_shell.dart';
import '../features/home/home_screen.dart';
import '../features/dashboard/parent_dashboard_screen.dart';
import '../features/library/library_screen.dart';
import '../features/content/presentation/content_player_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/kid',
    routes: [
      // Shell Route for Kid Mode (Immersive Navigation)
      ShellRoute(
        builder: (context, state, child) => NavigationShell(child: child),
        routes: [
          GoRoute(
            path: '/kid',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/library',
            builder: (context, state) => const LibraryScreen(),
          ),
        ],
      ),

      // Immersive Player Route (No Shell/Bottom Bar)
      GoRoute(
        path: '/player/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ContentPlayerScreen(contentId: id);
        },
      ),
      
      // Parent Mode (Protected)
      GoRoute(
        path: '/parent',
        builder: (context, state) => const ParentDashboardScreen(),
      ),
    ],
  );
});
