import 'package:common/common.dart';
import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/data/lineup.dart';
import 'package:wrestling_scoreboard/data/membership.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';

// String serialize<T>(T obj) {
//   switch (T) {
//     case Club:
//       return Club.fromJson(json) as T;
//     default:
//       throw UnimplementedError('Cannot deserialize ${T.toString()}');
//   }
// }

T deserialize<T>(Map<String, dynamic> json) {
  switch (T) {
    case ClientClub:
      return ClientClub.fromJson(json) as T;
    case ClientFight:
      return ClientFight.fromJson(json) as T;
    case ClientLeague:
      return ClientLeague.fromJson(json) as T;
    case ClientLineup:
      return ClientLineup.fromJson(json) as T;
    case ClientMembership:
      return ClientMembership.fromJson(json) as T;
    case Participation:
      return Participation.fromJson(json) as T;
    case ClientTeam:
      return ClientTeam.fromJson(json) as T;
    case ClientTeamMatch:
      return ClientTeamMatch.fromJson(json) as T;
    default:
      throw UnimplementedError('Cannot deserialize ${T.toString()}');
  }
}
