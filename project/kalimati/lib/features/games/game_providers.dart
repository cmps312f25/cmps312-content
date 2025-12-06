import 'package:flutter_riverpod/legacy.dart';

/// Progress state tracking per package
final progressByPackageProvider = StateProvider<Map<String, Set<String>>>(
  (_) => {},
);

final gamesResetProvider = StateProvider<int>((_) => 0);
final packageResetTicksProvider = StateProvider<Map<String, int>>((_) => {});