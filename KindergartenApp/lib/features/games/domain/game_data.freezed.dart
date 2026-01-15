// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GameData _$GameDataFromJson(Map<String, dynamic> json) {
  return _GameData.fromJson(json);
}

/// @nodoc
mixin _$GameData {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  GameDifficulty get difficulty => throw _privateConstructorUsedError;
  int get targetScore => throw _privateConstructorUsedError;
  int get levelIndex => throw _privateConstructorUsedError;
  bool get isUnlocked => throw _privateConstructorUsedError;
  int get starsEarned => throw _privateConstructorUsedError;
  String? get tutorialVideoUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GameDataCopyWith<GameData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameDataCopyWith<$Res> {
  factory $GameDataCopyWith(GameData value, $Res Function(GameData) then) =
      _$GameDataCopyWithImpl<$Res, GameData>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      GameDifficulty difficulty,
      int targetScore,
      int levelIndex,
      bool isUnlocked,
      String? tutorialVideoUrl});
}

/// @nodoc
class _$GameDataCopyWithImpl<$Res, $Val extends GameData>
    implements $GameDataCopyWith<$Res> {
  _$GameDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? difficulty = null,
    Object? targetScore = null,
    Object? levelIndex = null,
    Object? isUnlocked = null,
    Object? isUnlocked = null,
    Object? starsEarned = null,
    Object? tutorialVideoUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as GameDifficulty,
      targetScore: null == targetScore
          ? _value.targetScore
          : targetScore // ignore: cast_nullable_to_non_nullable
              as int,
      levelIndex: null == levelIndex
          ? _value.levelIndex
          : levelIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      starsEarned: null == starsEarned
          ? _value.starsEarned
          : starsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      tutorialVideoUrl: freezed == tutorialVideoUrl
          ? _value.tutorialVideoUrl
          : tutorialVideoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameDataImplCopyWith<$Res>
    implements $GameDataCopyWith<$Res> {
  factory _$$GameDataImplCopyWith(
          _$GameDataImpl value, $Res Function(_$GameDataImpl) then) =
      __$$GameDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      GameDifficulty difficulty,
      int targetScore,
      int levelIndex,
      bool isUnlocked,
      bool isUnlocked,
      int starsEarned,
      String? tutorialVideoUrl});
}

/// @nodoc
class __$$GameDataImplCopyWithImpl<$Res>
    extends _$GameDataCopyWithImpl<$Res, _$GameDataImpl>
    implements _$$GameDataImplCopyWith<$Res> {
  __$$GameDataImplCopyWithImpl(
      _$GameDataImpl _value, $Res Function(_$GameDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? difficulty = null,
    Object? targetScore = null,
    Object? levelIndex = null,
    Object? isUnlocked = null,
    Object? isUnlocked = null,
    Object? starsEarned = null,
    Object? tutorialVideoUrl = freezed,
  }) {
    return _then(_$GameDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as GameDifficulty,
      targetScore: null == targetScore
          ? _value.targetScore
          : targetScore // ignore: cast_nullable_to_non_nullable
              as int,
      levelIndex: null == levelIndex
          ? _value.levelIndex
          : levelIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      starsEarned: null == starsEarned
          ? _value.starsEarned
          : starsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      tutorialVideoUrl: freezed == tutorialVideoUrl
          ? _value.tutorialVideoUrl
          : tutorialVideoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameDataImpl implements _GameData {
  const _$GameDataImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.difficulty,
      required this.targetScore,
      required this.levelIndex,
      this.isUnlocked = false,
      this.starsEarned = 0,
      this.tutorialVideoUrl});

  factory _$GameDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameDataImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final GameDifficulty difficulty;
  @override
  final int targetScore;
  @override
  final int levelIndex;
  @override
  @JsonKey()
  final bool isUnlocked;
  @override
  @JsonKey()
  final int starsEarned;
  @override
  final String? tutorialVideoUrl;

  @override
  String toString() {
    return 'GameData(id: $id, title: $title, description: $description, difficulty: $difficulty, targetScore: $targetScore, levelIndex: $levelIndex, isUnlocked: $isUnlocked, starsEarned: $starsEarned, tutorialVideoUrl: $tutorialVideoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.targetScore, targetScore) ||
                other.targetScore == targetScore) &&
            (identical(other.levelIndex, levelIndex) ||
                other.levelIndex == levelIndex) &&
            (identical(other.isUnlocked, isUnlocked) ||
                other.isUnlocked == isUnlocked) &&
            (identical(other.starsEarned, starsEarned) ||
                other.starsEarned == starsEarned) &&
            (identical(other.tutorialVideoUrl, tutorialVideoUrl) ||
                other.tutorialVideoUrl == tutorialVideoUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description,
      difficulty, targetScore, levelIndex, isUnlocked, starsEarned, tutorialVideoUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GameDataImplCopyWith<_$GameDataImpl> get copyWith =>
      __$$GameDataImplCopyWithImpl<_$GameDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameDataImplToJson(
      this,
    );
  }
}

abstract class _GameData implements GameData {
  const factory _GameData(
      {required final String id,
      required final String title,
      required final String description,
      required final GameDifficulty difficulty,
      required final int targetScore,
      required final int levelIndex,
      final bool isUnlocked,
      final int starsEarned,
      final String? tutorialVideoUrl}) = _$GameDataImpl;

  factory _GameData.fromJson(Map<String, dynamic> json) =
      _$GameDataImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  GameDifficulty get difficulty;
  @override
  int get targetScore;
  @override
  int get levelIndex;
  @override
  bool get isUnlocked;
  @override
  int get starsEarned;
  @override
  String? get tutorialVideoUrl;
  @override
  @JsonKey(ignore: true)
  _$$GameDataImplCopyWith<_$GameDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
