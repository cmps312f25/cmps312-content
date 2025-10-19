import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier for mutable state (category selection).
/// Use Notifier when you need to modify state with custom methods.
class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'All'; // Initial state

  void setCategory(String category) {
    state = category; // Updating state triggers UI rebuild
  }
}

/// NotifierProvider exposes both the notifier and its state.
/// Read state: ref.watch(selectedCategoryProvider)
/// Call methods: ref.read(selectedCategoryProvider.notifier).setCategory(...)
final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String>(
      () => SelectedCategoryNotifier(),
    );
