import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kalimati/core/providers/package_provider.dart';
import 'package:kalimati/features/games/matching/entities/match_pair.dart';
import 'package:kalimati/features/games/matching/providers/matching_controller.dart';
import 'package:kalimati/features/games/matching/entities/matching_state.dart';

final ttsProvider = Provider<FlutterTts>((ref) => FlutterTts());

final pairsProvider = Provider<List<MatchPair>>((ref) {
  final pkg = ref.watch(packageNotifierProvider).value?.selectedPackage;
  if (pkg == null) return const <MatchPair>[];
  return pkg.words
      .where((w) => w.text.trim().isNotEmpty && w.definitions.isNotEmpty)
      .map((w) => MatchPair(word: w, definition: w.definitions.first))
      .take(8)
      .toList();
});

final gameProvider = StateNotifierProvider<GameController, GameState>((ref) {
  final pairs = ref.watch(pairsProvider);
  return GameController(pairs);
});
