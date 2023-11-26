import 'package:json_annotation/json_annotation.dart';

import '../data_object.dart';
import '../team.dart';
import 'tournament.dart';

part 'tournament_team_participation.g.dart';

/// Team participates in a tournament.
@JsonSerializable()
class TournamentTeamParticipation extends DataObject {
  Team team;
  Tournament tournament;

  TournamentTeamParticipation({int? id, required this.tournament, required this.team}) : super(id);

  factory TournamentTeamParticipation.fromJson(Map<String, dynamic> json) =>
      _$TournamentTeamParticipationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TournamentTeamParticipationToJson(this);

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'tournament_id': tournament.id,
      'team_id': team.id,
    };
  }

  static Future<TournamentTeamParticipation> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async =>
      TournamentTeamParticipation(
        id: e['id'] as int?,
        tournament: (await getSingle<Tournament>(e['tournament_id'] as int))!,
        team: (await getSingle<Team>(e['team_id'] as int))!,
      );
}
