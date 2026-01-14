import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bright_kids/features/content/data/mock_content_repository.dart';
import 'package:bright_kids/features/content/domain/content_node.dart';
import 'package:bright_kids/features/player/widgets/video_player_widget.dart';
import 'package:bright_kids/features/player/widgets/webview_player_widget.dart';
import 'package:bright_kids/features/player/widgets/quiz_player_widget.dart';
import 'package:bright_kids/features/player/widgets/audio_player_widget.dart';

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
                final item = items.firstWhere(
                  (element) => element.id == contentId,
                  orElse: () => const ContentNode(
                    id: 'error',
                    title: 'Error',
                    type: ContentType.book,
                    thumbnailUrl: '',
                    resourceUrl: '',
                  ),
                );

                if (item.id == 'error') {
                   return const Center(child: Text("Content not found", style: TextStyle(color: Colors.white)));
                }

                return _buildPlayer(item);
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
          ],
        ),
      ),
    );
  }

  Widget _buildPlayer(ContentNode item) {
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
            child: Text("Unsupported content type: ${item.type}", style: const TextStyle(color: Colors.white)));
    }
  }
}
