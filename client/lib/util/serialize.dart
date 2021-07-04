import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/data/team.dart';

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
    case ClientLeague:
      return ClientLeague.fromJson(json) as T;
    case ClientTeam:
      return ClientTeam.fromJson(json) as T;
    default:
      throw UnimplementedError('Cannot deserialize ${T.toString()}');
  }
}
