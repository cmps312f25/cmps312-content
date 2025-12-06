import 'package:kalimati/core/entities/resource.dart';

class Sentence {
  String text;
  List<Resource> resources;

  Sentence({required this.text, required this.resources});

  Map<String, dynamic> toJson() => {
    'text': text,
    'resources': resources.map((r) => r.toJson()).toList(),
  };

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      text: json['text'] ?? '',
      resources: (json['resources'] as List?)
              ?.map((r) => Resource.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
