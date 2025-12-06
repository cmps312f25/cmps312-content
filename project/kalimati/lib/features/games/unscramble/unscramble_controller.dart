import 'package:flutter_riverpod/legacy.dart';
import 'unscramble_state.dart';

class UnscrambleGameController extends StateNotifier<UnscrambleGameState> {
  UnscrambleGameController(List<String> sentences)
      : super(_initialState(sentences));

  static UnscrambleGameState _initialState(List<String> sentences) {
    final idx = 0;
    final target = _cleanSentenceToWords(sentences.isEmpty ? '' : sentences[idx]);
    final pool = List<String>.from(target)..shuffle();
    final limit = _computeHintLimit(target.length);
    return UnscrambleGameState(
      sentences: sentences,
      currentIndex: 0,
      correctWords: target,
      availableWords: pool,
      chosenWords: const <String>[],
      attemptStatus: AttemptStatus.idle,
      hintsUsed: 0,
      hintsLimit: limit,
    );
  }

  static List<String> _cleanSentenceToWords(String sentence) {
    final cleaned = sentence
        .replaceAll(RegExp(r"[^\w'\s]+"), ' ')
        .replaceAll(RegExp(r"\s+"), ' ')
        .trim();
    return cleaned.isEmpty ? <String>[] : cleaned.split(' ');
  }

  static int _computeHintLimit(int wordCount) => (wordCount ~/ 2);

  void pickFromAvailable(int poolIndex) {
    if (poolIndex < 0 || poolIndex >= state.availableWords.length) return;
    final nextChosen = List<String>.from(state.chosenWords)
      ..add(state.availableWords[poolIndex]);
    final nextAvailable = List<String>.from(state.availableWords)
      ..removeAt(poolIndex);
    state = state.copyWith(
      chosenWords: nextChosen,
      availableWords: nextAvailable,
      attemptStatus: AttemptStatus.idle,
    );
  }

  void removeFromChosen(int chosenIndex) {
    if (chosenIndex < 0 || chosenIndex >= state.chosenWords.length) return;
    final word = state.chosenWords[chosenIndex];
    final nextChosen = List<String>.from(state.chosenWords)
      ..removeAt(chosenIndex);
    final nextAvailable = List<String>.from(state.availableWords)..add(word);
    state = state.copyWith(
      chosenWords: nextChosen,
      availableWords: nextAvailable,
      attemptStatus: AttemptStatus.idle,
    );
  }

  void shuffleAvailableWords() {
    final next = List<String>.from(state.availableWords)..shuffle();
    state = state.copyWith(
      availableWords: next,
      attemptStatus: AttemptStatus.idle,
    );
  }

  /// Restart the **current sentence only**
  void restartSentence() {
    final pool = List<String>.from(state.correctWords)..shuffle();
    state = state.copyWith(
      availableWords: pool,
      chosenWords: <String>[],
      attemptStatus: AttemptStatus.idle,
      hintsUsed: 0,
      hintsLimit: _computeHintLimit(state.correctWords.length),
    );
  }

  /// Restart the **whole game** from sentence 1
  void restartGame() {
    if (state.sentences.isEmpty) return;
    final idx = 0;
    final target = _cleanSentenceToWords(state.sentences[idx]);
    final pool = List<String>.from(target)..shuffle();
    state = state.copyWith(
      currentIndex: 0,
      correctWords: target,
      availableWords: pool,
      chosenWords: <String>[],
      attemptStatus: AttemptStatus.idle,
      hintsUsed: 0,
      hintsLimit: _computeHintLimit(target.length),
    );
  }

  HintResult useHint() {
    if (state.hintsUsed >= state.hintsLimit) return HintResult.overLimit;
    final nextIndex = state.chosenWords.length;
    if (nextIndex >= state.correctWords.length) return HintResult.overLimit;

    final nextWord = state.correctWords[nextIndex];
    final idx = state.availableWords.indexWhere(
      (w) => w.toLowerCase() == nextWord.toLowerCase(),
    );
    if (idx == -1) return HintResult.overLimit;

    final chosen = List<String>.from(state.chosenWords)
      ..add(state.availableWords[idx]);
    final avail = List<String>.from(state.availableWords)..removeAt(idx);
    state = state.copyWith(
      chosenWords: chosen,
      availableWords: avail,
      attemptStatus: AttemptStatus.idle,
      hintsUsed: state.hintsUsed + 1,
    );
    return HintResult.used;
  }

  void validateAttempt() {
    final attempt = state.chosenWords.join(' ').toLowerCase().trim();
    final target = state.correctWords.join(' ').toLowerCase().trim();
    final status = (attempt == target &&
            state.chosenWords.length == state.correctWords.length)
        ? AttemptStatus.correct
        : AttemptStatus.incorrect;
    state = state.copyWith(attemptStatus: status);
  }

  void nextSentence() {
    if (state.sentences.isEmpty) return;
    final nextIndex = (state.currentIndex + 1) % state.sentences.length;
    final nextTarget = _cleanSentenceToWords(state.sentences[nextIndex]);
    final nextPool = List<String>.from(nextTarget)..shuffle();
    state = state.copyWith(
      currentIndex: nextIndex,
      correctWords: nextTarget,
      availableWords: nextPool,
      chosenWords: <String>[],
      attemptStatus: AttemptStatus.idle,
      hintsUsed: 0,
      hintsLimit: _computeHintLimit(nextTarget.length),
    );
  }
}
