import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'package:bright_kids/core/reward_service.dart';
import 'package:bright_kids/features/dashboard/widgets/parent_gate.dart';

class NavigationShell extends StatelessWidget {
  final Widget child;
  const NavigationShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Helper to determine index based on current location
    final String location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith('/library')) {
      currentIndex = 1;
    }

    return Scaffold(
      body: Stack(
        children: [
          child,
          Align(
            alignment: Alignment.topCenter,
            child: Consumer(
              builder: (context, ref, _) {
                 return ConfettiWidget(
                  confettiController: ref.watch(confettiControllerProvider),
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
                );
              }
            ),
          ),
        ],
      ),
      // Persistent Bottom Bar for immersive Kid navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {
            context.go('/kid');
          } else if (index == 1) {
            context.go('/library');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label: 'World',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_library_rounded),
            label: 'Library',
          ),
        ],
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
      // Parent Gate Button (Floating to handle "Exit" logic)
      floatingActionButton: FloatingActionButton(
        heroTag: 'parent_btn',
        mini: true,
        backgroundColor: Colors.white,
        child: const Icon(Icons.lock_outline, color: Colors.grey),
        onPressed: () {
          // Verify with Parent Gate before entering dashboard
          showParentGate(context, () {
             context.push('/parent');
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
