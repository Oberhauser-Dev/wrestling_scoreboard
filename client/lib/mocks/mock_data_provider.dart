import 'dart:async';
import 'dart:math';

import 'package:common/common.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

import 'mocks.dart';

class MockDataProvider extends DataProvider {

  final latency = const Duration(milliseconds: 100);

  @override
  Future<T> readSingle<T extends DataObject>(int id) async {
    final Iterable<T> many = await readMany<T>();
    return many.singleWhere((element) => element.id == id);
  }

  @override
  Future<List<T>> readMany<T extends DataObject>({DataObject? filterObject}) async {
    await Future.delayed(latency);
    return Future.value(getManyMocksFromClass<T>(filterObject: filterObject));
  }

  @override
  Future<Map<String, dynamic>> readSingleJson<T extends DataObject>(int id) async {
    throw UnimplementedError('Raw types are not supported in Mock mode');
    // final Iterable<Map<String, dynamic>> many = await readRawMany<T>();
    // return many.singleWhere((element) => element['id'] == id);
  }

  @override
  Future<Iterable<Map<String, dynamic>>> readManyJson<T extends DataObject>({DataObject? filterObject}) async {
    throw UnimplementedError('Raw types are not supported in Mock mode');
    // return Future.value(getManyMocksFromClass<T>(filterObject: filterObject).map((e) => e.toJson()));
  }

  List<T> getManyMocksFromClass<T extends DataObject>({DataObject? filterObject}) {
    switch (T) {
      case Club:
        if (filterObject != null) throw DataUnimplementedError(CRUD.read, T, filterObject);
        return getClubs() as List<T>;
      case Fight:
        if (filterObject is Tournament) return getFightsOfTournament(filterObject) as List<T>;
        if (filterObject is TeamMatch) return getFightsOfTeamMatch(filterObject) as List<T>;
        if (filterObject != null) throw DataUnimplementedError(CRUD.read, T, filterObject);
        return getFights() as List<T>;
      case League:
        if (filterObject != null) throw DataUnimplementedError(CRUD.read, T, filterObject);
        return getLeagues() as List<T>;
      case Lineup:
        if (filterObject != null) throw DataUnimplementedError(CRUD.read, T, filterObject);
        return getLineups() as List<T>;
      case Membership:
        if (filterObject is Club) return getMembershipsOfClub(filterObject) as List<T>;
        if (filterObject != null) throw DataUnimplementedError(CRUD.read, T, filterObject);
        return getMemberships() as List<T>;
      case Participation:
        if (filterObject is Lineup) return getParticipationsOfLineup(filterObject) as List<T>;
        if (filterObject != null) throw DataUnimplementedError(CRUD.read, T, filterObject);
        return getParticipations() as List<T>;
      case Team:
        if (filterObject is Club) return getTeamsOfClub(filterObject) as List<T>;
        if (filterObject is League) return getTeamsOfLeague(filterObject) as List<T>;
        if (filterObject != null) throw DataUnimplementedError(CRUD.read, T, filterObject);
        return getTeams() as List<T>;
      case TeamMatch:
        if (filterObject is Team) return getMatchesOfTeam(filterObject) as List<T>;
        if (filterObject != null) throw DataUnimplementedError(CRUD.read, T, filterObject);
        return getTeamMatches() as List<T>;
      default:
        throw DataUnimplementedError(CRUD.read, T, filterObject);
    }
  }

  @override
  Future<void> generateFights(WrestlingEvent wrestlingEvent, [bool reset = false]) async {
    List<Fight> oldFights; // TODO really needs old fights or just use the exising ones from teammatch
    if (wrestlingEvent is TeamMatch) {
      oldFights = getFightsOfTeamMatch(wrestlingEvent);
    } else {
      oldFights = getFightsOfTournament(wrestlingEvent as Tournament);
    }
    final fightsAll = getFights();
    if (reset) {
      if (wrestlingEvent is TeamMatch) {
        final teamMatchFightsAll = getTeamMatchFights();
        for (var element in oldFights) {
          teamMatchFightsAll.removeWhere((tmf) => tmf.fight.equalDuringFight(element));
        }
      } else if (wrestlingEvent is Tournament) {
        final tournamentFightsAll = getTournamentFights();
        for (var element in oldFights) {
          tournamentFightsAll.removeWhere((tof) => tof.fight.equalDuringFight(element));
        }
      }

      // Remove if exists
      for (var element in oldFights) {
        fightsAll.remove(element);
      }
    }

    List<List<Participation>> teamParticipations;
    if (wrestlingEvent is TeamMatch) {
      final homeParticipations = await dataProvider.readMany<Participation>(
          filterObject: wrestlingEvent.home);
      final guestParticipations = await dataProvider.readMany<Participation>(
          filterObject: wrestlingEvent.guest);
      teamParticipations = [homeParticipations, guestParticipations];
    } else if (wrestlingEvent is Tournament) {
      // TODO get all participations
      teamParticipations = [];
      // throw UnimplementedError('generate fights for tournaments not yet implemented');
    } else {
      teamParticipations = [];
      throw UnimplementedError('generate fights for tournaments not yet implemented');
    }

    // Generate new fights
    await wrestlingEvent.generateFights(teamParticipations);
    // TODO add notifier to all fights

    final newFights = wrestlingEvent.ex_fights;
    // Add if not exists
    final random = Random();
    for (final element in newFights) {
      if (fightsAll
          .where((Fight f) => f.equalDuringFight(element))
          .isEmpty) {
        do { // Generate new id as long it is not taken yet
          element.id = random.nextInt(0x7fffffff);
        } while (fightsAll
            .where((f) => f.id == element.id)
            .isNotEmpty);
        fightsAll.add(element);
      }
    }
    if (wrestlingEvent is TeamMatch) {
      final teamMatchFightsAll = getTeamMatchFights();
      newFights.asMap().forEach((key, element) {
        if (teamMatchFightsAll
            .where((tmf) => tmf.fight.equalDuringFight(element))
            .isEmpty) {
          teamMatchFightsAll.removeWhere((tmf) => tmf.fight.weightClass == element.weightClass);
          int generatedId;
          do { // Generate new id as long it is not taken yet
            generatedId = random.nextInt(0x7fffffff);
          } while (teamMatchFightsAll
              .where((t) => t.id == element.id)
              .isNotEmpty);
          teamMatchFightsAll.add(TeamMatchFight(id: generatedId, teamMatch: wrestlingEvent, fight: element, pos: key));
        }
      });
    } else if (wrestlingEvent is Tournament) {
      final tournamentFightsAll = getTournamentFights();
      for (final element in newFights) {
        if (tournamentFightsAll
            .where((tof) => tof.fight.equalDuringFight(element))
            .isEmpty) {
          int generatedId;
          do { // Generate new id as long it is not taken yet
            generatedId = random.nextInt(0x7fffffff);
          } while (tournamentFightsAll
              .where((t) => t.id == element.id)
              .isNotEmpty);
          tournamentFightsAll.add(TournamentFight(id: generatedId, tournament: wrestlingEvent, fight: element));
        }
      }
    }
    wrestlingEvent.ex_fights = newFights;
    updateMany(Fight, filterObject: wrestlingEvent);
  }

  @override
  Future<int> createOrUpdateSingle(DataObject obj) async {
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
      getManyStreamController<Participation>(filterType: Lineup)?.add(manyLineupFilter);
    } else if (obj is Lineup) {
      // No filtered list needs to be handled.
    } else {
      throw DataUnimplementedError(operation, obj.runtimeType);
    }
    return obj.id!;
  }

  Future<void> updateMany(Type t, {DataObject? filterObject}) async {
    // Currently do not update list of all entities (as is and should not used anywhere)
    switch (t) {
      case Fight:
        if (filterObject is TeamMatch) {
          final manyFilter = ManyDataObject(
            data: getFightsOfTeamMatch(filterObject),
            filterType: TeamMatch,
            filterId: filterObject.id,
          );
          return getManyStreamController<Fight>(filterType: TeamMatch)?.add(manyFilter);
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
    } else if (obj is Lineup) {
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
    } else if (obj is Lineup) {
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
