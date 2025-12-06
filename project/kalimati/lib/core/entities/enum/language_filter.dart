enum LanguageFilter { all, english, french, arabic }

extension LanguageFilterX on LanguageFilter {
  String get label => switch (this) {
        LanguageFilter.all => 'All',
        LanguageFilter.english => 'English',
        LanguageFilter.french => 'French',
        LanguageFilter.arabic => 'Arabic',
      };
}
