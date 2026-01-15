import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/game_data.dart';
import '../../data/level_service.dart';
import '../../../content/presentation/content_player_screen.dart';

class GamesMapScreen extends ConsumerWidget {
  const GamesMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(levelServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF64B5F6), // Sky Blue
      appBar: AppBar(
        title: const Text("Adventure Map", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Path Line (Simplified)
          Center(
            child: Container(
              width: 10,
              height: double.infinity,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 40),
            reverse: true, // Start from bottom (Level 1)
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return _LevelNode(
                game: game, 
                isEven: index.isEven,
                onTap: () {
                  if (game.isUnlocked) {
                     // Route to Game
                     // Using the existing ContentPlayer routing logic for convenience, 
                     // or direct navigation if we refactor. 
                     // For now, let's treat them as accessible via their ID.
                     context.push('/player/${game.id}');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Complete previous levels to unlock!"), duration: Duration(seconds: 1)),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LevelNode extends StatelessWidget {
  final GameData game;
  final bool isEven;
  final VoidCallback onTap;

  const _LevelNode({required this.game, required this.isEven, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 40),
      child: Row(
        mainAxisAlignment: isEven ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Column(
              children: [
                // Node
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: game.isUnlocked ? _getDifficultyColor(game.difficulty) : Colors.grey,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
                    ],
                  ),
                  child: Center(
                    child: game.isUnlocked 
                      ? Text(
                          "${game.levelIndex}", 
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)
                        )
                      : const Icon(Icons.lock, color: Colors.white54, size: 32),
                  ),
                ),
                const SizedBox(height: 8),
                // Stars
                if (game.isUnlocked)
                   Row(
                     children: List.generate(3, (i) => Icon(
                       Icons.star, 
                       size: 20, 
                       color: i < game.starsEarned ? Colors.amber : Colors.black12,
                     )),
                   ),
                
                // Title Label
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(8)),
                  child: Text(
                     game.title, 
                     style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(GameDifficulty d) {
    switch (d) {
      case GameDifficulty.easy: return Colors.green;
      case GameDifficulty.medium: return Colors.orange;
      case GameDifficulty.hard: return Colors.red;
    }
  }
}
