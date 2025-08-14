import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'team_lineup.freezed.dart';
part 'team_lineup.g.dart';

/// The lineup for a team match or competition.
@freezed
abstract class TeamLineup with _$TeamLineup implements DataObject {
  const TeamLineup._();

  const factory TeamLineup({
    int? id,
    required Team team,
    Membership? leader, // Mannschaftsführer
    Membership? coach, // Trainer
  }) = _TeamLineup;

  factory TeamLineup.fromJson(Map<String, Object?> json) => _$TeamLineupFromJson(json);

  static Future<TeamLineup> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final leaderId = e['leader_id'] as int?;
    final coachId = e['coach_id'] as int?;
    return TeamLineup(
      id: e['id'] as int?,
      team: await getSingle<Team>(e['team_id'] as int),
      leader: leaderId == null ? null : await getSingle<Membership>(leaderId),
      coach: coachId == null ? null : await getSingle<Membership>(coachId),
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {if (id != null) 'id': id, 'team_id': team.id!, 'leader_id': leader?.id!, 'coach_id': coach?.id!};
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'team_lineup';

  @override
  TeamLineup copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Set<String> searchableAttributes = {};

  static Map<String, Type> searchableForeignAttributeMapping = {'team_id': Team};
}
