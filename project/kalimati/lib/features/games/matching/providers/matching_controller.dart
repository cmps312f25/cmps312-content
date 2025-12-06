import 'dart:async';
import 'package:flutter_riverpod/legacy.dart';
import 'package:kalimati/core/entities/definition.dart';
import 'package:kalimati/core/entities/word.dart';
import 'package:kalimati/features/games/matching/entities/match_pair.dart';
import 'package:kalimati/features/games/matching/entities/matching_state.dart';

class GameController extends StateNotifier<GameState> {
  GameController(List<MatchPair> pairs)
      : _timer = Timer.periodic(const Duration(seconds: 1), (_) {}),
        super(_initialState(pairs)) {
    _timer.cancel();
  }

  Timer _timer;
  bool _running = false;

  static GameState _initialState(List<MatchPair> pairs) {
    final left = pairs.map((p) => p.word).toList()..shuffle();
    final right = pairs.map((p) => p.definition).toList()..shuffle();
    return GameState(
      pairs: pairs,
      words: left,
      definitions: right,
      selectedWordIndex: null,
      selectedDefIndex: null,
      pendingSide: PickSide.none,
      matched: <Word, Definition>{},
      attempts: 0,
      score: 0,
      seconds: 0,
      feedback: '',
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    if (_running) return;
    _running = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(seconds: state.seconds + 1);
    });
  }

  void pauseTimer() {
    if (!_running) return;
    _running = false;
    _timer.cancel();
  }

  void resumeTimer() {
    if (_running) return;
    startTimer();
  }

  bool _isMatch(Word w, Definition d) =>
      state.pairs.any((p) => p.word == w && p.definition == d);

  void selectWord(int index) {
    if (state.pendingSide == PickSide.none || state.pendingSide == PickSide.word) {
      state = state.copyWith(
        selectedWordIndex: index,
        pendingSide: PickSide.word,
        feedback: '',
      );
      return;
    }
    if (state.pendingSide == PickSide.definition) {
      state = state.copyWith(selectedWordIndex: index);
      _resolveAttemptAndReset();
    }
  }

  void selectDefinition(int index) {
    if (state.pendingSide == PickSide.none || state.pendingSide == PickSide.definition) {
      state = state.copyWith(
        selectedDefIndex: index,
        pendingSide: PickSide.definition,
        feedback: '',
      );
      return;
    }
    if (state.pendingSide == PickSide.word) {
      state = state.copyWith(selectedDefIndex: index);
      _resolveAttemptAndReset();
    }
  }

  void _resolveAttemptAndReset() {
    final wi = state.selectedWordIndex;
    final di = state.selectedDefIndex;
    if (wi == null || di == null) return;

    final w = state.words[wi];
    final d = state.definitions[di];
    final nextAttempts = state.attempts + 1;

    if (_isMatch(w, d)) {
      final next = Map<Word, Definition>.from(state.matched)..[w] = d;
      state = state.copyWith(
        matched: next,
        score: next.length,
        feedback: '✅ Correct!',
        attempts: nextAttempts,
      );
    } else {
      state = state.copyWith(
        feedback: '❌ Not quite, try again.',
        attempts: nextAttempts,
      );
    }

    state = state.copyWith(
      selectedWordIndex: null,
      selectedDefIndex: null,
      pendingSide: PickSide.none,
    );
  }

  void restartGame() {
    final reshuffledWords = List<Word>.from(state.words)..shuffle();
    final reshuffledDefs = List<Definition>.from(state.definitions)..shuffle();
    state = state.copyWith(
      words: reshuffledWords,
      definitions: reshuffledDefs,
      matched: <Word, Definition>{},
      selectedWordIndex: null,
      selectedDefIndex: null,
      pendingSide: PickSide.none,
      attempts: 0,
      score: 0,
      seconds: 0,
      feedback: '',
    );
  }

  bool isFinished() => state.matched.length >= state.pairs.length;
}
