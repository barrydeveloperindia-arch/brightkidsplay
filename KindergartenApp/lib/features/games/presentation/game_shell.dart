import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import '../domain/game_data.dart';
import '../data/level_service.dart';
import 'package:bright_kids/core/reward_service.dart';
import 'package:bright_kids/features/content/presentation/widgets/video_player_widget.dart';

class GameShell extends ConsumerStatefulWidget {
  final GameData gameData;
  final Widget child;
  final int totalPotentialScore;
  final Widget? background;
  
  const GameShell({
    super.key,
    required this.gameData,
    required this.child,
    required this.currentScore,
    required this.totalPotentialScore,
    this.background,
  });

  @override
  ConsumerState<GameShell> createState() => _GameShellState();
}

class _GameShellState extends ConsumerState<GameShell> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GameShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentScore >= widget.totalPotentialScore && 
        widget.currentScore > oldWidget.currentScore) {
      // Defer dialog to next frame to avoid build collisions
      WidgetsBinding.instance.addPostFrameCallback((_) {
         _handleCompletion();
      });
    }
  }

  void _handleCompletion() {
    _confettiController.play();
    ref.read(rewardServiceProvider).triggerSuccess(); // Play sound
    
    // Save progress
    ref.read(levelServiceProvider.notifier).completeLevel(
      widget.gameData.id, 
      widget.currentScore
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Level Complete!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, size: 80, color: Colors.amber),
            const SizedBox(height: 16),
            const Text("You did it!", style: TextStyle(fontSize: 24)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
               context.pop(); // Dialog
               context.go('/game-map'); // Safer exit to map
            },
            child: const Text("Back to Menu"),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop(); // Dialog
              // Ideally navigate to next level, simpler for now to pop
               context.go('/game-map');
            },
            child: const Text("Next Level"),
          ),
        ],
      ),
    );
  }

  void _showTutorial() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: double.infinity,
              height: 400, // Fixed height for video
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: VideoPlayerWidget(videoUrl: widget.gameData.tutorialVideoUrl!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          // Background
          widget.background ?? Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, size: 32, color: Colors.indigo),
                        onPressed: () {
                           if (context.canPop()) {
                             context.pop();
                           } else {
                             context.go('/game-map');
                           }
                        },
                      ),

                      // Tutorial Button
                      if (widget.gameData.tutorialVideoUrl != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: GestureDetector(
                            onTap: _showTutorial,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                              ),
                              child: const Icon(Icons.help_outline, color: Colors.indigo, size: 28),
                            ),
                          ),
                        ),
                      
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            const SizedBox(width: 8),
                            Text(
                              "${widget.currentScore} / ${widget.totalPotentialScore}",
                              style: const TextStyle(
                                fontSize: 20, 
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Game Content
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          ),
          
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false, 
            ),
          ),
        ],
      ),
    );
  }
}
