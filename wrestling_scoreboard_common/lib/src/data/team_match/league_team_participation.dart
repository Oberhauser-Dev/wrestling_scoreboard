import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'league_team_participation.freezed.dart';
part 'league_team_participation.g.dart';

/// Team participates in a league.
@freezed
class LeagueTeamParticipation with _$LeagueTeamParticipation implements DataObject {
  const LeagueTeamParticipation._();

  const factory LeagueTeamParticipation({
    int? id,
    required League league,
    required Team team,
  }) = _LeagueTeamParticipation;

  factory LeagueTeamParticipation.fromJson(Map<String, Object?> json) => _$LeagueTeamParticipationFromJson(json);

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
        league: (await getSingle<League>(e['league_id'] as int)),
        team: (await getSingle<Team>(e['team_id'] as int)),
      );

  @override
  String get tableName => 'league_team_participation';

  @override
  LeagueTeamParticipation copyWithId(int? id) {
    return copyWith(id: id);
  }

  @override
  String? get orgSyncId => throw UnimplementedError();

  @override
  Organization? get organization => throw UnimplementedError();
}
