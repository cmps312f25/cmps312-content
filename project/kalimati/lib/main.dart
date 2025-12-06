import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalimati/core/providers/database_provider.dart';
import 'package:kalimati/core/data/database/database_seeder.dart';
import 'package:kalimati/core/router/app_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite for desktop platforms
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final container = ProviderContainer();

  try {
    await DatabaseSeeder.resetDatabase();
    final database = await container.read(databaseProvider.future);
    await DatabaseSeeder.seedDatabase(database);

    debugPrint('Database initialized and seeded successfully');
  } catch (e) {
    debugPrint('Error initializing database: $e');
  }

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Kalimati',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
        ), // green accent
      ),
      routerConfig: AppRouter.router,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 599, name: MOBILE),
          const Breakpoint(start: 600, end: 1199, name: TABLET),
          const Breakpoint(start: 1200, end: double.infinity, name: DESKTOP),
        ],
      ),
    );
  }
}
