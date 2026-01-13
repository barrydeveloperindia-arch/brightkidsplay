import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_node.freezed.dart';
part 'content_node.g.dart';

enum ContentType { video, book, game, quiz }

@freezed
class ContentNode with _$ContentNode {
  const factory ContentNode({
    required String id,
    required String title,
    required ContentType type,
    required String thumbnailUrl,
    required String resourceUrl, // URL to video file, epub, or game zip
    @Default(0) int minAge,
    @Default(99) int maxAge,
    @Default([]) List<String> skillTags,
    @Default(1) int version,
    @Default({}) Map<String, dynamic> metadata, // Flexible field for Quiz/Game specific data
  }) = _ContentNode;

  factory ContentNode.fromJson(Map<String, dynamic> json) => _$ContentNodeFromJson(json);
}
