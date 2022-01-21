import 'package:json_annotation/json_annotation.dart';

import '../data_object.dart';
import '../fight.dart';
import 'tournament.dart';

part 'tournament_fight.g.dart';

@JsonSerializable()
class TournamentFight extends DataObject {
  Tournament tournament;
  Fight fight;

  TournamentFight({int? id, required this.tournament, required this.fight}) : super(id);

  factory TournamentFight.fromJson(Map<String, dynamic> json) => _$TournamentFightFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TournamentFightToJson(this);

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'tournament_id': tournament.id,
      'fight_id': fight.id,
    };
  }
}
