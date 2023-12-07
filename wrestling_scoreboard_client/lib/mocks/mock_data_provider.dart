import 'dart:async';
import 'dart:math';

import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

import 'mocks.dart';

class MockDataProvider extends DataProvider {
  final latency = const Duration(milliseconds: 100);

  @override
  Future<T> readSingle<T extends DataObject>(int id) async {
    final Iterable<T> many = await readMany<T, Null>();
    return many.singleWhere((element) => element.id == id);
  }

  @override
  Future<List<T>> readMany<T extends DataObject, S extends DataObject?>({S? filterObject}) async {
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
  Future<Iterable<Map<String, dynamic>>> readManyJson<T extends DataObject, S extends DataObject?>(
      {S? filterObject}) async {
    throw UnimplementedError('Raw types are not supported in Mock mode');
    // return Future.value(getManyMocksFromClass<T>(filterObject: filterObject).map((e) => e.toJson()));
  }

  List<T> getManyMocksFromClass<T extends DataObject>({DataObject? filterObject}) {
    if (filterObject != null) {
      switch (T) {
        case const (Bout):
          if (filterObject is Competition) return getBoutsOfCompetition(filterObject).cast<T>();
          if (filterObject is TeamMatch) return getBoutsOfTeamMatch(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (Membership):
          if (filterObject is Club) return getMembershipsOfClub(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (Participation):
          if (filterObject is Lineup) return getParticipationsOfLineup(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (Team):
          if (filterObject is Club) return getTeamsOfClub(filterObject).cast<T>();
          if (filterObject is League) return getTeamsOfLeague(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (TeamMatch):
          if (filterObject is Team) return getTeamMatchesOfTeam(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (WeightClass):
          // TODO may remove in favor of getLeagueWeightClassesOfLeague
          if (filterObject is League) return getWeightClassesOfLeague(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (LeagueWeightClass):
          if (filterObject is League) return getLeagueWeightClassesOfLeague(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (LeagueTeamParticipation):
          if (filterObject is League) return getLeagueTeamParticipationsOfLeague(filterObject).cast<T>();
          if (filterObject is Team) return getLeagueTeamParticipationsOfTeam(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (TeamMatchBout):
          if (filterObject is TeamMatch) return getTeamMatchBoutsOfTeamMatch(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        default:
          throw DataUnimplementedError(CRUD.read, T, filterObject);
      }
    }
    return _getListOfType<T>(CRUD.read);
  }

  @override
  Future<void> generateBouts<T extends WrestlingEvent>(WrestlingEvent wrestlingEvent, [bool isReset = false]) async {
    List<Bout> oldBouts; // TODO really needs old bouts or just use the exising ones from teammatch
    if (wrestlingEvent is TeamMatch) {
      oldBouts = getBoutsOfTeamMatch(wrestlingEvent);
    } else {
      oldBouts = getBoutsOfCompetition(wrestlingEvent as Competition);
    }
    final boutsAll = getBouts();
    if (isReset) {
      if (wrestlingEvent is TeamMatch) {
        final teamMatchBoutsAll = getTeamMatchBouts();
        for (var element in oldBouts) {
          teamMatchBoutsAll.removeWhere((tmf) => tmf.bout.equalDuringBout(element));
        }
      } else if (wrestlingEvent is Competition) {
        final competitionBoutsAll = getCompetitionBouts();
        for (var element in oldBouts) {
          competitionBoutsAll.removeWhere((tof) => tof.bout.equalDuringBout(element));
        }
      }

      // Remove if exists
      for (var element in oldBouts) {
        boutsAll.remove(element);
      }
    }

    List<List<Participation>> teamParticipations;
    List<WeightClass> weightClasses;
    if (wrestlingEvent is TeamMatch) {
      final homeParticipations = await dataProvider.readMany<Participation, Lineup>(filterObject: wrestlingEvent.home);
      final guestParticipations =
          await dataProvider.readMany<Participation, Lineup>(filterObject: wrestlingEvent.guest);
      teamParticipations = [homeParticipations, guestParticipations];
      weightClasses = await dataProvider.readMany<WeightClass, League>(filterObject: wrestlingEvent.league);
    } else if (wrestlingEvent is Competition) {
      // TODO get all participations
      teamParticipations = [];
      weightClasses = [];
      // throw UnimplementedError('generate bouts for competitions not yet implemented');
    } else {
      teamParticipations = [];
      weightClasses = [];
      throw UnimplementedError('generate bouts for competitions not yet implemented');
    }

    // Generate new bouts
    final newBouts = await wrestlingEvent.generateBouts(teamParticipations, weightClasses);
    final newBoutsWithId = <Bout>[];

    // Add if not exists
    final random = Random();
    for (var element in newBouts) {
      if (boutsAll.where((Bout f) => f.equalDuringBout(element)).isEmpty) {
        do {
          // Generate new id as long it is not taken yet
          element = element.copyWithId(random.nextInt(0x7fffffff));
        } while (boutsAll.where((f) => f.id == element.id).isNotEmpty);
        boutsAll.add(element);
      }
      newBoutsWithId.add(element);
    }
    if (wrestlingEvent is TeamMatch) {
      final teamMatchBoutsAll = getTeamMatchBouts();
      newBoutsWithId.asMap().forEach((key, element) {
        if (teamMatchBoutsAll.where((tmf) => tmf.bout.equalDuringBout(element)).isEmpty) {
          teamMatchBoutsAll.removeWhere((tmf) => tmf.bout.weightClass == element.weightClass);
          int generatedId;
          do {
            // Generate new id as long it is not taken yet
            generatedId = random.nextInt(0x7fffffff);
          } while (teamMatchBoutsAll.where((t) => t.id == element.id).isNotEmpty);
          teamMatchBoutsAll.add(TeamMatchBout(id: generatedId, teamMatch: wrestlingEvent, bout: element, pos: key));
        }
      });
    } else if (wrestlingEvent is Competition) {
      final competitionBoutsAll = getCompetitionBouts();
      for (final element in newBoutsWithId) {
        if (competitionBoutsAll.where((tof) => tof.bout.equalDuringBout(element)).isEmpty) {
          int generatedId;
          do {
            // Generate new id as long it is not taken yet
            generatedId = random.nextInt(0x7fffffff);
          } while (competitionBoutsAll.where((t) => t.id == element.id).isNotEmpty);
          competitionBoutsAll.add(CompetitionBout(id: generatedId, competition: wrestlingEvent, bout: element));
        }
      }
    }
    getBouts().addAll(newBoutsWithId);
    _updateMany(Bout, filterObject: wrestlingEvent);
  }

  @override
  Future<int> createOrUpdateSingle<T extends DataObject>(T single) async {
    final operation = single.id == null ? CRUD.create : CRUD.update;
    single = operation == CRUD.create ? _createMockSingle<T>(single) : _updateMockSingle<T>(single);
    _broadcastSingle(single);
    return single.id!;
  }

  Future<void> _updateMany(Type t, {DataObject? filterObject}) async {
    switch (t) {
      case const (Bout):
        if (filterObject is TeamMatch) {
          final manyFilter = ManyDataObject(
            data: getBoutsOfTeamMatch(filterObject),
            filterType: TeamMatch,
            filterId: filterObject.id,
          );
          return getManyStreamController<Bout>(filterType: TeamMatch)?.add(manyFilter);
        }
        throw DataUnimplementedError(CRUD.update, t, filterObject);
      default:
        throw DataUnimplementedError(CRUD.update, filterObject.runtimeType);
    }
  }

  T _createMockSingle<T extends DataObject>(T single) {
    single = single.copyWithId(Random().nextInt(32000)) as T;
    _getListOfObject(single, CRUD.create).add(single);
    return single;
  }

  T _updateMockSingle<T extends DataObject>(T single) {
    final objList = _getListOfObject(single, CRUD.update);
    objList.remove(single);
    objList.add(single);
    if (single is Lineup) {
      final participations = getParticipations();
      final participationsWithLineup = participations.where((element) => element.lineup.id == single.id);
      for (final participationWithLineup in participationsWithLineup) {
        participations.remove(participationWithLineup);
        participations.add(participationWithLineup.copyWith(
          lineup: single,
        ));
      }
    }
    _getSingleStreamControllerOfObject(single, CRUD.update).add(single);
    return single;
  }

  @override
  Future<void> deleteSingle<T extends DataObject>(T single) async {
    _getListOfObject(single, CRUD.delete).remove(single);
    _broadcastSingle(single);
  }

  // Currently do not update list of all entities (as it should only be used in special cases)
  // Update doesn't need to update filtered lists, as it should already be listened to the object itself, which gets an update event
  void _broadcastSingle<T extends DataObject>(T single) async {
    if (single is Club) {
      // SpecialCase: the full Club list has to be updated, shouldn't occur often
      getManyStreamController<Club>()?.add(ManyDataObject(data: getClubs()));
    } else if (single is Bout) {
    } else if (single is BoutAction) {
      getManyStreamController<BoutAction>(filterType: Bout)?.add(ManyDataObject(
        data: getBoutActionsOfBout(single.bout),
        filterType: Bout,
        filterId: single.bout.id,
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
      // if (single.league != null) {
      //   getManyStreamController<Team>(filterType: League)?.add(ManyDataObject(
      //     data: getTeamsOfLeague(single.league!),
      //     filterType: League,
      //     filterId: single.league!.id,
      //   ));
      // }
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
      throw DataUnimplementedError(CRUD.update, T);
    }
  }

  List<T> _getListOfObject<T extends DataObject>(T obj, CRUD crud) {
    if (obj is Club) {
      return getClubs().cast<T>();
    } else if (obj is Bout) {
      return getBouts().cast<T>();
    } else if (obj is BoutAction) {
      return getBoutActions().cast<T>();
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
    } else if (obj is TeamMatchBout) {
      return getTeamMatchBouts().cast<T>();
    } else if (obj is WeightClass) {
      return getWeightClasses().cast<T>();
    } else {
      throw DataUnimplementedError(crud, obj.runtimeType);
    }
  }

  List<T> _getListOfType<T extends DataObject>(CRUD crud) {
    switch (T) {
      case const (Club):
        return getClubs().cast<T>();
      case const (Bout):
        return getBouts().cast<T>();
      case const (BoutAction):
        return getBoutActions().cast<T>();
      case const (League):
        return getLeagues().cast<T>();
      case const (LeagueWeightClass):
        return getLeagueWeightClasses().cast<T>();
      case const (Lineup):
        return getLineups().cast<T>();
      case const (Membership):
        return getMemberships().cast<T>();
      case const (Participation):
        return getParticipations().cast<T>();
      case const (ParticipantState):
        return getParticipantStates().cast<T>();
      case const (Person):
        return getPersons().cast<T>();
      case const (Team):
        return getTeams().cast<T>();
      case const (TeamMatch):
        return getTeamMatches().cast<T>();
      case const (TeamMatchBout):
        return getTeamMatchBouts().cast<T>();
      case const (WeightClass):
        return getWeightClasses().cast<T>();
      default:
        throw DataUnimplementedError(crud, T);
    }
  }

  StreamController<T> _getSingleStreamControllerOfObject<T extends DataObject>(T obj, CRUD crud) {
    if (obj is Club) {
      return getSingleStreamController<Club>() as StreamController<T>;
    } else if (obj is Bout) {
      return getSingleStreamController<Bout>() as StreamController<T>;
    } else if (obj is BoutAction) {
      return getSingleStreamController<BoutAction>() as StreamController<T>;
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
    } else if (obj is TeamMatchBout) {
      return getSingleStreamController<TeamMatchBout>() as StreamController<T>;
    } else if (obj is WeightClass) {
      return getSingleStreamController<WeightClass>() as StreamController<T>;
    } else {
      throw DataUnimplementedError(crud, obj.runtimeType);
    }
  }
}
