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
      // NATIVE GAMES
      const ContentNode(
        id: 'shape_matcher',
        title: 'Shape Matcher',
        type: ContentType.game,
        thumbnailUrl: 'assets/images/thumb_game.png',
        resourceUrl: 'native://shape_matcher',
        skillTags: ['Logic', 'DragDrop'],
        minAge: 3,
      ),
      const ContentNode(
        id: 'color_sorter',
        title: 'Color Sorter',
        type: ContentType.game,
        thumbnailUrl: 'assets/images/thumb_game.png',
        resourceUrl: 'native://color_sorter',
        skillTags: ['Logic', 'Colors'],
        minAge: 3,
      ),
      const ContentNode(
        id: 'memory_flip',
        title: 'Memory Flip',
        type: ContentType.game,
        thumbnailUrl: 'assets/images/thumb_game.png',
        resourceUrl: 'native://memory_flip',
        skillTags: ['Memory', 'Logic'],
        minAge: 4,
      ),
      const ContentNode(
        id: 'animal_sounds',
        title: 'Animal Sounds',
        type: ContentType.game,
        thumbnailUrl: 'assets/images/thumb_music.png',
        resourceUrl: 'native://animal_sounds',
        skillTags: ['Audio', 'Animals'],
        minAge: 3,
      ),
      const ContentNode(
        id: 'number_trace',
        title: 'Number Trace',
        type: ContentType.game,
        thumbnailUrl: 'assets/images/thumb_math.png',
        resourceUrl: 'native://number_trace',
        skillTags: ['Math', 'Writing'],
        minAge: 4,
      ),
      // PLANCEHOLDERS FOR PHASE 2 & 3
      // We map these to a generic 'coming_soon' or just let them error for now 
      // but ideally we map them to a GenericGame if config exists. 
      // For now, let's just register them so they don't 404.
      for (var id in [
        'balloon_pop', 'letter_catch', 'pattern_complete', 'big_small', 'shadow_match',
        'math_garden', 'rhyme_time', 'clock_wise', 'emotion_explorer', 'maze_runner'
      ])
        ContentNode(
          id: id,
          title: id.replaceAll('_', ' ').toUpperCase(),
          type: ContentType.game,
          thumbnailUrl: 'assets/images/thumb_game.png',
          resourceUrl: 'native://$id',
          skillTags: ['Coming Soon'],
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
