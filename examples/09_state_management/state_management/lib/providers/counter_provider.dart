import 'package:flutter_riverpod/flutter_riverpod.dart';

// Manages counter state with increment/decrement methods
class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0; // Initial state

  void increment() => state++;

  void decrement() {
    if (state > 0) state--;
  }
}

// NotifierProvider<CounterNotifier, int>:
// - CounterNotifier: The notifier class managing the state
// - int: The type of state being managed
final counterProvider = NotifierProvider<CounterNotifier, int>(
  CounterNotifier.new);
