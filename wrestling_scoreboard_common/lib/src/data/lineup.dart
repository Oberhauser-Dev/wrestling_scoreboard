import 'package:freezed_annotation/freezed_annotation.dart';

import 'data_object.dart';
import 'membership.dart';
import 'team.dart';

part 'lineup.freezed.dart';
part 'lineup.g.dart';

/// The lineup for a team match or competition.
@freezed
class Lineup with _$Lineup implements DataObject {
  const Lineup._();

  const factory Lineup({
    int? id,
    required Team team,
    Membership? leader, // Mannschaftsführer
    Membership? coach, // Trainer
  }) = _Lineup;

  factory Lineup.fromJson(Map<String, Object?> json) => _$LineupFromJson(json);

  static Future<Lineup> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final id = e['id'] as int?;
    final team = await getSingle<Team>(e['team_id'] as int);
    final leaderId = e['leader_id'] as int?;
    final leader = leaderId == null ? null : await getSingle<Membership>(leaderId);
    final coachId = e['coach_id'] as int?;
    final coach = coachId == null ? null : await getSingle<Membership>(coachId);
    return Lineup(id: id, team: team!, leader: leader, coach: coach);
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'team_id': team.id,
      'leader_id': leader?.id,
      'coach_id': coach?.id,
    };
  }

  @override
  String get tableName => 'lineup';

  @override
  Lineup copyWithId(int? id) {
    return copyWith(id: id);
  }
}
