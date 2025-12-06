import 'package:riverpod/riverpod.dart';
import 'package:kalimati/core/data/database/app_database.dart';

final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  final database = await $FloorAppDatabase
      .databaseBuilder('kalimati.db')
      .build();
  return database;
});
