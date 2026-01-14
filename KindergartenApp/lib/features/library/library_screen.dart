import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bright_kids/features/content/data/mock_content_repository.dart';
import 'package:bright_kids/features/content/domain/content_node.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var repository = ref.watch(contentRepositoryProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("The Magic Library", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, // Transparent for gradient visibility
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E1A47), // Deep Space
              Color(0xFF6A0572), // Nebula Purple
              Color(0xFFC77DFF), // Starlight Lavender
            ],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<List<ContentNode>>(
            future: repository.getAllContent(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
              }

              final items = snapshot.data ?? [];
              
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  
                  // Staggered Animation Entry
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: _buildGlassCard(context, item),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard(BuildContext context, ContentNode item) {
    IconData icon;
    Color iconColor;
    switch (item.type) {
      case ContentType.video:
        icon = Icons.play_circle_fill;
        iconColor = Colors.redAccent;
        break;
      case ContentType.book:
        icon = Icons.menu_book;
        iconColor = Colors.blueAccent;
        break;
      case ContentType.game:
        icon = Icons.videogame_asset;
        iconColor = Colors.greenAccent;
        break;
      case ContentType.quiz:
        icon = Icons.psychology;
        iconColor = Colors.orangeAccent;
        break;
      case ContentType.music: // Added for completeness, though not in original ContentType
        icon = Icons.music_note;
        iconColor = Colors.purpleAccent;
        break;
    }

    return GestureDetector(
      onTap: () => context.push('/player/${item.id}'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white.withOpacity(0.15), // Glass effect
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              Image.asset(
                item.thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.white10,
                      child: Icon(icon, size: 60, color: Colors.white30),
                    );
                },
              ),
              // Gradient Overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),
              // Content Info
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: iconColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          item.type.name.toUpperCase(),
                          style: TextStyle(
                            color: iconColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


