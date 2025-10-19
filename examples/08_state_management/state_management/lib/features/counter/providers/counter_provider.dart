import 'package:flutter_riverpod/flutter_riverpod.dart';

/// NotifierProvider for mutable state with methods to update the state.
class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0; // Initial state

  void increment() => state++; // state++ triggers rebuild

  void decrement() {
    if (state > 0) state--; // Guard against negative values
  }
}

// NotifierProvider<CounterNotifier, int>:
// - CounterNotifier: The notifier class managing the state
// - int: The type of state being managed
final counterProvider = NotifierProvider<CounterNotifier, int>(
  () => CounterNotifier(),
);
