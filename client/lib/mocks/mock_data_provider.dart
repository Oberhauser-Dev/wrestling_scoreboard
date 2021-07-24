import 'dart:math';

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
        if (filterObject != null) throw DataUnimplementedError(CRUD.read, T, filterObject);
        return getClubs() as List<T>;
      case ClientFight:
        if (filterObject is Tournament) return getFightsOfTournament(filterObject) as List<T>;
        if (filterObject is ClientTeamMatch) return getFightsOfTeamMatch(filterObject) as List<T>;
        if (filterObject != null) throw DataUnimplementedError(CRUD.read, T, filterObject);
        return getFights() as List<T>;
      case ClientLeague:
        if (filterObject != null) throw DataUnimplementedError(CRUD.read, T, filterObject);
        return getLeagues() as List<T>;
      case ClientLineup:
        if (filterObject != null) throw DataUnimplementedError(CRUD.read, T, filterObject);
        return getLineups() as List<T>;
      case ClientMembership:
        if (filterObject is ClientClub) return getMembershipsOfClub(filterObject) as List<T>;
        if (filterObject != null) throw DataUnimplementedError(CRUD.read, T, filterObject);
        return getMemberships() as List<T>;
      case Participation:
        if (filterObject is ClientLineup) return getParticipationsOfLineup(filterObject) as List<T>;
        if (filterObject != null) throw DataUnimplementedError(CRUD.read, T, filterObject);
        return getParticipations() as List<T>;
      case ClientTeam:
        if (filterObject is ClientClub) return getTeamsOfClub(filterObject) as List<T>;
        if (filterObject is ClientLeague) return getTeamsOfLeague(filterObject) as List<T>;
        if (filterObject != null) throw DataUnimplementedError(CRUD.read, T, filterObject);
        return getTeams() as List<T>;
      case ClientTeamMatch:
        if (filterObject is ClientTeam) return getMatchesOfTeam(filterObject) as List<T>;
        if (filterObject != null) throw DataUnimplementedError(CRUD.read, T, filterObject);
        return getTeamMatches() as List<T>;
      default:
        throw DataUnimplementedError(CRUD.read, T, filterObject);
    }
  }

  @override
  Future<void> generateFights(WrestlingEvent wrestlingEvent, [bool reset = false]) async {
    final fightsAll = getFights();
    if (reset) {
      if (wrestlingEvent is TeamMatch) {
        final teamMatchFightsAll = getTeamMatchFights();
        wrestlingEvent.fights.forEach((element) {
          teamMatchFightsAll.removeWhere((tmf) => tmf.fight.equalDuringFight(element));
        });
      } else if (wrestlingEvent is Tournament) {
        final tournamentFightsAll = getTournamentFights();
        wrestlingEvent.fights.forEach((element) {
          tournamentFightsAll.removeWhere((tof) => tof.fight.equalDuringFight(element));
        });
      }

      // Remove if exists
      wrestlingEvent.fights.forEach((element) {
        fightsAll.remove(element);
      });
    }
    // Generate new fights
    await wrestlingEvent.generateFights();
    // Add if not exists
    wrestlingEvent.fights.forEach((element) {
      if (!fightsAll.contains(element)) {
        fightsAll.add(ClientFight.from(element));
      }
    });
    if (wrestlingEvent is TeamMatch) {
      final teamMatchFightsAll = getTeamMatchFights();
      wrestlingEvent.fights.forEach((element) {
        if (teamMatchFightsAll.where((tmf) => tmf.fight.equalDuringFight(element)).isEmpty) {
          teamMatchFightsAll.add(TeamMatchFight(teamMatch: wrestlingEvent, fight: element));
        }
      });
    } else if (wrestlingEvent is Tournament) {
      final tournamentFightsAll = getTournamentFights();
      wrestlingEvent.fights.forEach((element) {
        if (tournamentFightsAll.where((tof) => tof.fight.equalDuringFight(element)).isEmpty) {
          tournamentFightsAll.add(TournamentFight(tournament: wrestlingEvent, fight: element));
        }
      });
    }
  }

  @override
  Future<int> createOrUpdateSingle(DataObject obj) async {
    if (obj.id == null) {
      return Future.value(_createMockSingle(obj).id);
    } else {
      return Future.value(_updateMockSingle(obj).id);
    }
  }

  DataObject _createMockSingle(DataObject obj) {
    obj.id = Random().nextInt(32000);
    if (obj is Participation) {
      getParticipations().add(obj);
    } else if (obj is Lineup) {
      getLineups().add(ClientLineup.from(obj));
    } else {
      throw DataUnimplementedError(CRUD.create, obj.runtimeType);
    }
    return obj;
  }

  DataObject _updateMockSingle(DataObject obj) {
    if (obj is Participation) {
      getParticipations().remove(obj);
      getParticipations().add(obj);
    } else if (obj is Lineup) {
      final clientObj = ClientLineup.from(obj);
      getLineups().remove(clientObj);
      getLineups().add(clientObj);
      getParticipations().where((element) => element.lineup == clientObj).forEach((element) {
        element.lineup = clientObj;
      });
    } else {
      throw DataUnimplementedError(CRUD.create, obj.runtimeType);
    }
    return obj;
  }

  @override
  Future<void> deleteSingle(DataObject obj) async {
    if (obj is Participation) {
      getParticipations().remove(obj);
    } else if (obj is Lineup) {
      getLineups().remove(obj);
    } else {
      throw DataUnimplementedError(CRUD.delete, obj.runtimeType);
    }
  }
}
