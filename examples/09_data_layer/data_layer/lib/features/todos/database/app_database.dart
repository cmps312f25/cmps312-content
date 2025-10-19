import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:data_layer/features/todos/models/todo.dart';
import 'package:data_layer/features/todos/database/todo_dao.dart';

part 'app_database.g.dart'; // Generated file

@Database(version: 1, entities: [Todo])
abstract class AppDatabase extends FloorDatabase {
  TodoDao get todoDao;
}
