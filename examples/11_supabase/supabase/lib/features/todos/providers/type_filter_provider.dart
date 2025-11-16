import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier for type filter selection
/// null means no type filtering (show all types)
class TypeFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setFilter(String? filter) => state = filter;

  void clear() => state = null;
}

final typeFilterProvider = NotifierProvider<TypeFilterNotifier, String?>(
  () => TypeFilterNotifier(),
);
