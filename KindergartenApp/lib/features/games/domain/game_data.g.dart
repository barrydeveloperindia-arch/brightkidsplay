// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameDataImpl _$$GameDataImplFromJson(Map<String, dynamic> json) =>
    _$GameDataImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      difficulty: $enumDecode(_$GameDifficultyEnumMap, json['difficulty']),
      targetScore: (json['targetScore'] as num).toInt(),
      levelIndex: (json['levelIndex'] as num).toInt(),
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      starsEarned: (json['starsEarned'] as num?)?.toInt() ?? 0,
      tutorialVideoUrl: json['tutorialVideoUrl'] as String?,
    );

Map<String, dynamic> _$$GameDataImplToJson(_$GameDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'difficulty': _$GameDifficultyEnumMap[instance.difficulty]!,
      'targetScore': instance.targetScore,
      'levelIndex': instance.levelIndex,
      'isUnlocked': instance.isUnlocked,
      'isUnlocked': instance.isUnlocked,
      'starsEarned': instance.starsEarned,
      'tutorialVideoUrl': instance.tutorialVideoUrl,
    };

const _$GameDifficultyEnumMap = {
  GameDifficulty.easy: 'easy',
  GameDifficulty.medium: 'medium',
  GameDifficulty.hard: 'hard',
};
