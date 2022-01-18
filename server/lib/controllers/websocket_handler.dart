import 'dart:collection';
import 'dart:convert';

import 'package:common/common.dart';
import 'package:server/controllers/club_controller.dart';
import 'package:server/controllers/league_controller.dart';
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
void broadcastSingle(DataObject single) async {
  /*webSocket.sink.add(jsonEncode(
        manyToJson(await EntityController.getControllerFromDataType(single.runtimeType).getMany(), operation)));*/
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

    broadcast(jsonEncode(manyToJson(homeMatches,
        TeamMatch,
        CRUD.update,
        filterType: Team,
        filterId: single.home.team.id)));
    broadcast(jsonEncode(manyToJson(
        guestMatches,
        TeamMatch,
        CRUD.update,
        filterType: Team,
        filterId: single.guest.team.id)));
  } else {
    throw DataUnimplementedError(CRUD.update, single.runtimeType);
  }
}

Future<int> handleSingle<T extends DataObject>({required CRUD operation, required T single}) async {
  print('${DateTime.now()} ${operation.name.toUpperCase()} ${single.tableName}/${single.id}');
  final controller = EntityController.getControllerFromDataType(single.runtimeType);
  if (operation == CRUD.update) {
    await controller.updateSingle(single);
    broadcast(jsonEncode(singleToJson(single, operation)));
  } else if (operation == CRUD.create) {
    single.id = await controller.createSingle(single);
  } else if (operation == CRUD.delete) {
    await controller.deleteSingle(single.id!);
  }
  if (operation == CRUD.create || operation == CRUD.delete) {
    broadcastSingle(single);
  }
  return single.id!;
}

Future<void> handleMany<T extends DataObject>({required CRUD operation, required ManyDataObject<T> many}) {
  print('${DateTime.now()} ${operation.name.toUpperCase()} ${getTableNameFromType(many.data.first.runtimeType)}s');
  throw DataUnimplementedError(operation, many.runtimeType);
}

final websocketHandler = webSocketHandler((WebSocketChannel webSocket) {
  webSocketPool.add(webSocket);
  webSocket.stream.listen((message) {
    final json = jsonDecode(message);
    handleFromJson(json, handleSingle, handleMany);
  }, onDone: () {
    webSocketPool.remove(webSocket);
  });
});
