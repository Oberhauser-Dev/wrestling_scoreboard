import 'dart:async';
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
  Future<T> readSingle<T extends DataObject>(int id) async {
    final Iterable<T> many = await readMany<T>();
    return many.singleWhere((element) => element.id == id);
  }

  @override
  Future<Iterable<T>> readMany<T extends DataObject>({DataObject? filterObject}) {
    return Future.value(getManyMocksFromClass<T>(filterObject: filterObject));
  }

  @override
  Future<Map<String, dynamic>> readRawSingle<T extends DataObject>(int id) async {
    final Iterable<Map<String, dynamic>> many = await readRawMany<T>();
    return many.singleWhere((element) => element['id'] == id);
  }

  @override
  Future<Iterable<Map<String, dynamic>>> readRawMany<T extends DataObject>({DataObject? filterObject}) async {
    return Future.value(getManyMocksFromClass<T>(filterObject: filterObject).map((e) => e.toJson()));
  }

  @override
  Stream<T> readSingleStream<T extends DataObject>(int id) {
    return (getOrCreateSingleStreamController<T>().stream).where((event) => event.id == id);
  }

  @override
  Stream<Iterable<T>> readManyStream<T extends DataObject>({DataObject? filterObject}) {
    // TODO avoid dependencies and unify with remote service
    final filterType = filterObject == null ? Object : filterObject.getBaseType();
    var stream = getOrCreateManyStreamController<T>(filterType: filterType).stream;
    if (filterObject != null) {
      stream = stream.where((e) {
        if (e is List<Team>) {
          if (filterObject is Club)
            return (e as List<Team>).where((element) => element.club == filterObject).isNotEmpty;
        } else if (e is List<Fight>) {
          if (filterObject is TeamMatch)
            return getTeamMatchFights()
                .where((element) => element.teamMatch == filterObject && (e as List<Fight>).contains(element.fight))
                .isNotEmpty;
        } else if (e is List<Participation>) {
          if (filterObject is Lineup)
            return (e as List<Participation>).where((element) => element.lineup == filterObject).isNotEmpty;
        }
        throw DataUnimplementedError(CRUD.read, T, filterObject);
      });
    }
    return stream;
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
          teamMatchFightsAll.removeWhere((tmf) => tmf.fight.weightClass == element.weightClass);
          teamMatchFightsAll.add(TeamMatchFight(teamMatch: wrestlingEvent, fight: element));
        }
      });
      updateMany<Fight>(filterObject: wrestlingEvent);
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
  Future<void> createOrUpdateSingle(DataObject obj) async {
    final operation = obj.id == null ? CRUD.create : CRUD.update;
    if (obj.id == null) {
      obj = _createMockSingle(obj);
    } else {
      obj = _updateMockSingle(obj);
    }
    // Currently do not update list of all entities (as is and should not used anywhere)
    if (obj is Participation) {
      getManyStreamController<Participation>(filterType: Lineup)?.add(getParticipationsOfLineup(obj.lineup));
    } else if (obj is Lineup) {
      // No filtered list needs to be handled.
    } else {
      throw DataUnimplementedError(operation, obj.runtimeType);
    }
  }

  Future<void> updateMany<T extends DataObject>({DataObject? filterObject}) async {
    switch (T) {
      case Fight:
        if (filterObject is ClientTeamMatch)
          return getManyStreamController<Fight>(filterType: TeamMatch)?.add(getFightsOfTeamMatch(filterObject));
        if (filterObject != null) throw DataUnimplementedError(CRUD.update, T, filterObject);
        return getManyStreamController<Fight>()?.add(getFights());
      default:
        throw DataUnimplementedError(CRUD.update, filterObject.runtimeType);
    }
  }

  DataObject _createMockSingle(DataObject obj) {
    obj.id = Random().nextInt(32000);
    if (obj is Participation) {
      getParticipations().add(obj);
    } else if (obj is ClientLineup) {
      getLineups().add(obj);
    } else {
      throw DataUnimplementedError(CRUD.create, obj.runtimeType);
    }
    return obj;
  }

  DataObject _updateMockSingle(DataObject obj) {
    if (obj is Participation) {
      getParticipations().remove(obj);
      getParticipations().add(obj);
      getSingleStreamController<Participation>()?.add(obj);
    } else if (obj is ClientLineup) {
      getLineups().remove(obj);
      getLineups().add(obj);
      getParticipations().where((element) => element.lineup == obj).forEach((element) {
        element.lineup = obj;
      });
      getSingleStreamController<Lineup>()?.add(obj);
    } else {
      throw DataUnimplementedError(CRUD.update, obj.runtimeType);
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
