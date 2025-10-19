import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple constant provider for theme configuration.
final themeModeProvider = Provider<String>((ref) => 'light');
