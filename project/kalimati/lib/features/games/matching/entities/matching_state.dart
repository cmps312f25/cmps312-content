import 'package:flutter/foundation.dart';
import 'package:kalimati/core/entities/definition.dart';
import 'package:kalimati/core/entities/word.dart';
import 'package:kalimati/features/games/matching/entities/match_pair.dart';

enum PickSide { none, word, definition }

@immutable
class GameState {
  final List<MatchPair> pairs;
  final List<Word> words;
  final List<Definition> definitions;

  final int? selectedWordIndex;
  final int? selectedDefIndex;
  final PickSide pendingSide;

  final Map<Word, Definition> matched;

  final int attempts;
  final int score;
  final int seconds;
  final String feedback;

  const GameState({
    required this.pairs,
    required this.words,
    required this.definitions,
    required this.selectedWordIndex,
    required this.selectedDefIndex,
    required this.pendingSide,
    required this.matched,
    required this.attempts,
    required this.score,
    required this.seconds,
    required this.feedback,
  });

  GameState copyWith({
    List<MatchPair>? pairs,
    List<Word>? words,
    List<Definition>? definitions,
    int? selectedWordIndex,
    int? selectedDefIndex,
    PickSide? pendingSide,
    Map<Word, Definition>? matched,
    int? attempts,
    int? score,
    int? seconds,
    String? feedback,
  }) {
    return GameState(
      pairs: pairs ?? this.pairs,
      words: words ?? this.words,
      definitions: definitions ?? this.definitions,
      selectedWordIndex: selectedWordIndex ?? this.selectedWordIndex,
      selectedDefIndex: selectedDefIndex ?? this.selectedDefIndex,
      pendingSide: pendingSide ?? this.pendingSide,
      matched: matched ?? this.matched,
      attempts: attempts ?? this.attempts,
      score: score ?? this.score,
      seconds: seconds ?? this.seconds,
      feedback: feedback ?? this.feedback,
    );
  }
}
