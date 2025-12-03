enum ReadingLevel {
  kg1('KG1'),
  kg2('KG2'),
  year1('Year 1'),
  year2('Year 2'),
  year3('Year 3'),
  year4('Year 4'),
  year5('Year 5'),
  year6('Year 6');

  final String value;
  const ReadingLevel(this.value);

  static ReadingLevel fromString(String level) {
    return ReadingLevel.values.firstWhere(
      (e) => e.value == level,
      orElse: () => ReadingLevel.kg1,
    );
  }
}

