import 'dart:convert';
import 'package:floor/floor.dart';

class StringListConverter extends TypeConverter<List<String>?, String?> {
  @override
  List<String>? decode(String? databaseValue) {
    if (databaseValue == null) return null;
    final List<dynamic> jsonList = json.decode(databaseValue);
    return jsonList.map((e) => e.toString()).toList();
  }

  @override
  String? encode(List<String>? value) {
    if (value == null) return null;
    return json.encode(value);
  }
}
