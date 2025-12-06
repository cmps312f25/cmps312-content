import 'package:kalimati/core/entities/definition.dart';
import 'package:kalimati/core/entities/resource.dart';
import 'package:kalimati/core/entities/sentence.dart';

class Word {
  String text;
  List<Sentence> sentences;
  List<Definition> definitions;
  List<Resource> resources;

  Word({
    required this.text,
    required this.definitions,
    required this.sentences,
    required this.resources,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'definitions': definitions.map((d) => d.toJson()).toList(),
    'sentences': sentences.map((s) => s.toJson()).toList(),
    'resources': resources.map((r) => r.toJson()).toList(),
  };

  factory Word.fromJson(Map<String, dynamic> json) {
    final sentences =
        (json['sentences'] as List?)
            ?.map((s) => Sentence.fromJson(s as Map<String, dynamic>))
            .toList() ??
        [];

    final directResources =
        (json['resources'] as List?)
            ?.map((r) => Resource.fromJson(r as Map<String, dynamic>))
            .toList() ??
        [];

    final sentenceResources = sentences.expand((s) => s.resources).toList();

    final allResources = <Resource>[...directResources, ...sentenceResources];

    return Word(
      text: json['text'] ?? '',
      definitions:
          (json['definitions'] as List?)
              ?.map((d) => Definition.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
      sentences: sentences,
      resources: allResources,
    );
  }
}
