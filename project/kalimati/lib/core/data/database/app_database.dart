import 'dart:async';
import 'package:kalimati/core/entities/user.dart';
import 'package:kalimati/core/data/converters/date_converter.dart';
import 'package:kalimati/core/data/converters/string_list_converter.dart';
import 'package:kalimati/core/data/converters/word_list_converter.dart';
import 'package:kalimati/core/data/daos/learning_package_dao.dart';
import 'package:kalimati/core/data/daos/user_dao.dart';
import 'package:kalimati/core/entities/learning_package.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:floor/floor.dart';

part 'app_database.g.dart';

@Database(version: 3, entities: [LearningPackage, User])
abstract class AppDatabase extends FloorDatabase {
  LearningPackageDao get learningPackageDao;
  UserDao get userDao;
}
