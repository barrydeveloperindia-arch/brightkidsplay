import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../../core/reward_service.dart';
import 'animated_character.dart';
import 'world_map_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewardService = ref.watch(rewardServiceProvider);
    final confettiController = ref.watch(confettiControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Light Cyan
      body: Stack(
        children: [
          // 1. The Scrollable World Map
          const WorldMapView(),

          // 2. Fixed Mascot Overlay (Bottom Left)
          const Positioned(
            bottom: 20,
            left: 20,
            child: AnimatedCharacter(),
          ),

          // 3. Confetti Overlay (Foreground)
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            ),
          ),
          
          // 4. Header / Settings Button placeholder
          Positioned(
            top: 40,
            left: 20,
            child: FloatingActionButton.small(
              backgroundColor: Colors.white,
              child: const Icon(Icons.settings, color: Colors.blueGrey),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
