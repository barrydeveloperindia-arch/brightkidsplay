import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/content_node.dart';

// Just for prototyping, we'll return a static list
final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository();
});

class ContentRepository {
  Future<List<ContentNode>> getAllContent() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      const ContentNode(
        id: '1', 
        title: 'Counting to 10', 
        type: ContentType.video, 
        thumbnailUrl: 'assets/images/thumb_math.png',
        resourceUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        skillTags: ['Math', 'Numbers'],
        minAge: 3,
      ),
      const ContentNode(
        id: '2', 
        title: 'The Blue Elephant', 
        type: ContentType.book, 
        thumbnailUrl: 'assets/images/thumb_book.png',
        resourceUrl: 'https://en.m.wikipedia.org/wiki/Elephant', // Valid web URL for testing
        skillTags: ['Reading', 'Animals'],
        minAge: 4,
      ),
      const ContentNode(
        id: '3', 
        title: 'Shape Sorter', 
        type: ContentType.game, 
        thumbnailUrl: 'assets/images/thumb_game.png',
        resourceUrl: 'https://example.com/game1.zip',
        skillTags: ['Logic', 'Shapes'],
        minAge: 3,
      ),
    ];
  }
}
