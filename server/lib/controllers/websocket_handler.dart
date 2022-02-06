import 'dart:collection';
import 'dart:convert';

import 'package:common/common.dart';
import 'package:server/controllers/club_controller.dart';
import 'package:server/controllers/fight_action_controller.dart';
import 'package:server/controllers/league_controller.dart';
import 'package:server/controllers/lineup_controller.dart';
import 'package:server/controllers/participation_controller.dart';
import 'package:server/controllers/team_controller.dart';
import 'package:server/controllers/team_match_controller.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'entity_controller.dart';

final Set<WebSocketChannel> webSocketPool = HashSet();

void broadcast(String data) {
  for (var element in webSocketPool) {
    element.sink.add(data);
  }
}

// Currently do not update list of all entities (as is and should not used anywhere)
// Update doesn't need to update lists, it should only be also listened to the object itself, which gets an update event
void broadcastSingle<T extends DataObject>(T single) async {
  if (single is Participation) {
    broadcast(jsonEncode(manyToJson(
        await ParticipationController()
            .getMany(conditions: ['lineup_id = @id'], substitutionValues: {'id': single.lineup.id}),
        Participation,
        CRUD.update,
        filterType: Lineup,
        filterId: single.lineup.id)));
  } else if (single is Lineup) {
    // No filtered list needs to be handled.
  } else if (single is Club) {
    // Exception: the full Club list has to be updated, shouldn't occur often
    broadcast(jsonEncode(manyToJson(await ClubController().getMany(), Club, CRUD.update)));
  } else if (single is League) {
    // Exception: the full League list has to be updated, shouldn't occur often
    broadcast(jsonEncode(manyToJson(await LeagueController().getMany(), League, CRUD.update)));
  } else if (single is FightAction) {
    broadcast(jsonEncode(manyToJson(
        await FightActionController()
            .getMany(conditions: ['fight_id = @id'], substitutionValues: {'id': single.fight.id}),
        FightAction,
        CRUD.update,
        filterType: Fight,
        filterId: single.fight.id)));
  } else if (single is Team) {
    broadcast(jsonEncode(manyToJson(
        await TeamController().getMany(conditions: ['club_id = @id'], substitutionValues: {'id': single.club.id}),
        Team,
        CRUD.update,
        filterType: Club,
        filterId: single.club.id)));
    if (single.league != null) {
      broadcast(jsonEncode(manyToJson(
          await TeamController()
              .getMany(conditions: ['league_id = @id'], substitutionValues: {'id': single.league!.id}),
          Team,
          CRUD.update,
          filterType: League,
          filterId: single.league!.id)));
    }
  } else if (single is TeamMatch) {
    final homeMatches = await TeamMatchController()
        .getManyFromQuery(TeamController.teamMatchesQuery, substitutionValues: {'id': single.home.team.id});

    final guestMatches = await TeamMatchController()
        .getManyFromQuery(TeamController.teamMatchesQuery, substitutionValues: {'id': single.guest.team.id});

    broadcast(
        jsonEncode(manyToJson(homeMatches, TeamMatch, CRUD.update, filterType: Team, filterId: single.home.team.id)));
    broadcast(
        jsonEncode(manyToJson(guestMatches, TeamMatch, CRUD.update, filterType: Team, filterId: single.guest.team.id)));
  } else if (single is WeightClass) {
    // TODO Broadcast to every league, which uses the same weightClasses
    // broadcast(jsonEncode(manyToJson(
    //     await LeagueController().getWeightClasses(single.id}),
    //     WeightClass,
    //     CRUD.update,
    //     filterType: League,
    //     filterId: single.league.id)));
  } else {
    throw DataUnimplementedError(CRUD.update, single.runtimeType);
  }
}

void broadcastSingleRaw<T extends DataObject>(Map<String, dynamic> single) async {
  if (T == Participation) {
    broadcast(jsonEncode(manyToJson(
        await ParticipationController()
            .getManyRaw(conditions: ['lineup_id = @id'], substitutionValues: {'id': single['lineup_id']}),
        Participation,
        CRUD.update,
        filterType: Lineup,
        filterId: single['lineup_id'])));
  } else if (T == Lineup) {
    // No filtered list needs to be handled.
  } else if (T == Club) {
    // Exception: the full Club list has to be updated, shouldn't occur often
    broadcast(jsonEncode(manyToJson(await ClubController().getManyRaw(), Club, CRUD.update)));
  } else if (T == League) {
    // Exception: the full League list has to be updated, shouldn't occur often
    broadcast(jsonEncode(manyToJson(await LeagueController().getManyRaw(), League, CRUD.update)));
  } else if (T == FightAction) {
    broadcast(jsonEncode(manyToJson(
        await FightActionController()
            .getManyRaw(conditions: ['fight_id = @id'], substitutionValues: {'id': single['fight_id']}),
        FightAction,
        CRUD.update,
        filterType: Fight,
        filterId: single['fight_id'])));
  } else if (T == Team) {
    broadcast(jsonEncode(manyToJson(
        await TeamController().getManyRaw(conditions: ['club_id = @id'], substitutionValues: {'id': single['club_id']}),
        Team,
        CRUD.update,
        filterType: Club,
        filterId: single['club_id'])));
    if (single['league_id'] != null) {
      broadcast(jsonEncode(manyToJson(
          await TeamController()
              .getManyRaw(conditions: ['league_id = @id'], substitutionValues: {'id': single['league_id']}),
          Team,
          CRUD.update,
          filterType: League,
          filterId: single['league_id'])));
    }
  } else if (T == TeamMatch) {
    final homeTeamId = (await EntityController.query(LineupController.teamIdQuery,
        substitutionValues: {'id': single['home_id']}))['team_id'];
    final guestTeamId = (await EntityController.query(LineupController.teamIdQuery,
        substitutionValues: {'id': single['guest_id']}))['team_id'];
    final homeMatches = await TeamMatchController()
        .getManyRawFromQuery(TeamController.teamMatchesQuery, substitutionValues: {'id': homeTeamId});

    final guestMatches = await TeamMatchController()
        .getManyRawFromQuery(TeamController.teamMatchesQuery, substitutionValues: {'id': guestTeamId});

    broadcast(jsonEncode(manyToJson(homeMatches, TeamMatch, CRUD.update, filterType: Team, filterId: homeTeamId)));
    broadcast(jsonEncode(manyToJson(guestMatches, TeamMatch, CRUD.update, filterType: Team, filterId: guestTeamId)));
  } else if (T == WeightClass) {
    // TODO get from broadcastSingle
  } else {
    throw DataUnimplementedError(CRUD.update, single.runtimeType);
  }
}

Future<int> handleSingle<T extends DataObject>({required CRUD operation, required T single}) async {
  print('${DateTime.now()} ${operation.name.toUpperCase()} ${single.tableName}/${single.id}');
  final controller = EntityController.getControllerFromDataType<T>();
  if (operation == CRUD.update) {
    await controller.updateSingle(single);
    broadcast(jsonEncode(singleToJson(single, single.runtimeType, operation)));
  } else if (operation == CRUD.create) {
    single.id = await controller.createSingle(single);
  } else if (operation == CRUD.delete) {
    await controller.deleteSingle(single.id!);
  }
  if (operation == CRUD.create || operation == CRUD.delete) {
    broadcastSingle<T>(single);
  }
  return single.id!;
}

Future<int> handleSingleRaw<T extends DataObject>(
    {required CRUD operation, required Map<String, dynamic> single}) async {
  print('${DateTime.now()} ${operation.name.toUpperCase()} ${getTableNameFromType(T)}/${single['id']}');
  final controller = EntityController.getControllerFromDataType<T>();
  if (operation == CRUD.update) {
    await controller.updateSingleRaw(single);
    broadcast(jsonEncode(singleToJson(single, single.runtimeType, operation)));
  } else if (operation == CRUD.create) {
    single['id'] = await controller.createSingleRaw(single);
  } else if (operation == CRUD.delete) {
    await controller.deleteSingle(single['id']);
  }
  if (operation == CRUD.create || operation == CRUD.delete) {
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

final websocketHandler = webSocketHandler((WebSocketChannel webSocket) {
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
});
