// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContentNode _$ContentNodeFromJson(Map<String, dynamic> json) {
  return _ContentNode.fromJson(json);
}

/// @nodoc
mixin _$ContentNode {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  ContentType get type => throw _privateConstructorUsedError;
  String get thumbnailUrl => throw _privateConstructorUsedError;
  String get resourceUrl =>
      throw _privateConstructorUsedError; // URL to video file, epub, or game zip
  int get minAge => throw _privateConstructorUsedError;
  int get maxAge => throw _privateConstructorUsedError;
  List<String> get skillTags => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContentNodeCopyWith<ContentNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentNodeCopyWith<$Res> {
  factory $ContentNodeCopyWith(
          ContentNode value, $Res Function(ContentNode) then) =
      _$ContentNodeCopyWithImpl<$Res, ContentNode>;
  @useResult
  $Res call(
      {String id,
      String title,
      ContentType type,
      String thumbnailUrl,
      String resourceUrl,
      int minAge,
      int maxAge,
      List<String> skillTags,
      int version,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$ContentNodeCopyWithImpl<$Res, $Val extends ContentNode>
    implements $ContentNodeCopyWith<$Res> {
  _$ContentNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? thumbnailUrl = null,
    Object? resourceUrl = null,
    Object? minAge = null,
    Object? maxAge = null,
    Object? skillTags = null,
    Object? version = null,
    Object? metadata = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ContentType,
      thumbnailUrl: null == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String,
      resourceUrl: null == resourceUrl
          ? _value.resourceUrl
          : resourceUrl // ignore: cast_nullable_to_non_nullable
              as String,
      minAge: null == minAge
          ? _value.minAge
          : minAge // ignore: cast_nullable_to_non_nullable
              as int,
      maxAge: null == maxAge
          ? _value.maxAge
          : maxAge // ignore: cast_nullable_to_non_nullable
              as int,
      skillTags: null == skillTags
          ? _value.skillTags
          : skillTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContentNodeImplCopyWith<$Res>
    implements $ContentNodeCopyWith<$Res> {
  factory _$$ContentNodeImplCopyWith(
          _$ContentNodeImpl value, $Res Function(_$ContentNodeImpl) then) =
      __$$ContentNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      ContentType type,
      String thumbnailUrl,
      String resourceUrl,
      int minAge,
      int maxAge,
      List<String> skillTags,
      int version,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$ContentNodeImplCopyWithImpl<$Res>
    extends _$ContentNodeCopyWithImpl<$Res, _$ContentNodeImpl>
    implements _$$ContentNodeImplCopyWith<$Res> {
  __$$ContentNodeImplCopyWithImpl(
      _$ContentNodeImpl _value, $Res Function(_$ContentNodeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? thumbnailUrl = null,
    Object? resourceUrl = null,
    Object? minAge = null,
    Object? maxAge = null,
    Object? skillTags = null,
    Object? version = null,
    Object? metadata = null,
  }) {
    return _then(_$ContentNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ContentType,
      thumbnailUrl: null == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String,
      resourceUrl: null == resourceUrl
          ? _value.resourceUrl
          : resourceUrl // ignore: cast_nullable_to_non_nullable
              as String,
      minAge: null == minAge
          ? _value.minAge
          : minAge // ignore: cast_nullable_to_non_nullable
              as int,
      maxAge: null == maxAge
          ? _value.maxAge
          : maxAge // ignore: cast_nullable_to_non_nullable
              as int,
      skillTags: null == skillTags
          ? _value._skillTags
          : skillTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentNodeImpl implements _ContentNode {
  const _$ContentNodeImpl(
      {required this.id,
      required this.title,
      required this.type,
      required this.thumbnailUrl,
      required this.resourceUrl,
      this.minAge = 0,
      this.maxAge = 99,
      final List<String> skillTags = const [],
      this.version = 1,
      final Map<String, dynamic> metadata = const {}})
      : _skillTags = skillTags,
        _metadata = metadata;

  factory _$ContentNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentNodeImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final ContentType type;
  @override
  final String thumbnailUrl;
  @override
  final String resourceUrl;
// URL to video file, epub, or game zip
  @override
  @JsonKey()
  final int minAge;
  @override
  @JsonKey()
  final int maxAge;
  final List<String> _skillTags;
  @override
  @JsonKey()
  List<String> get skillTags {
    if (_skillTags is EqualUnmodifiableListView) return _skillTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillTags);
  }

  @override
  @JsonKey()
  final int version;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'ContentNode(id: $id, title: $title, type: $type, thumbnailUrl: $thumbnailUrl, resourceUrl: $resourceUrl, minAge: $minAge, maxAge: $maxAge, skillTags: $skillTags, version: $version, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.resourceUrl, resourceUrl) ||
                other.resourceUrl == resourceUrl) &&
            (identical(other.minAge, minAge) || other.minAge == minAge) &&
            (identical(other.maxAge, maxAge) || other.maxAge == maxAge) &&
            const DeepCollectionEquality()
                .equals(other._skillTags, _skillTags) &&
            (identical(other.version, version) || other.version == version) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      type,
      thumbnailUrl,
      resourceUrl,
      minAge,
      maxAge,
      const DeepCollectionEquality().hash(_skillTags),
      version,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentNodeImplCopyWith<_$ContentNodeImpl> get copyWith =>
      __$$ContentNodeImplCopyWithImpl<_$ContentNodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentNodeImplToJson(
      this,
    );
  }
}

abstract class _ContentNode implements ContentNode {
  const factory _ContentNode(
      {required final String id,
      required final String title,
      required final ContentType type,
      required final String thumbnailUrl,
      required final String resourceUrl,
      final int minAge,
      final int maxAge,
      final List<String> skillTags,
      final int version,
      final Map<String, dynamic> metadata}) = _$ContentNodeImpl;

  factory _ContentNode.fromJson(Map<String, dynamic> json) =
      _$ContentNodeImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  ContentType get type;
  @override
  String get thumbnailUrl;
  @override
  String get resourceUrl;
  @override // URL to video file, epub, or game zip
  int get minAge;
  @override
  int get maxAge;
  @override
  List<String> get skillTags;
  @override
  int get version;
  @override
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$ContentNodeImplCopyWith<_$ContentNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
