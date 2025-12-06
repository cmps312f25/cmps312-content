import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:kalimati/core/providers/package_provider.dart';
import 'unscramble_controller.dart';
import 'unscramble_state.dart';

final selectedSentencesProvider = Provider<List<String>>((ref) {
  final selectedPackage =
      ref.watch(packageNotifierProvider).value?.selectedPackage;

  final sentences = <String>[];
  if (selectedPackage != null) {
    for (final w in selectedPackage.words) {
      for (final s in w.sentences) {
        final t = s.text.trim();
        if (t.isNotEmpty) sentences.add(t);
      }
    }
  }
  return sentences;
});

final unscrambleGameProvider =
    StateNotifierProvider<UnscrambleGameController, UnscrambleGameState>((ref) {
  final sentences = ref.watch(selectedSentencesProvider);
  return UnscrambleGameController(sentences);
});
