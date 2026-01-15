import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bright_kids/features/content/data/mock_content_repository.dart';
import 'package:bright_kids/features/content/domain/content_node.dart';
import 'package:bright_kids/features/content/presentation/widgets/video_player_widget.dart';
import 'package:bright_kids/features/content/presentation/widgets/webview_player_widget.dart';
import 'package:bright_kids/features/player/widgets/quiz_player_widget.dart';
import 'package:bright_kids/features/player/widgets/audio_player_widget.dart';
import 'package:confetti/confetti.dart';
import 'package:bright_kids/core/reward_service.dart';
import 'package:bright_kids/features/games/data/level_service.dart';
import 'package:bright_kids/features/games/presentation/pages/shape_matcher_game.dart';
import 'package:bright_kids/features/games/presentation/pages/color_sorter_game.dart';
import 'package:bright_kids/features/games/presentation/pages/memory_flip_game.dart';
import 'package:bright_kids/features/games/presentation/pages/animal_sounds_game.dart';

class ContentPlayerScreen extends ConsumerWidget {
  final String contentId;

  const ContentPlayerScreen({
    super.key,
    required this.contentId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, use a FutureProvider family or similar to fetch by ID
    // For now, we hack it by fetching all and finding the one.
    final repository = ref.watch(contentRepositoryProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder<List<ContentNode>>(
              future: repository.getAllContent(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
                }

                final items = snapshot.data ?? [];
                
                ContentNode? item;
                try {
                  item = items.firstWhere((element) => element.id == contentId);
                } catch (e) {
                  // Fallback or not found
                }

                if (item == null) {
                   return const Center(child: Text("Content not found", style: TextStyle(color: Colors.white)));
                }

                return _buildPlayer(item, ref);
              },
            ),
            // Close button overlay
            Positioned(
              top: 16,
              left: 16,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            // Confetti Overlay
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: ref.watch(confettiControllerProvider),
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayer(ContentNode item, WidgetRef ref) {
    if (item.resourceUrl.startsWith('native://')) {
      return _buildNativeGame(item, ref);
    }

    switch (item.type) {
      case ContentType.video:
        return VideoPlayerWidget(videoUrl: item.resourceUrl);
      case ContentType.game:
      case ContentType.book:
        return WebviewPlayerWidget(url: item.resourceUrl);
      case ContentType.quiz:
        return QuizPlayerWidget(content: item);
      case ContentType.music:
        return AudioPlayerWidget(content: item);
      default:
        return Center(
            child: Text("Unsupported content type: ${item.type}", style: TextStyle(color: Colors.white)));
    }
  }

  Widget _buildNativeGame(ContentNode item, WidgetRef ref) {
    final gameId = item.resourceUrl.replaceAll('native://', '');
    final games = ref.read(levelServiceProvider);
    
    try {
      final gameData = games.firstWhere((g) => g.id == gameId);
      
      switch (gameId) {
        case 'shape_matcher':
          return ShapeMatcherGame(gameData: gameData);
        case 'color_sorter':
          return ColorSorterGame(gameData: gameData);
        case 'memory_flip':
          return MemoryFlipGame(gameData: gameData);
        case 'animal_sounds':
          return AnimalSoundsGame(gameData: gameData);
        default:
          return Center(child: Text("Game not implemented: $gameId", style: const TextStyle(color: Colors.white)));
      }
    } catch (e) {
      return Center(child: Text("Game Configuration Not Found: $gameId", style: const TextStyle(color: Colors.white)));
    }
  }
}
