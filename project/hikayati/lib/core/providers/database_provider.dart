import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/database/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Provider for the database singleton
final databaseProvider = FutureProvider<Database>((ref) async {
  return await DatabaseHelper.instance.database;
});
