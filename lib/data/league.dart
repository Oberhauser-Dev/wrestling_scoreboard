class League {
  static League outOfCompetition = League(name: 'Out of competition', year: DateTime(DateTime.now().year));
  DateTime year;
  String name;

  League({required this.name, required this.year});
}
