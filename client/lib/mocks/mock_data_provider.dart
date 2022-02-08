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
        if (filterObject is Team) return getTeamMatchesOfTeam(filterObject) as List<T>;
        if (filterObject != null) throw DataUnimplementedError(CRUD.read, T, filterObject);
        return getTeamMatches() as List<T>;
      case LeagueWeightClass:
      case TeamMatchFight:
      case Person:
        // TODO
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
    List<WeightClass> weightClasses;
    if (wrestlingEvent is TeamMatch) {
      final homeParticipations = await dataProvider.readMany<Participation>(filterObject: wrestlingEvent.home);
      final guestParticipations = await dataProvider.readMany<Participation>(filterObject: wrestlingEvent.guest);
      teamParticipations = [homeParticipations, guestParticipations];
      weightClasses = await dataProvider.readMany<WeightClass>(filterObject: wrestlingEvent.home.team.league);
    } else if (wrestlingEvent is Tournament) {
      // TODO get all participations
      teamParticipations = [];
      weightClasses = [];
      // throw UnimplementedError('generate fights for tournaments not yet implemented');
    } else {
      teamParticipations = [];
      weightClasses = [];
      throw UnimplementedError('generate fights for tournaments not yet implemented');
    }

    // Generate new fights
    final newFights = await wrestlingEvent.generateFights(teamParticipations, weightClasses);
    // TODO add notifier to all fights

    // Add if not exists
    final random = Random();
    for (final element in newFights) {
      if (fightsAll.where((Fight f) => f.equalDuringFight(element)).isEmpty) {
        do {
          // Generate new id as long it is not taken yet
          element.id = random.nextInt(0x7fffffff);
        } while (fightsAll.where((f) => f.id == element.id).isNotEmpty);
        fightsAll.add(element);
      }
    }
    if (wrestlingEvent is TeamMatch) {
      final teamMatchFightsAll = getTeamMatchFights();
      newFights.asMap().forEach((key, element) {
        if (teamMatchFightsAll.where((tmf) => tmf.fight.equalDuringFight(element)).isEmpty) {
          teamMatchFightsAll.removeWhere((tmf) => tmf.fight.weightClass == element.weightClass);
          int generatedId;
          do {
            // Generate new id as long it is not taken yet
            generatedId = random.nextInt(0x7fffffff);
          } while (teamMatchFightsAll.where((t) => t.id == element.id).isNotEmpty);
          teamMatchFightsAll.add(TeamMatchFight(id: generatedId, teamMatch: wrestlingEvent, fight: element, pos: key));
        }
      });
    } else if (wrestlingEvent is Tournament) {
      final tournamentFightsAll = getTournamentFights();
      for (final element in newFights) {
        if (tournamentFightsAll.where((tof) => tof.fight.equalDuringFight(element)).isEmpty) {
          int generatedId;
          do {
            // Generate new id as long it is not taken yet
            generatedId = random.nextInt(0x7fffffff);
          } while (tournamentFightsAll.where((t) => t.id == element.id).isNotEmpty);
          tournamentFightsAll.add(TournamentFight(id: generatedId, tournament: wrestlingEvent, fight: element));
        }
      }
    }
    getFights().addAll(newFights);
    updateMany(Fight, filterObject: wrestlingEvent);
  }

  @override
  Future<int> createOrUpdateSingle(DataObject obj) async {
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
      final operation = obj.id == null ? CRUD.create : CRUD.update;
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
    getListOfType(obj, CRUD.create).add(obj);
    return obj;
  }

  DataObject _updateMockSingle(DataObject obj) {
    final objList = getListOfType(obj, CRUD.update);
    objList.remove(obj);
    objList.add(obj);
    if (obj is Participation) {
      getSingleStreamController<Participation>()?.add(obj);
    } else if (obj is Lineup) {
      getParticipations().where((element) => element.lineup == obj).forEach((element) {
        element.lineup = obj;
      });
      getSingleStreamController<Lineup>()?.add(obj);
    }
    return obj;
  }

  @override
  Future<void> deleteSingle(DataObject obj) async {
    getListOfType(obj, CRUD.delete).remove(obj);
  }
  
  List<T> getListOfType<T extends DataObject>(T obj, CRUD crud) {
    if (obj is Club) {
      return getClubs().cast<T>();
    } else if (obj is Fight) {
      return getFights().cast<T>();
    } else if (obj is FightAction) {
      return getFightActions().cast<T>();
    } else if (obj is League) {
      return getLeagues().cast<T>();
    } else if (obj is LeagueWeightClass) {
      return getLeagueWeightClasses().cast<T>();
    } else if (obj is Lineup) {
      return getLineups().cast<T>();
    } else if (obj is Membership) {
      return getMemberships().cast<T>();
    } else if (obj is Participation) {
      return getParticipations().cast<T>();
    } else if (obj is ParticipantState) {
      return getParticipantStates().cast<T>();
    } else if (obj is Person) {
      return getPersons().cast<T>();
    } else if (obj is Team) {
      return getTeams().cast<T>();
    } else if (obj is TeamMatch) {
      return getTeamMatches().cast<T>();
    } else if (obj is TeamMatchFight) {
      return getTeamMatchFights().cast<T>();
    } else if (obj is WeightClass) {
      return getWeightClasses().cast<T>();
    } else {
      throw DataUnimplementedError(crud, obj.runtimeType);
    }
  }
}
