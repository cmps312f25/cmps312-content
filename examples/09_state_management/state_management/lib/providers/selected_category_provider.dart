import 'package:flutter_riverpod/flutter_riverpod.dart';

// Manages selected category state for product filtering
class SelectedCategoryNotifier extends Notifier<String?> {
  @override
  String? build() => null; // Initial: no category selected (show all)

  void setCategory(String? category) => state = category;
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String?>(
      SelectedCategoryNotifier.new,
    );
