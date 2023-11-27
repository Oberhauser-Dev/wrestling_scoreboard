import 'package:freezed_annotation/freezed_annotation.dart';

import '../data_object.dart';
import '../team.dart';
import 'tournament.dart';

part 'tournament_team_participation.freezed.dart';
part 'tournament_team_participation.g.dart';

/// Team participates in a tournament.
@freezed
class TournamentTeamParticipation with _$TournamentTeamParticipation implements DataObject {
  const TournamentTeamParticipation._();

  const factory TournamentTeamParticipation({
    int? id,
    required Tournament tournament,
    required Team team,
  }) = _TournamentTeamParticipation;

  factory TournamentTeamParticipation.fromJson(Map<String, Object?> json) =>
      _$TournamentTeamParticipationFromJson(json);

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

  @override
  String get tableName => 'tournament_team_participation';
}
