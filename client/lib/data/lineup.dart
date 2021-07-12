import 'package:common/common.dart';

import 'participant_state.dart';
import 'team.dart';

class ClientLineup extends Lineup {
  ClientLineup(
      {required ClientTeam team,
      Person? leader,
      Person? coach,
      int tier = 1})
      : super(team: team, leader: leader, coach: coach, tier: tier);

  ClientLineup.from(Lineup obj)
      : this(
            team: ClientTeam.from(obj.team),
            leader: obj.leader,
            coach: obj.coach,
            tier: obj.tier);

  factory ClientLineup.fromJson(Map<String, dynamic> json) => ClientLineup.from(Lineup.fromJson(json));
}
