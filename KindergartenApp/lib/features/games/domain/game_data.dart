import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_data.freezed.dart';
part 'game_data.g.dart';

enum GameDifficulty { easy, medium, hard }

@freezed
class GameData with _$GameData {
  const factory GameData({
    required String id,
    required String title,
    required String description,
    required GameDifficulty difficulty,
    required int targetScore,
    required int levelIndex,
    @Default(false) bool isUnlocked,
    @Default(0) int starsEarned,
    String? tutorialVideoUrl,
  }) = _GameData;

  factory GameData.fromJson(Map<String, dynamic> json) => _$GameDataFromJson(json);
}
