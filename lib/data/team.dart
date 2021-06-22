import 'package:wrestling_scoreboard/data/league.dart';

import 'club.dart';

class Team {
  final String name;
  final String? description;
  League? league;
  Club club;

  Team({required this.name, required this.club, this.description});
}
