import 'dart:collection';
import 'dart:convert';

import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_action_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/club_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/membership_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/server.dart';

import 'entity_controller.dart';
import 'league_team_participation_controller.dart';

final Set<WebSocketChannel> webSocketPool = HashSet();

void broadcast(String data) {
  for (var element in webSocketPool) {
    element.sink.add(data);
  }
}

// Currently do not update list of all entities (as it should only be used in special cases)
void broadcastSingle<T extends DataObject>(T single) async {
  if (single is Club) {
    // SpecialCase: the full Club list has to be updated, shouldn't occur often
    broadcast(jsonEncode(manyToJson(await ClubController().getMany(), Club, CRUD.update, isRaw: false)));
  } else if (single is BoutConfig) {
  } else if (single is Bout) {
  } else if (single is BoutAction) {
    broadcast(jsonEncode(manyToJson(
        await BoutActionController().getMany(conditions: ['bout_id = @id'], substitutionValues: {'id': single.bout.id}),
        BoutAction,
        CRUD.update,
        isRaw: false,
        filterType: Bout,
        filterId: single.bout.id)));
  } else if (single is Organization) {
    // SpecialCase: the full Organization list has to be updated with no filter, shouldn't occur often
    broadcast(
        jsonEncode(manyToJson(await OrganizationController().getMany(), Organization, CRUD.update, isRaw: false)));
  } else if (single is Division) {
    // TODO
  } else if (single is League) {
  } else if (single is DivisionWeightClass) {
    broadcast(jsonEncode(manyToJson(
        await DivisionWeightClassController()
            .getMany(conditions: ['division_id = @id'], substitutionValues: {'id': single.division.id}),
        DivisionWeightClass,
        CRUD.update,
        isRaw: false,
        filterType: Division,
        filterId: single.division.id)));
  } else if (single is LeagueTeamParticipation) {
    final leagueTeamParticipationController = LeagueTeamParticipationController();
    broadcast(jsonEncode(manyToJson(
        await leagueTeamParticipationController
            .getMany(conditions: ['league_id = @id'], substitutionValues: {'id': single.league.id}),
        LeagueTeamParticipation,
        CRUD.update,
        isRaw: false,
        filterType: League,
        filterId: single.league.id)));
    broadcast(jsonEncode(manyToJson(
        await leagueTeamParticipationController
            .getMany(conditions: ['team_id = @id'], substitutionValues: {'id': single.team.id}),
        LeagueTeamParticipation,
        CRUD.update,
        isRaw: false,
        filterType: Team,
        filterId: single.team.id)));
  } else if (single is Lineup) {
    // No filtered list needs to be handled.
  } else if (single is Membership) {
    broadcast(jsonEncode(manyToJson(
        await MembershipController().getMany(conditions: ['club_id = @id'], substitutionValues: {'id': single.club.id}),
        Membership,
        CRUD.update,
        isRaw: false,
        filterType: Club,
        filterId: single.club.id)));
  } else if (single is Participation) {
    broadcast(jsonEncode(manyToJson(
        await ParticipationController()
            .getMany(conditions: ['lineup_id = @id'], substitutionValues: {'id': single.lineup.id}),
        Participation,
        CRUD.update,
        isRaw: false,
        filterType: Lineup,
        filterId: single.lineup.id)));
  } else if (single is ParticipantState) {
  } else if (single is Person) {
    // No filtered list needs to be handled.
  } else if (single is Team) {
    broadcast(jsonEncode(manyToJson(
        await TeamController().getMany(conditions: ['club_id = @id'], substitutionValues: {'id': single.club.id}),
        Team,
        CRUD.update,
        isRaw: false,
        filterType: Club,
        filterId: single.club.id)));
  } else if (single is TeamMatch) {
    final teamMatchController = TeamMatchController();

    final homeMatches = await teamMatchController
        .getManyFromQuery(TeamController.teamMatchesQuery, substitutionValues: {'id': single.home.team.id});
    broadcast(jsonEncode(manyToJson(homeMatches, TeamMatch, CRUD.update,
        isRaw: false, filterType: Team, filterId: single.home.team.id)));

    final guestMatches = await teamMatchController
        .getManyFromQuery(TeamController.teamMatchesQuery, substitutionValues: {'id': single.guest.team.id});
    broadcast(jsonEncode(manyToJson(guestMatches, TeamMatch, CRUD.update,
        isRaw: false, filterType: Team, filterId: single.guest.team.id)));

    if (single.league?.id != null) {
      final leagueMatches = await teamMatchController
          .getMany(conditions: ['league_id = @id'], substitutionValues: {'id': single.league!.id});
      broadcast(jsonEncode(manyToJson(
        leagueMatches,
        TeamMatch,
        CRUD.update,
        isRaw: false,
        filterType: League,
        filterId: single.league!.id,
      )));
    }
  } else if (single is TeamMatchBout) {
    broadcast(jsonEncode(manyToJson(
        await TeamMatchBoutController()
            .getMany(conditions: ['team_match_id = @id'], substitutionValues: {'id': single.teamMatch.id}),
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
    // SpecialCase: the full Club list has to be updated, shouldn't occur often
    broadcast(jsonEncode(manyToJson(await ClubController().getManyRaw(), Club, CRUD.update, isRaw: true)));
  } else if (T == BoutConfig) {
  } else if (T == Bout) {
  } else if (T == BoutAction) {
    broadcast(jsonEncode(manyToJson(
        await BoutActionController()
            .getManyRaw(conditions: ['bout_id = @id'], substitutionValues: {'id': single['bout_id']}),
        BoutAction,
        CRUD.update,
        isRaw: true,
        filterType: Bout,
        filterId: single['bout_id'])));
  } else if (T == Organization) {
    // SpecialCase: the full Organization list has to be updated with no filter, shouldn't occur often
    broadcast(
        jsonEncode(manyToJson(await OrganizationController().getManyRaw(), Organization, CRUD.update, isRaw: true)));
  } else if (T == Division) {
    // TODO
  } else if (T == League) {
  } else if (T == DivisionWeightClass) {
    broadcast(jsonEncode(manyToJson(
        await DivisionWeightClassController()
            .getManyRaw(conditions: ['division_id = @id'], substitutionValues: {'id': single['division_id']}),
        DivisionWeightClass,
        CRUD.update,
        isRaw: true,
        filterType: Division,
        filterId: single['division_id'])));
  } else if (T == LeagueTeamParticipation) {
    final leagueTeamParticipationController = LeagueTeamParticipationController();
    broadcast(jsonEncode(manyToJson(
        await leagueTeamParticipationController
            .getManyRaw(conditions: ['league_id = @id'], substitutionValues: {'id': single['league_id']}),
        LeagueTeamParticipation,
        CRUD.update,
        isRaw: true,
        filterType: League,
        filterId: single['league_id'])));
    broadcast(jsonEncode(manyToJson(
        await leagueTeamParticipationController
            .getManyRaw(conditions: ['team_id = @id'], substitutionValues: {'id': single['team_id']}),
        LeagueTeamParticipation,
        CRUD.update,
        isRaw: true,
        filterType: Team,
        filterId: single['team_id'])));
  } else if (T == Lineup) {
    // No filtered list needs to be handled.
  } else if (T == Membership) {
    broadcast(jsonEncode(manyToJson(
        await MembershipController()
            .getManyRaw(conditions: ['club_id = @id'], substitutionValues: {'id': single['club_id']}),
        Membership,
        CRUD.update,
        isRaw: true,
        filterType: Club,
        filterId: single['club_id'])));
  } else if (T == Participation) {
    broadcast(jsonEncode(manyToJson(
        await ParticipationController()
            .getManyRaw(conditions: ['lineup_id = @id'], substitutionValues: {'id': single['lineup_id']}),
        Participation,
        CRUD.update,
        isRaw: true,
        filterType: Lineup,
        filterId: single['lineup_id'])));
  } else if (T == ParticipantState) {
  } else if (T == Person) {
    // No filtered list needs to be handled.
  } else if (T == Team) {
    broadcast(jsonEncode(manyToJson(
        await TeamController().getManyRaw(conditions: ['club_id = @id'], substitutionValues: {'id': single['club_id']}),
        Team,
        CRUD.update,
        isRaw: true,
        filterType: Club,
        filterId: single['club_id'])));
  } else if (T == TeamMatch) {
    final teamMatchController = TeamMatchController();

    final homeTeamId = (await EntityController.query(await LineupController.teamIdStmt,
        substitutionValues: {'id': single['home_id']}))['team_id'];
    final homeMatches = await teamMatchController
        .getManyRawFromQuery(TeamController.teamMatchesQuery, substitutionValues: {'id': homeTeamId});
    broadcast(jsonEncode(
        manyToJson(homeMatches, TeamMatch, CRUD.update, isRaw: true, filterType: Team, filterId: homeTeamId)));

    final guestTeamId = (await EntityController.query(await LineupController.teamIdStmt,
        substitutionValues: {'id': single['guest_id']}))['team_id'];
    final guestMatches = await teamMatchController
        .getManyRawFromQuery(TeamController.teamMatchesQuery, substitutionValues: {'id': guestTeamId});
    broadcast(jsonEncode(
        manyToJson(guestMatches, TeamMatch, CRUD.update, isRaw: true, filterType: Team, filterId: guestTeamId)));

    if (single['league_id'] != null) {
      final leagueMatches = await teamMatchController
          .getManyRaw(conditions: ['league_id = @id'], substitutionValues: {'id': single['league_id']});
      broadcast(jsonEncode(manyToJson(
        leagueMatches,
        TeamMatch,
        CRUD.update,
        isRaw: true,
        filterType: League,
        filterId: single['league_id'],
      )));
    }
  } else if (T == TeamMatchBout) {
    broadcast(jsonEncode(manyToJson(
        await TeamMatchBoutController()
            .getManyRaw(conditions: ['team_match_id = @id'], substitutionValues: {'id': single['team_match_id']}),
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

Future<int> handleSingle<T extends DataObject>({required CRUD operation, required T single}) async {
  print('${DateTime.now()} ${operation.name.toUpperCase()} ${single.tableName}/${single.id}');
  final controller = EntityController.getControllerFromDataType(T);
  if (operation == CRUD.update) {
    await controller.updateSingle(single);
    broadcast(jsonEncode(singleToJson(single, T, operation)));
  } else if (operation == CRUD.create) {
    single = single.copyWithId(await controller.createSingle(single)) as T;
  } else if (operation == CRUD.delete) {
    await controller.deleteSingle(single.id!);
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

Future<int> handleSingleRaw<T extends DataObject>(
    {required CRUD operation, required Map<String, dynamic> single}) async {
  print('${DateTime.now()} ${operation.name.toUpperCase()} ${getTableNameFromType(T)}/${single['id']}');
  final controller = EntityController.getControllerFromDataType(T);
  if (operation == CRUD.update) {
    await controller.updateSingleRaw(single);
    broadcast(jsonEncode(singleToJson(single, T, operation)));
  } else if (operation == CRUD.create) {
    single['id'] = await controller.createSingleRaw(single);
  } else if (operation == CRUD.delete) {
    await controller.deleteSingle(single['id']);
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

Future<void> handleMany<T extends DataObject>({required CRUD operation, required ManyDataObject<T> many}) {
  print('${DateTime.now()} ${operation.name.toUpperCase()} ${getTableNameFromType(T)}s');
  throw DataUnimplementedError(operation, many.runtimeType);
}

Future<void> handleManyRaw<T extends DataObject>(
    {required CRUD operation, required ManyDataObject<Map<String, dynamic>> many}) {
  print('${DateTime.now()} ${operation.name.toUpperCase()} ${getTableNameFromType(T)}s');
  throw DataUnimplementedError(operation, many.runtimeType);
}

final websocketHandler = webSocketHandler(
  (WebSocketChannel webSocket) {
    webSocketPool.add(webSocket);
    webSocket.stream.listen((message) {
      final json = jsonDecode(message);
      handleFromJson(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    }, onDone: () {
      webSocketPool.remove(webSocket);
    });
  },
  pingInterval: Duration(seconds: int.parse(env['WEB_SOCKET_PING_INTERVAL_SECS'] ?? '30')),
);
