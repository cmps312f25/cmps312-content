import 'package:flutter/foundation.dart';

enum AttemptStatus { idle, correct, incorrect }
enum HintResult { used, overLimit, ok }

@immutable
class UnscrambleGameState {
  final List<String> sentences;
  final int currentIndex;
  final List<String> correctWords;
  final List<String> availableWords;
  final List<String> chosenWords;
  final AttemptStatus attemptStatus;
  final int hintsUsed;
  final int hintsLimit;

  const UnscrambleGameState({
    required this.sentences,
    required this.currentIndex,
    required this.correctWords,
    required this.availableWords,
    required this.chosenWords,
    required this.attemptStatus,
    required this.hintsUsed,
    required this.hintsLimit,
  });

  UnscrambleGameState copyWith({
    List<String>? sentences,
    int? currentIndex,
    List<String>? correctWords,
    List<String>? availableWords,
    List<String>? chosenWords,
    AttemptStatus? attemptStatus,
    int? hintsUsed,
    int? hintsLimit,
  }) {
    return UnscrambleGameState(
      sentences: sentences ?? this.sentences,
      currentIndex: currentIndex ?? this.currentIndex,
      correctWords: correctWords ?? this.correctWords,
      availableWords: availableWords ?? this.availableWords,
      chosenWords: chosenWords ?? this.chosenWords,
      attemptStatus: attemptStatus ?? this.attemptStatus,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      hintsLimit: hintsLimit ?? this.hintsLimit,
    );
  }
}
