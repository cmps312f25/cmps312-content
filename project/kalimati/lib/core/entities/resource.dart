import 'package:kalimati/core/entities/enum/resource_type.dart';

class Resource {
  String extension;
  String resourceUrl;
  String title;
  ResourceType type;

  Resource({
    required this.extension,
    required this.resourceUrl,
    required this.title,
    required this.type,
  });

  String get url => resourceUrl;

  Map<String, dynamic> toJson() => {
    'extension': extension,
    'resourceUrl': resourceUrl,
    'title': title,
    'type': type.name,
  };

  static ResourceType _parseResourceType(dynamic value) {
    if (value == null) return ResourceType.unknown;
    if (value is ResourceType) return value;
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'photo':
          return ResourceType.photo;
        case 'video':
          return ResourceType.video;
        case 'audio':
          return ResourceType.audio;
        case 'website':
          return ResourceType.website;
        default:
          return ResourceType.unknown;
      }
    }
    return ResourceType.unknown;
  }

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
    resourceUrl: json['resourceUrl'] ?? json['url'] ?? '',
    type: _parseResourceType(json['type']),
    title: json['title'] ?? '',
    extension: json['extension'] ?? '',
  );
}
