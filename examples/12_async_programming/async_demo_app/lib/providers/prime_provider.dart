import 'dart:isolate';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simulates a long-running computation that takes 3 seconds to complete.
/// Returns a random BigInt representing a "prime" number.
BigInt nextProbablePrime() {
  _sleep(const Duration(seconds: 3));
  return BigInt.from(Random().nextInt(1000000));
}

class AsyncPrimeNotifier extends AsyncNotifier<BigInt> {
  @override
  Future<BigInt> build() async => BigInt.zero;

  /// Computes prime using Future.delayed (runs on main isolate with delay)
  Future<void> getPrimeBigIntAsync() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await Future.delayed(
        const Duration(seconds: 1),
        nextProbablePrime,
      );
    });
  }

  /// Computes prime using Isolate.run (runs on separate isolate)
  Future<void> getPrimeBigIntIsolate() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => Isolate.run(nextProbablePrime));
  }
}

final asyncPrimeProvider =
    AsyncNotifierProvider<AsyncPrimeNotifier, BigInt>(AsyncPrimeNotifier.new);

/// Blocks the current thread for the specified duration.
/// Used to simulate heavy computation work.
void _sleep(Duration duration) {
  final start = DateTime.now().millisecondsSinceEpoch;
  final end = start + duration.inMilliseconds;
  while (DateTime.now().millisecondsSinceEpoch < end) {}
}
