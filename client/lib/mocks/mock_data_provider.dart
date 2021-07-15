import 'package:common/common.dart';
import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/data/lineup.dart';
import 'package:wrestling_scoreboard/data/membership.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

import 'mocks.dart';

class MockDataProvider<T extends DataObject> extends DataProvider {
  @override
  Future<T> fetchSingle<T extends DataObject>(int id, {DataObject? filterObject}) async {
    final List<T> many = await fetchMany<T>(filterObject: filterObject);
    return many.singleWhere((element) => element.id == id);
  }

  @override
  Future<List<T>> fetchMany<T extends DataObject>({DataObject? filterObject}) {
    return Future.value(getManyMocksFromClass<T>(filterObject: filterObject));
  }

  List<T> getManyMocksFromClass<T>({DataObject? filterObject}) {
    switch (T) {
      case ClientClub:
        if (filterObject != null) throw DataUnimplementedError(T, filterObject);
        return getClubs() as List<T>;
      case ClientFight:
        throw DataUnimplementedError(T, filterObject);
      case ClientLeague:
        if (filterObject != null) throw DataUnimplementedError(T, filterObject);
        return getLeagues() as List<T>;
      case ClientLineup:
        if (filterObject != null) throw DataUnimplementedError(T, filterObject);
        return getLineups() as List<T>;
      case ClientMembership:
        if (filterObject != null) throw DataUnimplementedError(T, filterObject);
        return getMemberships() as List<T>;
      case Participation:
        if (filterObject.runtimeType == ClientLineup)
          return getParticipationsOfLineup(filterObject as ClientLineup) as List<T>;
        if (filterObject != null) throw DataUnimplementedError(T, filterObject);
        return getParticipations() as List<T>;
      case ClientTeam:
        if (filterObject.runtimeType == ClientClub) return getTeamsOfClub(filterObject as ClientClub) as List<T>;
        if (filterObject.runtimeType == ClientLeague) return getTeamsOfLeague(filterObject as ClientLeague) as List<T>;
        if (filterObject != null) throw DataUnimplementedError(T, filterObject);
        return getTeams() as List<T>;
      case ClientTeamMatch:
        if (filterObject.runtimeType == ClientTeam) return getMatchesOfTeam(filterObject as ClientTeam) as List<T>;
        if (filterObject != null) throw DataUnimplementedError(T, filterObject);
        return getTeamMatches() as List<T>;
      default:
        throw DataUnimplementedError(T, filterObject);
    }
  }
}
