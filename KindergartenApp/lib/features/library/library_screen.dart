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
      elevation: 8, // Higher elevation for "pop"
      shadowColor: _getColorForType(item.type).withOpacity(0.4), // Colored shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: _getColorForType(item.type).withOpacity(0.5), width: 2), // Colored border
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/player/${item.id}'),
        splashColor: _getColorForType(item.type).withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    item.thumbnailUrl, // Use item's thumb first
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) {
                      // Fallback to type-based generic image if specific thumb fails
                      return Container(
                        color: _getColorForType(item.type).withOpacity(0.1),
                        child: Icon(
                          _getIconForType(item.type),
                          size: 64,
                          color: _getColorForType(item.type).withOpacity(0.5),
                        ),
                      );
                    },
                  ),
                  // Type Badge Overlay
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_getIconForType(item.type), size: 14, color: _getColorForType(item.type)),
                          const SizedBox(width: 4),
                          Text(
                            item.type.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getColorForType(item.type),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18, // Larger title
                        fontFamily: 'ComicNeue',
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Skill Tags Row
                    if (item.skillTags.isNotEmpty)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: item.skillTags.take(2).map((tag) => Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                            ),
                          )).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForType(ContentType type) {
    switch (type) {
      case ContentType.video: return const Color(0xFFFF6B6B); // Red-ish
      case ContentType.book: return const Color(0xFF4ECDC4); // Teal-ish
      case ContentType.game: return const Color(0xFFFFD93D); // Yellow-ish
      case ContentType.quiz: return const Color(0xFF6C5CE7); // Purple-ish
    }
  }

  IconData _getIconForType(ContentType type) {
    switch (type) {
      case ContentType.video: return Icons.play_circle_filled_rounded;
      case ContentType.book: return Icons.menu_book_rounded;
      case ContentType.game: return Icons.gamepad_rounded;
      case ContentType.quiz: return Icons.help_outline_rounded;
    }
  }
}
