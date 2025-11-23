import 'dart:async';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:wrestling_scoreboard_client/models/organization_import_type.dart';
import 'package:wrestling_scoreboard_client/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_common/common.dart';
// ignore: implementation_imports
import 'package:wrestling_scoreboard_common/src/mocked_data.dart';

final _logger = Logger('MockDataManager');

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
    return await getListOfTypeAndFilter<T>(filterObject: filterObject);
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

  Future<List<T>> getListOfTypeAndFilter<T extends DataObject>({DataObject? filterObject}) async {
    final all = await getListOfType<T>();
    if (filterObject == null) return all;

    switch (T) {
      case const (AgeCategory):
        if (filterObject is Organization) {
          return all.where((e) => (e as AgeCategory).organization?.id == filterObject.id).toList();
        }
      case const (Bout):
        if (filterObject is Competition) {
          return (await getListOfType<CompetitionBout>())
              .where((e) => e.competition.id == filterObject.id)
              .map((e) => e.bout)
              .cast<T>()
              .toList();
        }
        if (filterObject is TeamMatch) {
          return (await getListOfType<TeamMatchBout>())
              .where((e) => e.teamMatch.id == filterObject.id)
              .map((e) => e.bout)
              .cast<T>()
              .toList();
        }
      case const (BoutAction):
        if (filterObject is Bout) return all.where((e) => (e as BoutAction).bout.id == filterObject.id).toList();
      case const (BoutResultRule):
        if (filterObject is BoutConfig) {
          final a = all.where((e) => (e as BoutResultRule).boutConfig.id == filterObject.id).toList();
          return a;
        }
      case const (Club):
        if (filterObject is Organization) {
          return all.where((e) => (e as Club).organization.id == filterObject.id).toList();
        }
      case const (Competition):
        if (filterObject is Organization) {
          return all.where((e) => (e as Competition).organization?.id == filterObject.id).toList();
        }
      case const (CompetitionSystemAffiliation):
        if (filterObject is Competition) {
          return all.where((e) => (e as CompetitionSystemAffiliation).competition.id == filterObject.id).toList();
        }
      case const (CompetitionBout):
        if (filterObject is Competition) {
          return all.where((e) => (e as CompetitionBout).competition.id == filterObject.id).toList();
        }
        if (filterObject is CompetitionWeightCategory) {
          return all.where((e) => (e as CompetitionBout).weightCategory?.id == filterObject.id).toList();
        }
      case const (CompetitionLineup):
        if (filterObject is Competition) {
          return all.where((e) => (e as CompetitionLineup).competition.id == filterObject.id).toList();
        }
      case const (CompetitionParticipation):
        if (filterObject is CompetitionWeightCategory) {
          return all.where((e) => (e as CompetitionParticipation).weightCategory?.id == filterObject.id).toList();
        }
        if (filterObject is CompetitionLineup) {
          return all.where((e) => (e as CompetitionParticipation).lineup.id == filterObject.id).toList();
        }
      case const (CompetitionWeightCategory):
        if (filterObject is Competition) {
          return all.where((e) => (e as CompetitionWeightCategory).competition.id == filterObject.id).toList();
        }
      case const (CompetitionAgeCategory):
        if (filterObject is Competition) {
          return all.where((e) => (e as CompetitionAgeCategory).competition.id == filterObject.id).toList();
        }
      case const (Division):
        if (filterObject is Organization) {
          return all.where((e) => (e as Division).organization.id == filterObject.id).toList();
        }
        if (filterObject is Division) return all.where((e) => (e as Division).parent?.id == filterObject.id).toList();
      case const (DivisionWeightClass):
        if (filterObject is Division) {
          return all.where((e) => (e as DivisionWeightClass).division.id == filterObject.id).toList();
        }
      case const (League):
        if (filterObject is Division) return all.where((e) => (e as League).division.id == filterObject.id).toList();
      case const (LeagueTeamParticipation):
        if (filterObject is League) {
          return all.where((e) => (e as LeagueTeamParticipation).league.id == filterObject.id).toList();
        }
        if (filterObject is Team) {
          return all.where((e) => (e as LeagueTeamParticipation).team.id == filterObject.id).toList();
        }
      case const (LeagueWeightClass):
        if (filterObject is League) {
          return all.where((e) => (e as LeagueWeightClass).league.id == filterObject.id).toList();
        }
      case const (Membership):
        if (filterObject is Club) return all.where((e) => (e as Membership).club.id == filterObject.id).toList();
      case const (Organization):
        if (filterObject is Organization) {
          return all.where((e) => (e as Organization).parent?.id == filterObject.id).toList();
        }
      case const (Person):
        if (filterObject is Organization) {
          return all.where((e) => (e as Person).organization?.id == filterObject.id).toList();
        }
      case const (ScratchBout):
        if (filterObject is Bout) {
          return all.where((e) => (e as ScratchBout).bout.id == filterObject.id).toList();
        }
      case const (Team):
        if (filterObject is Club) {
          return (await getListOfType<TeamClubAffiliation>())
              .where((e) => e.club.id == filterObject.id)
              .map((e) => e.team)
              .cast<T>()
              .toList();
        }
        if (filterObject is League) {
          return (await getListOfType<LeagueTeamParticipation>())
              .where((e) => e.league.id == filterObject.id)
              .map((e) => e.team)
              .cast<T>()
              .toList();
        }
      case const (TeamMatch):
        if (filterObject is League) return all.where((e) => (e as TeamMatch).league?.id == filterObject.id).toList();
        if (filterObject is Team) {
          return all
              .where(
                (e) =>
                    (e as TeamMatch).home.team.id == filterObject.id ||
                    (e as TeamMatch).guest.team.id == filterObject.id,
              )
              .toList();
        }
      case const (TeamMatchBout):
        if (filterObject is TeamMatch) {
          return all.where((e) => (e as TeamMatchBout).teamMatch.id == filterObject.id).toList();
        }
      case const (TeamLineupParticipation):
        if (filterObject is TeamLineup) {
          return all.where((e) => (e as TeamLineupParticipation).lineup.id == filterObject.id).toList();
        }
      case const (WeightClass):
        if (filterObject is Division) {
          return (await getListOfType<DivisionWeightClass>())
              .where((e) => e.division.id == filterObject.id)
              .map((e) => e.weightClass)
              .cast<T>()
              .toList();
        }
      default:
    }
    throw DataUnimplementedError(CRUD.read, T, filterObject);
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
  Future<void> generateBouts<T extends DataObject>(T dataObject, [bool isReset = false]) async {
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
      broadcastMany<TeamMatchBout, T>(teamMatchBoutsAll, filterObject: dataObject);
    } else if (dataObject is CompetitionWeightCategory) {
      // Implemented currently server side only
    }
  }

  @override
  Future<int> createOrUpdateSingle<T extends DataObject>(T single) async {
    final operation = single.id == null ? CRUD.create : CRUD.update;
    single = operation == CRUD.create ? await _createMockSingle<T>(single) : await _updateMockSingle<T>(single);
    broadcastDependants(single);
    return single.id!;
  }

  Future<List<T>> createOrUpdateMany<T extends DataObject, S extends DataObject>(
    List<T> many, {
    S? filterObject,
  }) async {
    final allMany = await getListOfType<T>();
    final currentMany = await getListOfTypeAndFilter<T>(filterObject: filterObject);
    await Future.wait(currentMany.map((single) async => allMany.removeWhere((element) => element.id == single.id)));
    allMany.addAll(many);
    broadcastMany<T, S>(many, filterObject: filterObject);
    return many;
  }

  Future<T> _createMockSingle<T extends DataObject>(T single) async {
    single = single.copyWithId(Random().nextInt(32000)) as T;
    (await getListOfType<T>()).add(single);
    return single;
  }

  Future<T> _updateMockSingle<T extends DataObject>(T single) async {
    final objList = await getListOfType<T>();
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
    broadcastSingle<T>(single);
    return single;
  }

  @override
  Future<void> deleteSingle<T extends DataObject>(T single) async {
    (await getListOfType<T>()).remove(single);
    broadcastDependants(single);
  }

  Future<void> deleteMany<T extends DataObject>(List<T> many) async {
    final allMany = await getListOfType<T>();
    await Future.wait(many.map((single) async => allMany.remove(single)));
    broadcastMany<T, Null>(many);
  }

  void broadcastSingle<T extends DataObject>(T single) async {
    getSingleStreamController<T>()?.add(single);
  }

  Future<void> broadcastMany<T extends DataObject, S extends DataObject?>(List<T> many, {S? filterObject}) async {
    final manyFilter = ManyDataObject(data: many, filterType: S, filterId: filterObject?.id);
    return getManyStreamController<T>(filterType: S)?.add(manyFilter);
  }

  // Currently do not update list of all entities (as it should only be used in special cases)
  // Update doesn't need to update filtered lists, as it should already be listened to the object itself, which gets an update event
  void broadcastDependants<T extends DataObject>(T single) async {
    if (single is AthleteBoutState) {
    } else if (single is Club) {
      // SpecialCase: the full Club list has to be updated, shouldn't occur often
      getManyStreamController<Club>()?.add(ManyDataObject(data: await readMany<Club, Null>()));
    } else if (single is Bout) {
    } else if (single is BoutAction) {
      getManyStreamController<BoutAction>(filterType: Bout)?.add(
        ManyDataObject(
          data: await readMany<BoutAction, Bout>(filterObject: single.bout),
          filterType: Bout,
          filterId: single.bout.id,
        ),
      );
    } else if (single is BoutConfig) {
    } else if (single is BoutResultRule) {
      getManyStreamController<BoutResultRule>(filterType: BoutConfig)?.add(
        ManyDataObject(
          data: await readMany<BoutResultRule, BoutConfig>(filterObject: single.boutConfig),
          filterType: BoutConfig,
          filterId: single.boutConfig.id,
        ),
      );
    } else if (single is League) {
      getManyStreamController<League>()?.add(ManyDataObject(data: await readMany<League, Null>()));
    } else if (single is DivisionWeightClass) {
      getManyStreamController<DivisionWeightClass>(filterType: League)?.add(
        ManyDataObject(
          data: await readMany<DivisionWeightClass, Division>(filterObject: single.division),
          filterType: League,
          filterId: single.division.id,
        ),
      );
    } else if (single is TeamLineup) {
      // No filtered list needs to be handled.
    } else if (single is Membership) {
      getManyStreamController<Membership>(filterType: Club)?.add(
        ManyDataObject(
          data: await readMany<Membership, Club>(filterObject: single.club),
          filterType: Club,
          filterId: single.club.id,
        ),
      );
    } else if (single is TeamLineupParticipation) {
      getManyStreamController<TeamLineupParticipation>(filterType: TeamLineup)?.add(
        ManyDataObject(
          data: await readMany<TeamLineupParticipation, TeamLineup>(filterObject: single.lineup),
          filterType: TeamLineup,
          filterId: single.lineup.id,
        ),
      );
    } else if (single is Person) {
    } else if (single is ScratchBout) {
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
          data: await readMany<TeamMatch, Team>(filterObject: single.home.team),
          filterType: Team,
          filterId: single.home.id,
        ),
      );
      getManyStreamController<TeamMatch>(filterType: Team)?.add(
        ManyDataObject(
          data: await readMany<TeamMatch, Team>(filterObject: single.guest.team),
          filterType: Team,
          filterId: single.guest.id,
        ),
      );
    } else {
      throw DataUnimplementedError(CRUD.update, T);
    }
  }

  Future<List<T>> getListOfType<T extends DataObject>() async {
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

  @override
  set webSocketManager(WebSocketManager manager) {
    // TODO: implement webSocketManager
  }

  @override
  Future<RemoteConfig> getRemoteConfig() async {
    return RemoteConfig(
      migration: Migration(
        semver: Version(0, 3, 7).canonicalizedVersion,
        minClientVersion: Version(0, 3, 7).canonicalizedVersion,
      ),
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
  Future<void> organizationImport(
    int id, {
    bool includeSubjacent = false,
    AuthService? authService,
    required OrganizationImportType importType,
  }) {
    // TODO: implement organizationImport
    throw UnimplementedError();
  }

  @override
  Future<DateTime?> organizationLastImportUtcDateTime(int id, OrganizationImportType importType) =>
      throw UnimplementedError();

  @override
  Future<double?> organizationImportProgress(int id, OrganizationImportType importType) => throw UnimplementedError();

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
  Future<String> signUp(User user) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<User?> getUser() async {
    return User(username: 'admin', privilege: UserPrivilege.admin, person: null, createdAt: DateTime.now());
  }

  @override
  Future<String> updateUser(User user) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser() {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<void> requestVerificationCode({required String username}) {
    // TODO: implement requestVerificationCode
    throw UnimplementedError();
  }

  @override
  Future<String> signInWithVerification(UserVerification verification) {
    // TODO: implement signInWithVerification
    throw UnimplementedError();
  }

  @override
  Future<void> mergeObjects<T extends DataObject>(List<T> objects) {
    // TODO: implement mergeObjects
    throw UnimplementedError();
  }

  @override
  Future<void> reorder<T extends PosOrderable, S extends DataObject?>({
    required int id,
    required int newIndex,
    S? filterObject,
  }) {
    // TODO: implement reorder
    throw UnimplementedError();
  }

  @override
  Future<bool> organizationCheckCredentials(int id, {required AuthService authService}) async {
    return true;
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
    _logger.fine('addToSink: $val');
  }

  @override
  StreamController<WebSocketConnectionState> onWebSocketConnection = StreamController.broadcast();
}
