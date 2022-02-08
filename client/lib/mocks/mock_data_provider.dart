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
    if (filterObject != null) {
      switch (T) {
        case Fight:
          if (filterObject is Tournament) return getFightsOfTournament(filterObject).cast<T>();
          if (filterObject is TeamMatch) return getFightsOfTeamMatch(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case Membership:
          if (filterObject is Club) return getMembershipsOfClub(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case Participation:
          if (filterObject is Lineup) return getParticipationsOfLineup(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case Team:
          if (filterObject is Club) return getTeamsOfClub(filterObject).cast<T>();
          if (filterObject is League) return getTeamsOfLeague(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case TeamMatch:
          if (filterObject is Team) return getTeamMatchesOfTeam(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case WeightClass:
          // TODO may remove in favor of getLeagueWeightClassesOfLeague
          if (filterObject is League) return getWeightClassesOfLeague(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case LeagueWeightClass:
          if (filterObject is League) return getLeagueWeightClassesOfLeague(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case TeamMatchFight:
          if (filterObject is TeamMatch) return getTeamMatchFightsOfTeamMatch(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        default:
          throw DataUnimplementedError(CRUD.read, T, filterObject);
      }
    }
    return _getListOfType<T>(CRUD.read);
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
    _updateMany(Fight, filterObject: wrestlingEvent);
  }

  @override
  Future<int> createOrUpdateSingle(DataObject single) async {
    final operation = single.id == null ? CRUD.create : CRUD.update;
    single = operation == CRUD.create ? _createMockSingle(single) : _updateMockSingle(single);
    _broadcastSingle(single);
    return single.id!;
  }

  Future<void> _updateMany(Type t, {DataObject? filterObject}) async {
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

  DataObject _createMockSingle(DataObject single) {
    single.id = Random().nextInt(32000);
    _getListOfObject(single, CRUD.create).add(single);
    return single;
  }

  DataObject _updateMockSingle(DataObject single) {
    final objList = _getListOfObject(single, CRUD.update);
    objList.remove(single);
    objList.add(single);
    if (single is Lineup) {
      getParticipations().where((element) => element.lineup == single).forEach((element) {
        element.lineup = single;
      });
    }
    _getSingleStreamControllerOfObject(single, CRUD.update).add(single);
    return single;
  }

  @override
  Future<void> deleteSingle(DataObject single) async {
    _getListOfObject(single, CRUD.delete).remove(single);
    _broadcastSingle(single);
  }

  // Currently do not update list of all entities (as it should only be used in special cases)
  // Update doesn't need to update filtered lists, as it should already be listened to the object itself, which gets an update event
  void _broadcastSingle<T extends DataObject>(T single) async {
    if (single is Club) {
      // SpecialCase: the full Club list has to be updated, shouldn't occur often
      getManyStreamController<Club>()?.add(ManyDataObject(data: getClubs()));
    } else if (single is Fight) {
    } else if (single is FightAction) {
      getManyStreamController<FightAction>(filterType: Fight)?.add(ManyDataObject(
        data: getFightActionsOfFight(single.fight),
        filterType: Fight,
        filterId: single.fight.id,
      ));
    } else if (single is League) {
      getManyStreamController<League>()?.add(ManyDataObject(data: getLeagues()));
    } else if (single is LeagueWeightClass) {
      getManyStreamController<LeagueWeightClass>(filterType: League)?.add(ManyDataObject(
        data: getLeagueWeightClassesOfLeague(single.league),
        filterType: League,
        filterId: single.league.id,
      ));
    } else if (single is Lineup) {
      // No filtered list needs to be handled.
    } else if (single is Membership) {
      getManyStreamController<Membership>(filterType: Club)?.add(ManyDataObject(
        data: getMembershipsOfClub(single.club),
        filterType: Club,
        filterId: single.club.id,
      ));
    } else if (single is Participation) {
      getManyStreamController<Participation>(filterType: Lineup)?.add(ManyDataObject(
        data: getParticipationsOfLineup(single.lineup),
        filterType: Lineup,
        filterId: single.lineup.id,
      ));
    } else if (single is ParticipantState) {
    } else if (single is Person) {
    } else if (single is Team) {
      getManyStreamController<Team>(filterType: Club)?.add(ManyDataObject(
        data: getTeamsOfClub(single.club),
        filterType: Club,
        filterId: single.club.id,
      ));
      if (single.league != null) {
        getManyStreamController<Team>(filterType: League)?.add(ManyDataObject(
          data: getTeamsOfLeague(single.league!),
          filterType: League,
          filterId: single.league!.id,
        ));
      }
    } else if (single is TeamMatch) {
      getManyStreamController<TeamMatch>(filterType: Team)?.add(ManyDataObject(
        data: getTeamMatchesOfTeam(single.home.team),
        filterType: Team,
        filterId: single.home.id,
      ));
      getManyStreamController<TeamMatch>(filterType: Team)?.add(ManyDataObject(
        data: getTeamMatchesOfTeam(single.guest.team),
        filterType: Team,
        filterId: single.guest.id,
      ));
    } else {
      throw DataUnimplementedError(CRUD.update, single.runtimeType);
    }
  }

  List<T> _getListOfObject<T extends DataObject>(T obj, CRUD crud) {
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

  List<T> _getListOfType<T extends DataObject>(CRUD crud) {
    switch (T) {
      case Club:
        return getClubs().cast<T>();
      case Fight:
        return getFights().cast<T>();
      case FightAction:
        return getFightActions().cast<T>();
      case League:
        return getLeagues().cast<T>();
      case LeagueWeightClass:
        return getLeagueWeightClasses().cast<T>();
      case Lineup:
        return getLineups().cast<T>();
      case Membership:
        return getMemberships().cast<T>();
      case Participation:
        return getParticipations().cast<T>();
      case ParticipantState:
        return getParticipantStates().cast<T>();
      case Person:
        return getPersons().cast<T>();
      case Team:
        return getTeams().cast<T>();
      case TeamMatch:
        return getTeamMatches().cast<T>();
      case TeamMatchFight:
        return getTeamMatchFights().cast<T>();
      case WeightClass:
        return getWeightClasses().cast<T>();
      default:
        throw DataUnimplementedError(crud, T);
    }
  }

  StreamController<T> _getSingleStreamControllerOfObject<T extends DataObject>(T obj, CRUD crud) {
    if (obj is Club) {
      return getSingleStreamController<Club>() as StreamController<T>;
    } else if (obj is Fight) {
      return getSingleStreamController<Fight>() as StreamController<T>;
    } else if (obj is FightAction) {
      return getSingleStreamController<FightAction>() as StreamController<T>;
    } else if (obj is League) {
      return getSingleStreamController<League>() as StreamController<T>;
    } else if (obj is LeagueWeightClass) {
      return getSingleStreamController<LeagueWeightClass>() as StreamController<T>;
    } else if (obj is Lineup) {
      return getSingleStreamController<Lineup>() as StreamController<T>;
    } else if (obj is Membership) {
      return getSingleStreamController<Membership>() as StreamController<T>;
    } else if (obj is Participation) {
      return getSingleStreamController<Participation>() as StreamController<T>;
    } else if (obj is ParticipantState) {
      return getSingleStreamController<ParticipantState>() as StreamController<T>;
    } else if (obj is Person) {
      return getSingleStreamController<Person>() as StreamController<T>;
    } else if (obj is Team) {
      return getSingleStreamController<Team>() as StreamController<T>;
    } else if (obj is TeamMatch) {
      return getSingleStreamController<TeamMatch>() as StreamController<T>;
    } else if (obj is TeamMatchFight) {
      return getSingleStreamController<TeamMatchFight>() as StreamController<T>;
    } else if (obj is WeightClass) {
      return getSingleStreamController<WeightClass>() as StreamController<T>;
    } else {
      throw DataUnimplementedError(crud, obj.runtimeType);
    }
  }
}
