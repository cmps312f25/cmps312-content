import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier for search query text
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;

  void clear() => state = '';
}

/// Notifier for type filter selection
/// null means no type filtering (show all types)
class SearchTypeFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setFilter(String? filter) => state = filter;

  void clear() => state = null;
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  () => SearchQueryNotifier(),
);

final searchTypeFilterProvider =
    NotifierProvider<SearchTypeFilterNotifier, String?>(
      () => SearchTypeFilterNotifier(),
    );
