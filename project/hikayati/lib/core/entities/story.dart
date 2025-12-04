import 'package:hikayati/core/entities/reading_level.dart';

class Story {
  final int? id;
  final String title;
  final String language;
  final int? categoryId;
  final ReadingLevel readingLevel;
  final String? coverImageUrl;
  final int authorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Story({
    this.id,
    required this.title,
    required this.language,
    this.categoryId,
    required this.readingLevel,
    this.coverImageUrl,
    required this.authorId,
    this.createdAt,
    this.updatedAt,
  });

  const Story.create({
    required this.title,
    required this.language,
    this.categoryId,
    required this.readingLevel,
    this.coverImageUrl,
    required this.authorId,
  }) : id = null,
       createdAt = null,
       updatedAt = null;

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] as int?,
      title: json['title'] as String,
      language: json['language'] as String,
      coverImageUrl: json['cover_image_url'] as String?,
      readingLevel: ReadingLevel.fromString(json['reading_level'] as String),
      categoryId: json['category_id'] as int?,
      authorId: json['author_id'] as int,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
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
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
