import 'package:hikayati/core/entities/reading_level.dart';

class Story {
  final int? id;
  final String title;
  final String language;
  final String? coverImageUrl;
  final ReadingLevel readingLevel;
  final int? categoryId;
  final int authorId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Story({
    this.id,
    required this.title,
    required this.language,
    this.coverImageUrl,
    required this.readingLevel,
    this.categoryId,
    required this.authorId,
    required this.createdAt,
    this.updatedAt,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] as int?,
      title: json['title'] as String,
      language: json['language'] as String,
      coverImageUrl: json['cover_image_url'] as String?,
      readingLevel: ReadingLevel.fromString(json['reading_level'] as String),
      categoryId: json['category_id'] as int?,
      authorId: json['author_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'language': language,
      if (coverImageUrl != null) 'cover_image_url': coverImageUrl,
      'reading_level': readingLevel.value,
      if (categoryId != null) 'category_id': categoryId,
      'author_id': authorId,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
