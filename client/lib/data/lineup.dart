import 'package:common/common.dart';

import 'participant_status.dart';
import 'team.dart';

class ClientLineup extends Lineup {
  ClientLineup(
      {required ClientTeam team,
      required List<ClientParticipantStatus> participantStatusList,
      Person? leader,
      Person? coach,
      int tier = 1})
      : super(team: team, participantStatusList: participantStatusList, leader: leader, coach: coach, tier: tier);

  ClientLineup.from(Lineup obj)
      : this(
            team: ClientTeam.from(obj.team),
            participantStatusList: obj.participantStatusList.map((e) => ClientParticipantStatus.from(e)).toList(),
            leader: obj.leader,
            coach: obj.coach,
            tier: obj.tier);

  factory ClientLineup.fromJson(Map<String, dynamic> json) => ClientLineup.from(Lineup.fromJson(json));
}
