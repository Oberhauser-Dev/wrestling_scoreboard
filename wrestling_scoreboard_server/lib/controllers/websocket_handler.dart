import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_action_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/club_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/membership_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_club_affiliation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/services/auth.dart';
import 'package:wrestling_scoreboard_server/services/environment.dart';

import 'entity_controller.dart';
import 'league_team_participation_controller.dart';

final _logger = Logger('Websocket');

final Map<WebSocketChannel, UserPrivilege> webSocketPool = <WebSocketChannel, UserPrivilege>{};

void broadcast(Future<String> Function(bool obfuscate) builder) async {
  final futureData = builder(false);
  final futureObfuscatedData = builder(true);
  // Use map to perform asynchronously
  await Future.wait(webSocketPool.entries.map((poolEntry) async {
    // Send obfuscated data to users with no read privilege
    poolEntry.key.sink.add(poolEntry.value <= UserPrivilege.none ? (await futureObfuscatedData) : (await futureData));
  }));
}

/// Update filtered lists (often the list they are contained in).
/// Currently do not update list of all entities (as it should only be used in special cases)
void broadcastSingle<T extends DataObject>(T single) async {
  if (single is Club) {
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await ClubController().getMany(
            conditions: ['organization_id = @id'],
            substitutionValues: {'id': single.organization.id},
            obfuscate: obfuscate),
        Club,
        CRUD.update,
        isRaw: false,
        filterType: Organization,
        filterId: single.organization.id)));
  } else if (single is BoutConfig) {
  } else if (single is Bout) {
  } else if (single is BoutAction) {
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await BoutActionController()
            .getMany(conditions: ['bout_id = @id'], substitutionValues: {'id': single.bout.id}, obfuscate: obfuscate),
        BoutAction,
        CRUD.update,
        isRaw: false,
        filterType: Bout,
        filterId: single.bout.id)));
  } else if (single is Organization) {
    // SpecialCase: the full Organization list has to be updated with no filter, shouldn't occur often
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await OrganizationController().getMany(obfuscate: obfuscate), Organization, CRUD.update,
        isRaw: false)));
  } else if (single is Division) {
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await DivisionController().getMany(
            conditions: ['organization_id = @id'],
            substitutionValues: {'id': single.organization.id},
            obfuscate: obfuscate),
        Division,
        CRUD.update,
        isRaw: false,
        filterType: Organization,
        filterId: single.organization.id)));
  } else if (single is League) {
  } else if (single is DivisionWeightClass) {
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await DivisionWeightClassController().getMany(
            conditions: ['division_id = @id'], substitutionValues: {'id': single.division.id}, obfuscate: obfuscate),
        DivisionWeightClass,
        CRUD.update,
        isRaw: false,
        filterType: Division,
        filterId: single.division.id)));
  } else if (single is LeagueTeamParticipation) {
    final leagueTeamParticipationController = LeagueTeamParticipationController();
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await leagueTeamParticipationController.getMany(
            conditions: ['league_id = @id'], substitutionValues: {'id': single.league.id}, obfuscate: obfuscate),
        LeagueTeamParticipation,
        CRUD.update,
        isRaw: false,
        filterType: League,
        filterId: single.league.id)));
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await leagueTeamParticipationController
            .getMany(conditions: ['team_id = @id'], substitutionValues: {'id': single.team.id}, obfuscate: obfuscate),
        LeagueTeamParticipation,
        CRUD.update,
        isRaw: false,
        filterType: Team,
        filterId: single.team.id)));
  } else if (single is Lineup) {
    // No filtered list needs to be handled.
  } else if (single is Membership) {
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await MembershipController()
            .getMany(conditions: ['club_id = @id'], substitutionValues: {'id': single.club.id}, obfuscate: obfuscate),
        Membership,
        CRUD.update,
        isRaw: false,
        filterType: Club,
        filterId: single.club.id)));
  } else if (single is Participation) {
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await ParticipationController().getMany(
            conditions: ['lineup_id = @id'], substitutionValues: {'id': single.lineup.id}, obfuscate: obfuscate),
        Participation,
        CRUD.update,
        isRaw: false,
        filterType: Lineup,
        filterId: single.lineup.id)));
  } else if (single is ParticipantState) {
  } else if (single is Person) {
    // No filtered list needs to be handled.
  } else if (single is Team) {
  } else if (single is TeamClubAffiliation) {
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        (await TeamClubAffiliationController().getMany(
                conditions: ['club_id = @id'], substitutionValues: {'id': single.club.id}, obfuscate: obfuscate))
            .map((tca) => tca.team)
            .toList(),
        Team,
        CRUD.update,
        isRaw: false,
        filterType: Club,
        filterId: single.club.id)));

    broadcast((obfuscate) async => jsonEncode(manyToJson(
        (await TeamClubAffiliationController().getMany(
                conditions: ['team_id = @id'], substitutionValues: {'id': single.team.id}, obfuscate: obfuscate))
            .map((tca) => tca.club)
            .toList(),
        Club,
        CRUD.update,
        isRaw: false,
        filterType: Team,
        filterId: single.team.id)));
  } else if (single is TeamMatch) {
    final teamMatchController = TeamMatchController();

    broadcast((obfuscate) async {
      final homeMatches = await teamMatchController.getManyFromQuery(TeamController.teamMatchesQuery,
          substitutionValues: {'id': single.home.team.id}, obfuscate: obfuscate);
      return jsonEncode(manyToJson(homeMatches, TeamMatch, CRUD.update,
          isRaw: false, filterType: Team, filterId: single.home.team.id));
    });

    broadcast((obfuscate) async {
      final guestMatches = await teamMatchController.getManyFromQuery(TeamController.teamMatchesQuery,
          substitutionValues: {'id': single.guest.team.id}, obfuscate: obfuscate);
      return jsonEncode(manyToJson(guestMatches, TeamMatch, CRUD.update,
          isRaw: false, filterType: Team, filterId: single.guest.team.id));
    });

    if (single.league?.id != null) {
      broadcast((obfuscate) async {
        final leagueMatches = await teamMatchController.getMany(
            conditions: ['league_id = @id'], substitutionValues: {'id': single.league!.id}, obfuscate: obfuscate);
        return jsonEncode(manyToJson(
          leagueMatches,
          TeamMatch,
          CRUD.update,
          isRaw: false,
          filterType: League,
          filterId: single.league!.id,
        ));
      });
    }
  } else if (single is TeamMatchBout) {
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await TeamMatchBoutController().getMany(
            conditions: ['team_match_id = @id'], substitutionValues: {'id': single.teamMatch.id}, obfuscate: obfuscate),
        TeamMatchBout,
        CRUD.update,
        isRaw: false,
        filterType: TeamMatch,
        filterId: single.teamMatch.id)));
  } else if (single is WeightClass) {
  } else {
    throw DataUnimplementedError(CRUD.update, T);
  }
}

void broadcastSingleRaw<T extends DataObject>(Map<String, dynamic> single) async {
  if (T == Club) {
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await ClubController().getManyRaw(
            conditions: ['organization_id = @id'],
            substitutionValues: {'id': single['organization_id']},
            obfuscate: obfuscate),
        Club,
        CRUD.update,
        isRaw: true,
        filterType: Organization,
        filterId: single['organization_id'])));
  } else if (T == BoutConfig) {
  } else if (T == Bout) {
  } else if (T == BoutAction) {
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await BoutActionController().getManyRaw(
            conditions: ['bout_id = @id'], substitutionValues: {'id': single['bout_id']}, obfuscate: obfuscate),
        BoutAction,
        CRUD.update,
        isRaw: true,
        filterType: Bout,
        filterId: single['bout_id'])));
  } else if (T == Organization) {
    // SpecialCase: the full Organization list has to be updated with no filter, shouldn't occur often
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await OrganizationController().getManyRaw(obfuscate: obfuscate), Organization, CRUD.update,
        isRaw: true)));
  } else if (T == Division) {
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await DivisionController().getManyRaw(
            conditions: ['organization_id = @id'],
            substitutionValues: {'id': single['organization_id']},
            obfuscate: obfuscate),
        Division,
        CRUD.update,
        isRaw: true,
        filterType: Organization,
        filterId: single['organization_id'])));
  } else if (T == League) {
  } else if (T == DivisionWeightClass) {
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await DivisionWeightClassController().getManyRaw(
            conditions: ['division_id = @id'], substitutionValues: {'id': single['division_id']}, obfuscate: obfuscate),
        DivisionWeightClass,
        CRUD.update,
        isRaw: true,
        filterType: Division,
        filterId: single['division_id'])));
  } else if (T == LeagueTeamParticipation) {
    final leagueTeamParticipationController = LeagueTeamParticipationController();
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await leagueTeamParticipationController.getManyRaw(
            conditions: ['league_id = @id'], substitutionValues: {'id': single['league_id']}, obfuscate: obfuscate),
        LeagueTeamParticipation,
        CRUD.update,
        isRaw: true,
        filterType: League,
        filterId: single['league_id'])));
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await leagueTeamParticipationController.getManyRaw(
            conditions: ['team_id = @id'], substitutionValues: {'id': single['team_id']}, obfuscate: obfuscate),
        LeagueTeamParticipation,
        CRUD.update,
        isRaw: true,
        filterType: Team,
        filterId: single['team_id'])));
  } else if (T == Lineup) {
    // No filtered list needs to be handled.
  } else if (T == Membership) {
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await MembershipController().getManyRaw(
            conditions: ['club_id = @id'], substitutionValues: {'id': single['club_id']}, obfuscate: obfuscate),
        Membership,
        CRUD.update,
        isRaw: true,
        filterType: Club,
        filterId: single['club_id'])));
  } else if (T == Participation) {
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await ParticipationController().getManyRaw(
            conditions: ['lineup_id = @id'], substitutionValues: {'id': single['lineup_id']}, obfuscate: obfuscate),
        Participation,
        CRUD.update,
        isRaw: true,
        filterType: Lineup,
        filterId: single['lineup_id'])));
  } else if (T == ParticipantState) {
  } else if (T == Person) {
    // No filtered list needs to be handled.
  } else if (T == Team) {
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await TeamController().getManyRaw(
            conditions: ['club_id = @id'], substitutionValues: {'id': single['club_id']}, obfuscate: obfuscate),
        Team,
        CRUD.update,
        isRaw: true,
        filterType: Club,
        filterId: single['club_id'])));
  } else if (T == TeamClubAffiliation) {
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        (await TeamClubAffiliationController().getMany(
                conditions: ['club_id = @id'], substitutionValues: {'id': single['club_id']}, obfuscate: obfuscate))
            .map((tca) => tca.team.toRaw())
            .toList(),
        Team,
        CRUD.update,
        isRaw: true,
        filterType: Club,
        filterId: single['club_id'])));

    broadcast((obfuscate) async => jsonEncode(manyToJson(
        (await TeamClubAffiliationController().getMany(
                conditions: ['team_id = @id'], substitutionValues: {'id': single['team_id']}, obfuscate: obfuscate))
            .map((tca) => tca.club.toRaw())
            .toList(),
        Club,
        CRUD.update,
        isRaw: true,
        filterType: Team,
        filterId: single['team_id'])));
  } else if (T == TeamMatch) {
    final teamMatchController = TeamMatchController();

    final homeTeamId = (await EntityController.query(await LineupController.teamIdStmt,
        substitutionValues: {'id': single['home_id']}))['team_id'];
    final homeMatches = await teamMatchController
        .getManyRawFromQuery(TeamController.teamMatchesQuery, substitutionValues: {'id': homeTeamId});
    broadcast((obfuscate) async => jsonEncode(
        manyToJson(homeMatches, TeamMatch, CRUD.update, isRaw: true, filterType: Team, filterId: homeTeamId)));

    final guestTeamId = (await EntityController.query(await LineupController.teamIdStmt,
        substitutionValues: {'id': single['guest_id']}))['team_id'];
    final guestMatches = await teamMatchController
        .getManyRawFromQuery(TeamController.teamMatchesQuery, substitutionValues: {'id': guestTeamId});
    broadcast((obfuscate) async => jsonEncode(
        manyToJson(guestMatches, TeamMatch, CRUD.update, isRaw: true, filterType: Team, filterId: guestTeamId)));

    if (single['league_id'] != null) {
      broadcast((obfuscate) async {
        final leagueMatches = await teamMatchController.getManyRaw(
            conditions: ['league_id = @id'], substitutionValues: {'id': single['league_id']}, obfuscate: obfuscate);
        return jsonEncode(manyToJson(
          leagueMatches,
          TeamMatch,
          CRUD.update,
          isRaw: true,
          filterType: League,
          filterId: single['league_id'],
        ));
      });
    }
  } else if (T == TeamMatchBout) {
    broadcast((obfuscate) async => jsonEncode(manyToJson(
        await TeamMatchBoutController().getManyRaw(
            conditions: ['team_match_id = @id'],
            substitutionValues: {'id': single['team_match_id']},
            obfuscate: obfuscate),
        TeamMatchBout,
        CRUD.update,
        isRaw: true,
        filterType: TeamMatch,
        filterId: single['team_match_id'])));
  } else if (T == WeightClass) {
  } else {
    throw DataUnimplementedError(CRUD.update, T);
  }
}

Future<int> handleSingle<T extends DataObject>({
  required CRUD operation,
  required T single,
  UserPrivilege privilege = UserPrivilege.write,
}) async {
  _logger.fine('${DateTime.now()} ${operation.name.toUpperCase()} ${single.tableName}/${single.id}');
  final controller = ShelfController.getControllerFromDataType(T);
  if (operation == CRUD.update) {
    if (privilege < UserPrivilege.write) {
      throw Exception('Not allowed to perform update operation on ${single.tableName}/${single.id}');
    }
    await controller!.updateSingle(single);
    broadcast((obfuscate) async {
      // Need to provide an obfuscated version of the dataObject, but can reuse the `single` object for non obfuscated broadcast, to raise performance
      return jsonEncode(
        singleToJson(obfuscate ? await controller.getSingle(single.id!, obfuscate: true) : single, T, operation),
      );
    });
  } else if (operation == CRUD.create) {
    if (privilege < UserPrivilege.write) {
      throw Exception('Not allowed to perform create operation on ${single.tableName}/${single.id}');
    }
    single = single.copyWithId(await controller!.createSingle(single)) as T;
  } else if (operation == CRUD.delete) {
    if (privilege < UserPrivilege.write) {
      throw Exception('Not allowed to perform delete operation on ${single.tableName}/${single.id}');
    }
    await controller!.deleteSingle(single.id!);
  }
  if (operation == CRUD.create || operation == CRUD.delete) {
    // Update doesn't need to update filtered lists, as it should already be listened to the object itself, which gets an update event
    broadcastSingle<T>(single);
  } else if (operation == CRUD.update && single is BoutAction) {
    // Update nonetheless, if it changes order of items
    broadcastSingle<T>(single);
  }
  return single.id!;
}

Future<int> handleSingleRaw<T extends DataObject>({
  required CRUD operation,
  required Map<String, dynamic> single,
  UserPrivilege privilege = UserPrivilege.write,
}) async {
  _logger.fine('${DateTime.now()} ${operation.name.toUpperCase()} ${getTableNameFromType(T)}/${single['id']}');
  final controller = ShelfController.getControllerFromDataType(T);
  if (operation == CRUD.update) {
    if (privilege < UserPrivilege.write) {
      throw Exception('Not allowed to perform update operation on ${getTableNameFromType(T)}/${single['id']}');
    }
    await controller!.updateSingleRaw(single);
    broadcast((obfuscate) async {
      // Need to provide an obfuscated version of the dataObject, but can reuse the `single` object for non obfuscated broadcast, to raise performance
      return jsonEncode(singleToJson(
          obfuscate ? await controller.getSingleRaw(single['id'], obfuscate: true) : single, T, operation));
    });
  } else if (operation == CRUD.create) {
    if (privilege < UserPrivilege.write) {
      throw Exception('Not allowed to perform create operation on ${getTableNameFromType(T)}/${single['id']}');
    }
    single['id'] = await controller!.createSingleRaw(single);
  } else if (operation == CRUD.delete) {
    if (privilege < UserPrivilege.write) {
      throw Exception('Not allowed to perform delete operation on ${getTableNameFromType(T)}/${single['id']}');
    }
    await controller!.deleteSingle(single['id']);
  }
  if (operation == CRUD.create || operation == CRUD.delete) {
    // Update doesn't need to update filtered lists, as it should already be listened to the object itself, which gets an update event
    broadcastSingleRaw<T>(single);
  } else if (operation == CRUD.update && T == BoutAction) {
    // Update nonetheless, if it changes order of items
    broadcastSingleRaw<T>(single);
  }
  return single['id'];
}

Future<void> handleMany<T extends DataObject>({
  required CRUD operation,
  required ManyDataObject<T> many,
  UserPrivilege privilege = UserPrivilege.none,
}) {
  _logger.fine('${DateTime.now()} ${operation.name.toUpperCase()} ${getTableNameFromType(T)}s');
  throw DataUnimplementedError(operation, many.runtimeType);
}

Future<void> handleManyRaw<T extends DataObject>({
  required CRUD operation,
  required ManyDataObject<Map<String, dynamic>> many,
  UserPrivilege privilege = UserPrivilege.none,
}) {
  _logger.fine('${DateTime.now()} ${operation.name.toUpperCase()} ${getTableNameFromType(T)}s');
  throw DataUnimplementedError(operation, many.runtimeType);
}

final websocketHandler = webSocketHandler(
  (WebSocketChannel webSocket) {
    UserPrivilege privilege = UserPrivilege.none;
    webSocketPool[webSocket] = privilege;
    webSocket.stream.listen((message) async {
      final json = jsonDecode(message);
      if (json['authorization'] != null) {
        final authService = BearerAuthService.fromHeader(json['authorization']);
        final user = await authService.getUser();
        privilege = user?.privilege ?? UserPrivilege.none;
        // Upgrade privilege
        webSocketPool[webSocket] = privilege;
        return;
      }
      await handleGenericJson(json,
          handleSingle: <T extends DataObject>({required CRUD operation, required T single}) async =>
              handleSingle<T>(operation: operation, single: single, privilege: privilege),
          handleMany: <T extends DataObject>({required CRUD operation, required ManyDataObject<T> many}) async =>
              handleMany<T>(operation: operation, many: many, privilege: privilege),
          handleSingleRaw: <T extends DataObject>(
                  {required CRUD operation, required Map<String, dynamic> single}) async =>
              handleSingleRaw<T>(operation: operation, single: single, privilege: privilege),
          handleManyRaw: <T extends DataObject>(
                  {required CRUD operation, required ManyDataObject<Map<String, dynamic>> many}) async =>
              handleManyRaw<T>(operation: operation, many: many, privilege: privilege));
    }, onDone: () {
      webSocketPool.remove(webSocket);
    });
  },
  pingInterval: Duration(seconds: env.webSocketPingIntervalSecs ?? 30),
);
