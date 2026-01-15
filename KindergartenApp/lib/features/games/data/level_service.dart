import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/game_data.dart';

// Simple in-memory storage for this session. 
// TODO: Replace with Hive/SharedPreferences for persistence.

class LevelService extends StateNotifier<List<GameData>> {
  LevelService() : super(_initialGames);

  static final List<GameData> _initialGames = [
    // PHASE 1: FOUNDATIONS
    const GameData(
      id: 'shape_matcher',
      title: 'Shape Matcher',
      description: 'Match the shapes',
      difficulty: GameDifficulty.easy,
      targetScore: 3,
      levelIndex: 1,
      isUnlocked: true,
      tutorialVideoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 
    ),
    const GameData(
      id: 'color_sorter',
      title: 'Color Sorter',
      description: 'Sort by color',
      difficulty: GameDifficulty.easy,
      targetScore: 5,
      levelIndex: 2,
      isUnlocked: false,
    ),
    const GameData(
      id: 'memory_flip',
      title: 'Memory Flip',
      description: 'Find pairs',
      difficulty: GameDifficulty.medium,
      targetScore: 6,
      levelIndex: 3,
      isUnlocked: false,
    ),
    const GameData(
      id: 'animal_sounds',
      title: 'Animal Sounds',
      description: 'Listen and match',
      difficulty: GameDifficulty.easy,
      targetScore: 5,
      levelIndex: 4,
      isUnlocked: false,
    ),
     const GameData(
      id: 'number_trace',
      title: 'Number Trace',
      description: 'Trace 1-5',
      difficulty: GameDifficulty.medium,
      targetScore: 5,
      levelIndex: 5,
      isUnlocked: false,
    ),

    // PHASE 2: EARLY MATH & LANGUAGE
    const GameData(id: 'balloon_pop', title: 'Balloon Pop', description: 'Count 1-10', difficulty: GameDifficulty.easy, targetScore: 10, levelIndex: 6, isUnlocked: false),
    const GameData(id: 'letter_catch', title: 'Letter Catch', description: 'Spell words', difficulty: GameDifficulty.medium, targetScore: 5, levelIndex: 7, isUnlocked: false),
    const GameData(id: 'pattern_complete', title: 'Pattern Logic', description: 'Complete pattern', difficulty: GameDifficulty.medium, targetScore: 5, levelIndex: 8, isUnlocked: false),
    const GameData(id: 'big_small', title: 'Big & Small', description: 'Size comparison', difficulty: GameDifficulty.easy, targetScore: 5, levelIndex: 9, isUnlocked: false),
    const GameData(id: 'shadow_match', title: 'Shadow Match', description: 'Match shadows', difficulty: GameDifficulty.easy, targetScore: 5, levelIndex: 10, isUnlocked: false),

    // PHASE 3: ADVANCED
    const GameData(id: 'math_garden', title: 'Math Garden', description: 'Simple Addition', difficulty: GameDifficulty.hard, targetScore: 5, levelIndex: 11, isUnlocked: false),
    const GameData(id: 'rhyme_time', title: 'Rhyme Time', description: 'Match rhymes', difficulty: GameDifficulty.medium, targetScore: 5, levelIndex: 12, isUnlocked: false),
    const GameData(id: 'clock_wise', title: 'Clock Wise', description: 'Tell time', difficulty: GameDifficulty.hard, targetScore: 3, levelIndex: 13, isUnlocked: false),
    const GameData(id: 'emotion_explorer', title: 'Emotions', description: 'Identify feelings', difficulty: GameDifficulty.medium, targetScore: 4, levelIndex: 14, isUnlocked: false),
    const GameData(id: 'maze_runner', title: 'Maze Runner', description: 'Solve maze', difficulty: GameDifficulty.hard, targetScore: 1, levelIndex: 15, isUnlocked: false),
  ];

  void completeLevel(String gameId, int score) {
    state = [
      for (final game in state)
        if (game.id == gameId)
          game.copyWith(
            starsEarned: _calculateStars(score, game.targetScore),
          )
        else
          game
    ];
    
    // Unlock next level logic (simplified)
    final currentIndex = state.indexWhere((g) => g.id == gameId);
    if (currentIndex != -1 && currentIndex < state.length - 1) {
       _unlockLevel(currentIndex + 1);
    }
  }

  void _unlockLevel(int index) {
      final nextGame = state[index];
      if (!nextGame.isUnlocked) {
          state = [
              for (int i=0; i<state.length; i++)
                if (i == index) state[i].copyWith(isUnlocked: true) else state[i]
          ];
      }
  }

  int _calculateStars(int score, int target) {
    if (score >= target) return 3;
    if (score >= target * 0.7) return 2;
    return 1;
  }
}

final levelServiceProvider = StateNotifierProvider<LevelService, List<GameData>>((ref) {
  return LevelService();
});
