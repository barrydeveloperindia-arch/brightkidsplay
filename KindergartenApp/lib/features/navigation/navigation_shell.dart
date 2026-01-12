import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationShell extends StatelessWidget {
  final Widget child;
  const NavigationShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // In Kid Mode, we might want a persistent bottom bar or "Back to Home" button overlay.
    // For now, it's a simple wrapper.
    return Scaffold(
      body: Stack(
        children: [
          child,
          // Example: Persistent 'Home' button for kids
          Positioned(
            top: 40,
            left: 20,
            child: FloatingActionButton(
              heroTag: 'home_btn',
              mini: true,
              child: const Icon(Icons.home_rounded),
              onPressed: () => context.go('/kid'),
            ),
          ),
          // Example: Parent Gate Button
          Positioned(
            top: 40,
            right: 20,
            child: FloatingActionButton(
              heroTag: 'parent_btn',
              mini: true,
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.lock_outline, color: Colors.grey),
              onPressed: () => context.push('/parent'),
            ),
          ),
          // Library Button
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton.extended(
              heroTag: 'library_btn',
              icon: const Icon(Icons.menu_book_rounded),
              label: const Text("Library"),
              backgroundColor: Colors.purpleAccent,
              onPressed: () => context.go('/library'),
            ),
          ),
        ],
      ),
    );
  }
}
