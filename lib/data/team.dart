import 'club.dart';

class Team {
  final String name;
  final String? description;
  String? league; // Liga
  Club club;

  Team({required this.name, required this.club, this.description});
}
