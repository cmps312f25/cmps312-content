import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_app/app/router.dart';

/// Initializes Supabase before starting the app.
///
/// This reads the Supabase URL and anon key from Dart defines:
///   --dart-define=SUPABASE_URL=<your-url>
///   --dart-define=SUPABASE_ANON_KEY=<your-anon-key>
///
/// Example:
/// flutter run -d chrome --dart-define=SUPABASE_URL=https://xyz.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=public-anon-key
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //final supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
  final supabaseUrl = 'https://yjjocdqlflvamdmrhuyq.supabase.co';
  //final supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');
  final supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlqam9jZHFsZmx2YW1kbXJodXlxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMyNTY4NDMsImV4cCI6MjA3ODgzMjg0M30.nEo9geEoiaE_quKTpXhQE_n6olHxBKT0HAMJIGbrpxQ';

  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    // Provide a helpful error rather than crashing with a cryptic null error.
    throw StateError(
      'Supabase not configured. Please pass SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define.',
    );
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        title: 'Data Layer Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}

/*
const items = ['desk', null, 'lamp', '', 'monitor', null];

List<int> lengths = [];
for (var item in items) {
  if (item == null || item.isEmpty) {
    lengths.add(0);
  } else {
    lengths.add(item.length);
  }
}

const values = [3, 6, 7, 10, 11, 14];

List<int> oddCubes = [];
for (var v in values) {
  if (v.isOdd) {
    oddCubes.add(v * v * v);
  }
}

print('Cubes of odd values: $oddCubes');

print('Item lengths: $lengths');

final lengths = items.map((item) => item?.length ?? 0).toList();

final oddCubes = values.where((v) => v.isOdd).map((v) => v * v * v).toList();

Future<List<String>> getImageUrls() async {
  final storage = Supabase.instance.client.storage;
  final files = await storage.from('images').list(path: '');
  return files.map((f) => storage.from('images').getPublicUrl(f.name)).toList();
}

Future<List<String>> getImageUrls() async {
  final storage = Supabase.instance.client.storage;
  final files = await storage.from('images').list(path: '');
  return Future.wait(files.map((f) =>
      storage.from('images').createSignedUrl(f.name, 3600)));
}*/