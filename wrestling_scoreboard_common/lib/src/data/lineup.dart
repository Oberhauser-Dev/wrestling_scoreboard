import 'package:json_annotation/json_annotation.dart';

import 'data_object.dart';
import 'membership.dart';
import 'team.dart';

part 'lineup.g.dart';

/// The lineup for a team match or tournament.
@JsonSerializable()
class Lineup extends DataObject {
  Team team;
  Membership? leader; // Mannschaftsführer
  Membership? coach; // Trainer

  Lineup({int? id, required this.team, this.leader, this.coach}) : super(id);

  factory Lineup.fromJson(Map<String, dynamic> json) => _$LineupFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LineupToJson(this);

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
}
