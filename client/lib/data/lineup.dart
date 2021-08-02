import 'package:common/common.dart';

import 'team.dart';

class ClientLineup extends Lineup {
  ClientLineup({int? id, required ClientTeam team, Membership? leader, Membership? coach, int tier = 1})
      : super(id: id, team: team, leader: leader, coach: coach, tier: tier);

  ClientLineup.from(Lineup obj)
      : this(id: obj.id, team: ClientTeam.from(obj.team), leader: obj.leader, coach: obj.coach, tier: obj.tier);

  ClientTeam get team => super.team as ClientTeam;

  factory ClientLineup.fromJson(Map<String, dynamic> json) => ClientLineup.from(Lineup.fromJson(json));
}
