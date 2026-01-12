import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bright_kids/features/content/data/mock_content_repository.dart';
import 'package:bright_kids/features/content/domain/content_node.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(contentRepositoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // Light Orange
      appBar: AppBar(
        title: const Text("Library", style: TextStyle(fontFamily: 'ComicNeue', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: repository.getAllContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final items = snapshot.data ?? [];

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns for big kid-friendly cards
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _ContentCard(item: item);
            },
          );
        },
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  final ContentNode item;
  const _ContentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => context.push('/player/${item.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Placeholder for image
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(_getIconForType(item.type), size: 16, color: Colors.blueGrey),
                      const SizedBox(width: 4),
                      Text(
                        item.type.name.toUpperCase(),
                        style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(ContentType type) {
    switch (type) {
      case ContentType.video: return Icons.play_circle_fill;
      case ContentType.book: return Icons.book;
      case ContentType.game: return Icons.videogame_asset;
      case ContentType.quiz: return Icons.question_answer;
      default: return Icons.article; // Fallback
    }
  }
}
