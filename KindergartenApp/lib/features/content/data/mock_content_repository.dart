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
        // Fallback to Wikipedia for reliable testing as many game sites block headers
        resourceUrl: 'https://en.m.wikipedia.org/wiki/Shape', 
        skillTags: ['Logic', 'Shapes'],
        minAge: 3,
      ),
      const ContentNode(
        id: '4',
        title: 'Animal Quiz',
        type: ContentType.quiz,
        thumbnailUrl: 'assets/images/thumb_quiz.png',
        resourceUrl: '', // Not used for internal quiz
        skillTags: ['Animals', 'Memory'],
        minAge: 4,
        metadata: {
          'questions': [
            {
              'question': 'Which animal is big and grey?',
              'options': ['Mouse', 'Elephant', 'Cat', 'Bird'],
              'answer': 'Elephant'
            },
            {
              'question': 'What does a dog say?',
              'options': ['Meow', 'Moo', 'Woof', 'Quack'],
              'answer': 'Woof'
            },
            {
              'question': 'Which one flies?',
              'options': ['Fish', 'Bird', 'Dog', 'Cow'],
              'answer': 'Bird'
            }
          ]
        },
      ),
      const ContentNode(
        id: '5', 
        title: 'Sleepy Deep Space', 
        type: ContentType.music, 
        thumbnailUrl: 'assets/images/thumb_music.png',
        resourceUrl: 'https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3?filename=lofi-study-112762.mp3', // Sample Lofi
        skillTags: ['Relaxation', 'Music'],
        minAge: 0,
      ),
      const ContentNode(
        id: '6', 
        title: 'Happy Frog Dance', 
        type: ContentType.music, 
        thumbnailUrl: 'assets/images/thumb_frog.png',
        resourceUrl: 'https://cdn.pixabay.com/download/audio/2022/10/25/audio_5103c8b417.mp3?filename=fun-life-115865.mp3',
        skillTags: ['Dance', 'Energy'],
        minAge: 2,
      ),
    ];
  }
}
