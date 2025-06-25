import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:pub_semver/pub_semver.dart';
import 'package:wrestling_scoreboard_client/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_common/common.dart';
// ignore: implementation_imports
import 'package:wrestling_scoreboard_common/src/mocked_data.dart';

class MockDataManager extends DataManager {
  final latency = const Duration(milliseconds: 100);
  final mockedData = MockedData();

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
  Future<Iterable<Map<String, dynamic>>> readManyJson<T extends DataObject, S extends DataObject?>({
    S? filterObject,
  }) async {
    throw UnimplementedError('Raw types are not supported in Mock mode');
    // return Future.value(getManyMocksFromClass<T>(filterObject: filterObject).map((e) => e.toJson()));
  }

  List<T> getManyMocksFromClass<T extends DataObject>({DataObject? filterObject}) {
    if (filterObject != null) {
      switch (T) {
        case const (AgeCategory):
          if (filterObject is Organization) return mockedData.getAgeCategoryOfOrganization(filterObject).cast<T>();
        case const (Bout):
          if (filterObject is Competition) return mockedData.getBoutsOfCompetition(filterObject).cast<T>();
          if (filterObject is TeamMatch) return mockedData.getBoutsOfTeamMatch(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (BoutAction):
          if (filterObject is Bout) return mockedData.getBoutActionsOfBout(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (BoutResultRule):
          if (filterObject is BoutConfig) return mockedData.getBoutResultRulesOfBoutConfig(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (Club):
          if (filterObject is Organization) return mockedData.getClubsOfOrganization(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (Competition):
          if (filterObject is Organization) return mockedData.getCompetitionsOfOrganization(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (CompetitionSystemAffiliation):
          if (filterObject is Competition) {
            return mockedData.getCompetitionSystemAffiliationsOfCompetition(filterObject).cast<T>();
          }
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (CompetitionBout):
          if (filterObject is Competition) return mockedData.getCompetitionBoutsOfCompetition(filterObject).cast<T>();
          if (filterObject is CompetitionWeightCategory) {
            return mockedData.getCompetitionBoutsOfWeightCategory(filterObject).cast<T>();
          }
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (CompetitionLineup):
          if (filterObject is Competition) return mockedData.getCompetitionLineupsOfCompetition(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (CompetitionParticipation):
          if (filterObject is CompetitionWeightCategory) {
            return mockedData.getCompetitionParticipationsOfWeightCategory(filterObject).cast<T>();
          }
          if (filterObject is CompetitionLineup) {
            return mockedData.getCompetitionParticipationsOfLineup(filterObject).cast<T>();
          }

          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (CompetitionWeightCategory):
          if (filterObject is Competition) {
            return mockedData.getCompetitionWeightCategoriesOfCompetition(filterObject).cast<T>();
          }
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (CompetitionAgeCategory):
          if (filterObject is Competition) {
            return mockedData.getCompetitionAgeCategoriesOfCompetition(filterObject).cast<T>();
          }
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (Division):
          if (filterObject is Organization) return mockedData.getDivisionsOfOrganization(filterObject).cast<T>();
          if (filterObject is Division) return mockedData.getDivisionsOfDivision(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (DivisionWeightClass):
          if (filterObject is Division) return mockedData.getDivisionWeightClassesOfDivision(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (League):
          if (filterObject is Division) return mockedData.getLeaguesOfDivision(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (LeagueTeamParticipation):
          if (filterObject is League) return mockedData.getLeagueTeamParticipationsOfLeague(filterObject).cast<T>();
          if (filterObject is Team) return mockedData.getLeagueTeamParticipationsOfTeam(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (LeagueWeightClass):
          if (filterObject is League) return mockedData.getLeagueWeightClassesOfLeague(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (Membership):
          if (filterObject is Club) return mockedData.getMembershipsOfClub(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (Organization):
          if (filterObject is Organization) return mockedData.getOrganizationsOfOrganization(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (Person):
          if (filterObject is Organization) return mockedData.getPersonsOfOrganization(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (Team):
          if (filterObject is Club) return mockedData.getTeamsOfClub(filterObject).cast<T>();
          if (filterObject is League) return mockedData.getTeamsOfLeague(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (TeamMatch):
          if (filterObject is League) return mockedData.getTeamMatchesOfLeague(filterObject).cast<T>();
          if (filterObject is Team) return mockedData.getTeamMatchesOfTeam(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (TeamMatchBout):
          if (filterObject is TeamMatch) return mockedData.getTeamMatchBoutsOfTeamMatch(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (TeamLineupParticipation):
          if (filterObject is TeamLineup) return mockedData.getTeamLineupParticipationsOfLineup(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        case const (WeightClass):
          // TODO may remove in favor of getDivisionWeightClassesOfLeague
          if (filterObject is Division) return mockedData.getWeightClassesOfDivision(filterObject).cast<T>();
          throw DataUnimplementedError(CRUD.read, T, filterObject);
        default:
          throw DataUnimplementedError(CRUD.read, T, filterObject);
      }
    }
    return _getListOfType<T>();
  }

  T _addToListWithUniqueId<T extends DataObject>(List<T> objects, T object) {
    final random = Random();
    do {
      // Generate new id as long it is not taken yet
      object = object.copyWithId(random.nextInt(0x7fffffff)) as T;
    } while (objects.where((f) => f.id == object.id).isNotEmpty);
    objects.add(object);
    return object;
  }

  @override
  Future<void> generateBouts<T extends DataObject>(DataObject dataObject, [bool isReset = false]) async {
    if (dataObject is TeamMatch) {
      final teamMatchBoutsAll = mockedData.getTeamMatchBouts();
      if (isReset) {
        for (var element in teamMatchBoutsAll) {
          teamMatchBoutsAll.removeWhere((tmf) => tmf.equalDuringBout(element));
        }
      }

      List<List<TeamLineupParticipation>> teamParticipations;
      List<WeightClass> weightClasses;
      final homeParticipations = await readMany<TeamLineupParticipation, TeamLineup>(filterObject: dataObject.home);
      final guestParticipations = await readMany<TeamLineupParticipation, TeamLineup>(filterObject: dataObject.guest);
      teamParticipations = [homeParticipations, guestParticipations];
      weightClasses = await readMany<WeightClass, League>(filterObject: dataObject.league);

      // Generate new bouts
      final newBouts = await dataObject.generateBouts(teamParticipations, weightClasses);

      // Add if not exists
      for (var element in newBouts) {
        if (teamMatchBoutsAll.where((TeamMatchBout f) => f.equalDuringBout(element)).isEmpty) {
          element = _addToListWithUniqueId(teamMatchBoutsAll, element);
        }
      }
      _updateMany(TeamMatchBout, filterObject: dataObject);
    } else if (dataObject is CompetitionWeightCategory) {
      // Implemented currently server side only
    }
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
      case const (TeamMatchBout):
        if (filterObject is TeamMatch) {
          final manyFilter = ManyDataObject(
            data: mockedData.getBoutsOfTeamMatch(filterObject),
            filterType: TeamMatch,
            filterId: filterObject.id,
          );
          return getManyStreamController<TeamMatchBout>(filterType: TeamMatch)?.add(manyFilter);
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
    if (single is TeamLineup) {
      final participations = mockedData.getTeamLineupParticipations();
      final participationsWithLineup = participations.where((element) => element.lineup.id == single.id);
      for (final participationWithLineup in participationsWithLineup) {
        participations.remove(participationWithLineup);
        participations.add(participationWithLineup.copyWith(lineup: single));
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
      getManyStreamController<Club>()?.add(ManyDataObject(data: mockedData.getClubs()));
    } else if (single is Bout) {
    } else if (single is BoutAction) {
      getManyStreamController<BoutAction>(filterType: Bout)?.add(
        ManyDataObject(data: mockedData.getBoutActionsOfBout(single.bout), filterType: Bout, filterId: single.bout.id),
      );
    } else if (single is League) {
      getManyStreamController<League>()?.add(ManyDataObject(data: mockedData.getLeagues()));
    } else if (single is DivisionWeightClass) {
      getManyStreamController<DivisionWeightClass>(filterType: League)?.add(
        ManyDataObject(
          data: mockedData.getDivisionWeightClassesOfDivision(single.division),
          filterType: League,
          filterId: single.division.id,
        ),
      );
    } else if (single is TeamLineup) {
      // No filtered list needs to be handled.
    } else if (single is Membership) {
      getManyStreamController<Membership>(filterType: Club)?.add(
        ManyDataObject(data: mockedData.getMembershipsOfClub(single.club), filterType: Club, filterId: single.club.id),
      );
    } else if (single is TeamLineupParticipation) {
      getManyStreamController<TeamLineupParticipation>(filterType: TeamLineup)?.add(
        ManyDataObject(
          data: mockedData.getTeamLineupParticipationsOfLineup(single.lineup),
          filterType: TeamLineup,
          filterId: single.lineup.id,
        ),
      );
    } else if (single is AthleteBoutState) {
    } else if (single is Person) {
    } else if (single is Team) {
    } else if (single is TeamClubAffiliation) {
      // getManyStreamController<Team>(filterType: Club)?.add(ManyDataObject(
      //   data: getTeamsOfClub(single.club),
      //   filterType: Club,
      //   filterId: single.club.id,
      // ));
      // if (single.league != null) {
      //   getManyStreamController<Team>(filterType: League)?.add(ManyDataObject(
      //     data: getTeamsOfLeague(single.league!),
      //     filterType: League,
      //     filterId: single.league!.id,
      //   ));
      // }
    } else if (single is TeamMatch) {
      getManyStreamController<TeamMatch>(filterType: Team)?.add(
        ManyDataObject(
          data: mockedData.getTeamMatchesOfTeam(single.home.team),
          filterType: Team,
          filterId: single.home.id,
        ),
      );
      getManyStreamController<TeamMatch>(filterType: Team)?.add(
        ManyDataObject(
          data: mockedData.getTeamMatchesOfTeam(single.guest.team),
          filterType: Team,
          filterId: single.guest.id,
        ),
      );
    } else {
      throw DataUnimplementedError(CRUD.update, T);
    }
  }

  List<T> _getListOfObject<T extends DataObject>(T obj, CRUD crud) {
    if (obj is AthleteBoutState) {
      return mockedData.getAthleteBoutStates().cast<T>();
    } else if (obj is Bout) {
      return mockedData.getBouts().cast<T>();
    } else if (obj is BoutAction) {
      return mockedData.getBoutActions().cast<T>();
    } else if (obj is Club) {
      return mockedData.getClubs().cast<T>();
    } else if (obj is Competition) {
      return mockedData.getCompetitions().cast<T>();
    } else if (obj is CompetitionWeightCategory) {
      return mockedData.getCompetitionWeightCategories().cast<T>();
    } else if (obj is CompetitionSystemAffiliation) {
      return mockedData.getCompetitionSystemAffiliations().cast<T>();
    } else if (obj is CompetitionParticipation) {
      return mockedData.getCompetitionParticipations().cast<T>();
    } else if (obj is CompetitionLineup) {
      return mockedData.getCompetitionLineups().cast<T>();
    } else if (obj is CompetitionBout) {
      return mockedData.getCompetitionBouts().cast<T>();
      /*} else if (obj is CompetitionPerson) {
      return mockedData.getCompetitionPersons().cast<T>();*/
    } else if (obj is Division) {
      return mockedData.getDivisions().cast<T>();
    } else if (obj is DivisionWeightClass) {
      return mockedData.getDivisionWeightClasses().cast<T>();
    } else if (obj is League) {
      return mockedData.getLeagues().cast<T>();
    } else if (obj is Membership) {
      return mockedData.getMemberships().cast<T>();
    } else if (obj is Organization) {
      return mockedData.getOrganizations().cast<T>();
    } else if (obj is TeamLineup) {
      return mockedData.getTeamLineups().cast<T>();
    } else if (obj is TeamLineupParticipation) {
      return mockedData.getTeamLineupParticipations().cast<T>();
    } else if (obj is Team) {
      return mockedData.getTeams().cast<T>();
    } else if (obj is TeamMatch) {
      return mockedData.getTeamMatches().cast<T>();
    } else if (obj is TeamMatchBout) {
      return mockedData.getTeamMatchBouts().cast<T>();
    } else if (obj is Person) {
      return mockedData.getPersons().cast<T>();
    } else if (obj is WeightClass) {
      return mockedData.getWeightClasses().cast<T>();
    } else {
      throw DataUnimplementedError(crud, obj.runtimeType);
    }
  }

  List<T> _getListOfType<T extends DataObject>() {
    switch (T) {
      case const (Club):
        return mockedData.getClubs().cast<T>();
      case const (Competition):
        return mockedData.getCompetitions().cast<T>();
      case const (CompetitionSystemAffiliation):
        return mockedData.getCompetitionSystemAffiliations().cast<T>();
      case const (CompetitionBout):
        return mockedData.getCompetitionBouts().cast<T>();
      case const (CompetitionLineup):
        return mockedData.getCompetitionLineups().cast<T>();
      case const (CompetitionParticipation):
        return mockedData.getCompetitionParticipations().cast<T>();
      case const (CompetitionWeightCategory):
        return mockedData.getCompetitionWeightCategories().cast<T>();
      case const (Bout):
        return mockedData.getBouts().cast<T>();
      case const (BoutAction):
        return mockedData.getBoutActions().cast<T>();
      case const (Organization):
        return mockedData.getOrganizations().cast<T>();
      case const (Division):
        return mockedData.getDivisions().cast<T>();
      case const (League):
        return mockedData.getLeagues().cast<T>();
      case const (DivisionWeightClass):
        return mockedData.getDivisionWeightClasses().cast<T>();
      case const (TeamLineup):
        return mockedData.getTeamLineups().cast<T>();
      case const (Membership):
        return mockedData.getMemberships().cast<T>();
      case const (TeamLineupParticipation):
        return mockedData.getTeamLineupParticipations().cast<T>();
      case const (AthleteBoutState):
        return mockedData.getAthleteBoutStates().cast<T>();
      case const (Person):
        return mockedData.getPersons().cast<T>();
      case const (Team):
        return mockedData.getTeams().cast<T>();
      case const (TeamMatch):
        return mockedData.getTeamMatches().cast<T>();
      case const (TeamMatchBout):
        return mockedData.getTeamMatchBouts().cast<T>();
      case const (WeightClass):
        return mockedData.getWeightClasses().cast<T>();
      default:
        throw UnimplementedError();
    }
  }

  StreamController<T> _getSingleStreamControllerOfObject<T extends DataObject>(T obj, CRUD crud) {
    if (obj is Club) {
      return getSingleStreamController<Club>() as StreamController<T>;
    } else if (obj is Bout) {
      return getSingleStreamController<Bout>() as StreamController<T>;
    } else if (obj is BoutAction) {
      return getSingleStreamController<BoutAction>() as StreamController<T>;
    } else if (obj is Organization) {
      return getSingleStreamController<Organization>() as StreamController<T>;
    } else if (obj is Division) {
      return getSingleStreamController<Division>() as StreamController<T>;
    } else if (obj is DivisionWeightClass) {
      return getSingleStreamController<DivisionWeightClass>() as StreamController<T>;
    } else if (obj is League) {
      return getSingleStreamController<League>() as StreamController<T>;
    } else if (obj is LeagueWeightClass) {
      return getSingleStreamController<LeagueWeightClass>() as StreamController<T>;
    } else if (obj is TeamLineup) {
      return getSingleStreamController<TeamLineup>() as StreamController<T>;
    } else if (obj is Membership) {
      return getSingleStreamController<Membership>() as StreamController<T>;
    } else if (obj is TeamLineupParticipation) {
      return getSingleStreamController<TeamLineupParticipation>() as StreamController<T>;
    } else if (obj is AthleteBoutState) {
      return getSingleStreamController<AthleteBoutState>() as StreamController<T>;
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

  @override
  set webSocketManager(WebSocketManager manager) {
    // TODO: implement webSocketManager
  }

  @override
  Future<Migration> getMigration() async {
    return Migration(
      semver: Version(0, 2, 1).canonicalizedVersion,
      minClientVersion: Version(0, 0, 0).canonicalizedVersion,
    );
  }

  @override
  Future<String> exportDatabase() {
    // TODO: implement exportDatabase
    throw UnimplementedError();
  }

  @override
  Future<void> resetDatabase() {
    // TODO: implement resetDatabase
    throw UnimplementedError();
  }

  @override
  Future<void> restoreDefaultDatabase() {
    // TODO: implement restoreDatabase
    throw UnimplementedError();
  }

  @override
  Future<void> restoreDatabase(String sqlDump) {
    // TODO: implement restoreDatabase
    throw UnimplementedError();
  }

  @override
  Future<void> organizationImport(int id, {bool includeSubjacent = false, AuthService? authService}) {
    // TODO: implement organizationImport
    throw UnimplementedError();
  }

  @override
  Future<void> organizationLeagueImport(int id, {bool includeSubjacent = false, AuthService? authService}) {
    // TODO: implement organizationLeagueImport
    throw UnimplementedError();
  }

  @override
  Future<void> organizationTeamMatchImport(int id, {bool includeSubjacent = false, AuthService? authService}) {
    // TODO: implement organizationLeagueImport
    throw UnimplementedError();
  }

  @override
  Future<void> organizationCompetitionImport(int id, {bool includeSubjacent = false, AuthService? authService}) {
    // TODO: implement organizationCompetitionImport
    throw UnimplementedError();
  }

  @override
  Future<void> organizationTeamImport(int id, {bool includeSubjacent = false, AuthService? authService}) {
    // TODO: implement organizationTeamImport
    throw UnimplementedError();
  }

  @override
  Future<DateTime?> organizationLastImportUtcDateTime(int id) => throw UnimplementedError();

  @override
  Future<DateTime?> organizationLeagueLastImportUtcDateTime(int id) => throw UnimplementedError();

  @override
  Future<DateTime?> organizationTeamMatchLastImportUtcDateTime(int id) => throw UnimplementedError();

  @override
  Future<DateTime?> organizationCompetitionLastImportUtcDateTime(int id) => throw UnimplementedError();

  @override
  Future<DateTime?> organizationTeamLastImportUtcDateTime(int id) => throw UnimplementedError();

  @override
  Future<Map<String, List<DataObject>>> search({
    required String searchTerm,
    Type? type,
    int? organizationId,
    AuthService? authService,
    bool includeApiProviderResults = false,
  }) {
    // TODO: implement search
    throw UnimplementedError();
  }

  @override
  Future<String> signIn(BasicAuthService authService) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<void> signUp(User user) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<User?> getUser() async {
    return User(username: 'admin', privilege: UserPrivilege.admin, person: null, createdAt: DateTime.now());
  }

  @override
  Future<void> updateUser(User user) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<void> mergeObjects<T extends DataObject>(List<T> objects) {
    // TODO: implement mergeObjects
    throw UnimplementedError();
  }

  @override
  Future<void> reorder<T extends Orderable, S extends DataObject?>({
    required int id,
    required int newIndex,
    S? filterObject,
  }) {
    // TODO: implement reorder
    throw UnimplementedError();
  }
}

class MockWebSocketManager implements WebSocketManager {
  MockWebSocketManager(this.dataManager, {String? url}) {
    onWebSocketConnection.stream.listen((connectionState) async {
      if (connectionState == WebSocketConnectionState.connecting) {
        onWebSocketConnection.sink.add(WebSocketConnectionState.connected);
      }
    });
    onWebSocketConnection.sink.add(WebSocketConnectionState.connecting);
  }

  @override
  DataManager dataManager;

  @override
  addToSink(String val) {
    developer.log('addToSink: $val');
  }

  @override
  StreamController<WebSocketConnectionState> onWebSocketConnection = StreamController.broadcast();
}
