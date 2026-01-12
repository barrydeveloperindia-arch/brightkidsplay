import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../../core/reward_service.dart';
import 'animated_character.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewardService = ref.watch(rewardServiceProvider);
    final confettiController = ref.watch(confettiControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Light Cyan
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Guide
                const AnimatedCharacter(),
                
                const SizedBox(height: 20),
                const Text(
                  "Welcome to BrightKids!",
                  style: TextStyle(
                    fontSize: 32, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.blueGrey,
                    fontFamily: 'ComicNeue'
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Reward Test Button
                ElevatedButton.icon(
                  onPressed: () => rewardService.triggerSuccess(), 
                  icon: const Icon(Icons.star),
                  label: const Text("Complete Task!"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ],
            ),
          ),
          
          // Confetti Overlay
          ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
          ),
        ],
      ),
    );
  }
}
