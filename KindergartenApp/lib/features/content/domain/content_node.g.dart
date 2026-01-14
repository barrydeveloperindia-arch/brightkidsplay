// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContentNodeImpl _$$ContentNodeImplFromJson(Map<String, dynamic> json) =>
    _$ContentNodeImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      type: $enumDecode(_$ContentTypeEnumMap, json['type']),
      thumbnailUrl: json['thumbnailUrl'] as String,
      resourceUrl: json['resourceUrl'] as String,
      minAge: (json['minAge'] as num?)?.toInt() ?? 0,
      maxAge: (json['maxAge'] as num?)?.toInt() ?? 99,
      skillTags: (json['skillTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      version: (json['version'] as num?)?.toInt() ?? 1,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$ContentNodeImplToJson(_$ContentNodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': _$ContentTypeEnumMap[instance.type]!,
      'thumbnailUrl': instance.thumbnailUrl,
      'resourceUrl': instance.resourceUrl,
      'minAge': instance.minAge,
      'maxAge': instance.maxAge,
      'skillTags': instance.skillTags,
      'version': instance.version,
      'metadata': instance.metadata,
    };

const _$ContentTypeEnumMap = {
  ContentType.video: 'video',
  ContentType.book: 'book',
  ContentType.game: 'game',
  ContentType.quiz: 'quiz',
  ContentType.music: 'music',
};
