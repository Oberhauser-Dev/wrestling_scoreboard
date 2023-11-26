import 'package:json_annotation/json_annotation.dart';

import '../data_object.dart';
import '../team.dart';
import 'league.dart';

part 'league_team_participation.g.dart';

/// Team participates in a league.
@JsonSerializable()
class LeagueTeamParticipation extends DataObject {
  Team team;
  League league;

  LeagueTeamParticipation({int? id, required this.league, required this.team}) : super(id);

  factory LeagueTeamParticipation.fromJson(Map<String, dynamic> json) => _$LeagueTeamParticipationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LeagueTeamParticipationToJson(this);

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'league_id': league.id,
      'team_id': team.id,
    };
  }

  static Future<LeagueTeamParticipation> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async =>
      LeagueTeamParticipation(
        id: e['id'] as int?,
        league: (await getSingle<League>(e['league_id'] as int))!,
        team: (await getSingle<Team>(e['team_id'] as int))!,
      );
}
