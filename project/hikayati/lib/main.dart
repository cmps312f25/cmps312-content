import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/app/app.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  // Add these lines
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Note: Database is automatically created and seeded on first run
  // Only uncomment the line below if you need to reset the database for development
  // await DatabaseHelper.instance.deleteDatabase();

  runApp(const ProviderScope(child: App()));
}
