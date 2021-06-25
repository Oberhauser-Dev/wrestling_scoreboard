import 'package:common/common.dart';
import 'package:wrestling_scoreboard/data/league.dart';

import 'club.dart';

class ClientTeam extends Team {
  ClientTeam({required String name, required ClientClub club, String? description, ClientLeague? league})
      : super(name: name, club: club, description: description, league: league);

  ClientTeam.from(Team obj) : this(name: obj.name, club: ClientClub.from(obj.club), description: obj.description, league: obj.league == null ? null : ClientLeague.from(obj.league!));

  factory ClientTeam.fromJson(Map<String, dynamic> json) => ClientTeam.from(Team.fromJson(json));
}
