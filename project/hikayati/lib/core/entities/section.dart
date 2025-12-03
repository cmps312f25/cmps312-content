class Section {
  final int? id;
  final int storyId;
  final String? imageUrl;
  final String? sectionText;
  final String? audioUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Section({
    this.id,
    required this.storyId,
    this.imageUrl,
    this.sectionText,
    this.audioUrl,
    required this.createdAt,
    this.updatedAt,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'] as int?,
      storyId: json['story_id'] as int,
      imageUrl: json['image_url'] as String?,
      sectionText: json['section_text'] as String?,
      audioUrl: json['audio_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'story_id': storyId,
      if (imageUrl != null) 'image_url': imageUrl,
      if (sectionText != null) 'section_text': sectionText,
      if (audioUrl != null) 'audio_url': audioUrl,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
