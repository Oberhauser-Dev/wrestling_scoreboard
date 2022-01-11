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

class MockDataProvider extends DataProvider {
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
  Stream<T> streamSingle<T extends DataObject>(Type t, int id) {
    return (getOrCreateSingleStreamController<T>(t).stream).where((event) => event.id == id);
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
        for (var element in wrestlingEvent.fights) {
          teamMatchFightsAll.removeWhere((tmf) => tmf.fight.equalDuringFight(element));
        }
      } else if (wrestlingEvent is Tournament) {
        final tournamentFightsAll = getTournamentFights();
        for (var element in wrestlingEvent.fights) {
          tournamentFightsAll.removeWhere((tof) => tof.fight.equalDuringFight(element));
        }
      }

      // Remove if exists
      for (var element in wrestlingEvent.fights) {
        fightsAll.remove(element);
      }
    }
    // Generate new fights
    await wrestlingEvent.generateFights();
    // Add if not exists
    final random = Random();
    for (final element in wrestlingEvent.fights) {
      if (fightsAll.where((ClientFight f) => f.equalDuringFight(element)).isEmpty) {
        do { // Generate new id as long it is not taken yet
          element.id = random.nextInt(0x7fffffff);
        } while (fightsAll.where((f) => f.id == element.id).isNotEmpty);
        fightsAll.add(ClientFight.from(element));
      }
    }
    if (wrestlingEvent is TeamMatch) {
      final teamMatchFightsAll = getTeamMatchFights();
      for (final element in wrestlingEvent.fights) {
        if (teamMatchFightsAll.where((tmf) => tmf.fight.equalDuringFight(element)).isEmpty) {
          teamMatchFightsAll.removeWhere((tmf) => tmf.fight.weightClass == element.weightClass);
          int generatedId;
          do { // Generate new id as long it is not taken yet
            generatedId = random.nextInt(0x7fffffff);
          } while (teamMatchFightsAll.where((t) => t.id == element.id).isNotEmpty);
          teamMatchFightsAll.add(TeamMatchFight(id: generatedId, teamMatch: wrestlingEvent, fight: element));
        }
      }
      updateMany(Fight, filterObject: wrestlingEvent);
    } else if (wrestlingEvent is Tournament) {
      final tournamentFightsAll = getTournamentFights();
      for (final element in wrestlingEvent.fights) {
        if (tournamentFightsAll.where((tof) => tof.fight.equalDuringFight(element)).isEmpty) {
          int generatedId;
          do { // Generate new id as long it is not taken yet
            generatedId = random.nextInt(0x7fffffff);
          } while (tournamentFightsAll.where((t) => t.id == element.id).isNotEmpty);
          tournamentFightsAll.add(TournamentFight(id: generatedId, tournament: wrestlingEvent, fight: element));
        }
      }
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
      final manyLineupFilter = ManyDataObject(
        data: getParticipationsOfLineup(obj.lineup),
        filterType: Lineup,
        filterId: obj.lineup.id,
      );
      getManyStreamController<Participation>(obj.runtimeType, filterType: Lineup)?.add(manyLineupFilter);
    } else if (obj is Lineup) {
      // No filtered list needs to be handled.
    } else {
      throw DataUnimplementedError(operation, obj.runtimeType);
    }
  }

  Future<void> updateMany(Type t, {DataObject? filterObject}) async {
    // Currently do not update list of all entities (as is and should not used anywhere)
    switch (t) {
      case Fight:
        if (filterObject is ClientTeamMatch) {
          final manyFilter = ManyDataObject(
            data: getFightsOfTeamMatch(filterObject),
            filterType: TeamMatch,
            filterId: filterObject.id,
          );
          return getManyStreamController<Fight>(t, filterType: TeamMatch)?.add(manyFilter);
        }
        throw DataUnimplementedError(CRUD.update, t, filterObject);
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
      getSingleStreamController<Participation>(obj.runtimeType)?.add(obj);
    } else if (obj is ClientLineup) {
      getLineups().remove(obj);
      getLineups().add(obj);
      getParticipations().where((element) => element.lineup == obj).forEach((element) {
        element.lineup = obj;
      });
      getSingleStreamController<Lineup>(obj.runtimeType)?.add(obj);
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
