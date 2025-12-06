import 'package:floor/floor.dart';
import 'package:kalimati/core/data/converters/string_list_converter.dart';
import 'package:kalimati/core/data/converters/word_list_converter.dart';
import 'package:kalimati/core/data/converters/date_converter.dart';

import 'package:kalimati/core/entities/word.dart';

@Entity(tableName: "packages")
@TypeConverters([WordListConverter, StringListConverter, DateTimeConverter])
class LearningPackage {
  @PrimaryKey()
  final String packageId;
  final String author;
  final String category;
  final String description;
  final String iconUrl;
  final List<String>? keyWords;
  final String language;
  final DateTime lastUpdateDate;
  final String level;
  final String title;
  final int version;
  final List<Word> words;

  LearningPackage({
    required this.packageId,
    required this.author,
    required this.category,
    required this.description,
    required this.iconUrl,
    this.keyWords,
    required this.language,
    required this.lastUpdateDate,
    required this.level,
    required this.title,
    required this.version,
    required this.words,
  });

  Map<String, dynamic> toJson() => {
    'packageId': packageId,
    'author': author,
    'category': category,
    'description': description,
    'iconUrl': iconUrl,
    'language': language,
    'lastUpdatedDate': lastUpdateDate.toIso8601String(),
    'level': level,
    'title': title,
    'version': version,
    'words': words.map((w) => w.toJson()).toList(),
  };

  factory LearningPackage.fromJson(Map<String, dynamic> json) {
    return LearningPackage(
      packageId: json['packageId'],
      author: json['author'],
      category: json['category'],
      description: json['description'],
      iconUrl: json['iconUrl'],
      language: json['language'],
      lastUpdateDate: DateTime.parse(json['lastUpdatedDate']),
      level: json['level'],
      title: json['title'],
      version: json['version'],
      words: (json['words'] as List)
          .map((w) => Word.fromJson(w as Map<String, dynamic>))
          .toList(),
    );
  }
}
