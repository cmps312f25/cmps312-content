enum LevelFilter { all, beginner, intermediate, advanced }

extension LevelFilterX on LevelFilter {
  String get label => switch (this) {
        LevelFilter.all => 'All',
        LevelFilter.beginner => 'Beginner',
        LevelFilter.intermediate => 'Intermediate',
        LevelFilter.advanced => 'Advanced',
      };
}
