import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition_team_participation.freezed.dart';
part 'competition_team_participation.g.dart';

/// Team participates in a competition.
@freezed
abstract class CompetitionTeamParticipation with _$CompetitionTeamParticipation implements DataObject {
  const CompetitionTeamParticipation._();

  const factory CompetitionTeamParticipation({
    int? id,
    required Competition competition,
    required Team team,
  }) = _CompetitionTeamParticipation;

  factory CompetitionTeamParticipation.fromJson(Map<String, Object?> json) =>
      _$CompetitionTeamParticipationFromJson(json);

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'competition_id': competition.id!,
      'team_id': team.id!,
    };
  }

  static Future<CompetitionTeamParticipation> fromRaw(
          Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async =>
      CompetitionTeamParticipation(
        id: e['id'] as int?,
        competition: (await getSingle<Competition>(e['competition_id'] as int)),
        team: (await getSingle<Team>(e['team_id'] as int)),
      );

  @override
  String get tableName => 'competition_team_participation';

  @override
  CompetitionTeamParticipation copyWithId(int? id) {
    return copyWith(id: id);
  }
}
