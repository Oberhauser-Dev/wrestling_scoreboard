import 'package:json_annotation/json_annotation.dart';

import '../data_object.dart';
import '../fight.dart';
import 'tournament.dart';

part 'tournament_fight.g.dart';

@JsonSerializable()
class TournamentFight extends DataObject {
  final Tournament tournament;
  final Fight fight;

  TournamentFight({int? id, required this.tournament, required this.fight}) : super(id);
}
