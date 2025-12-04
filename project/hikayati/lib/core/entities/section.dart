class Section {
  final int? id;
  final int storyId;
  final String sectionText;
  final String? imageUrl;
  final String? audioUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Section({
    this.id,
    required this.storyId,
    required this.sectionText,
    this.imageUrl,
    this.audioUrl,
    this.createdAt,
    this.updatedAt,
  });

  const Section.create({
    required this.storyId,
    required this.sectionText,
    this.imageUrl,
    this.audioUrl,
  }) : id = null,
       createdAt = null,
       updatedAt = null;

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'] as int?,
      storyId: json['story_id'] as int,
      sectionText: json['section_text'] as String,
      imageUrl: json['image_url'] as String?,
      audioUrl: json['audio_url'] as String?,
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
      'story_id': storyId,
      'section_text': sectionText,
      if (imageUrl != null) 'image_url': imageUrl,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
