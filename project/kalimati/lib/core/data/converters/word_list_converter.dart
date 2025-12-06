import 'dart:convert';
import 'package:floor/floor.dart';
import 'package:kalimati/core/entities/word.dart';

class WordListConverter extends TypeConverter<List<Word>, String> {
  @override
  List<Word> decode(String databaseValue) {
    final List<dynamic> jsonList = json.decode(databaseValue);
    return jsonList
        .map((e) => Word.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  String encode(List<Word> value) {
    final List<Map<String, dynamic>> jsonList = value
        .map((w) => w.toJson())
        .toList();
    return json.encode(jsonList);
  }
}
