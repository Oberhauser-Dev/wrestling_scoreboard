import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_club_affiliation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/user_controller.dart';
import 'package:wrestling_scoreboard_server/routes/data_object_relations.dart';
import 'package:wrestling_scoreboard_server/services/auth.dart';
import 'package:wrestling_scoreboard_server/services/environment.dart';

final _logger = Logger('Websocket');

final Map<WebSocketChannel, User?> webSocketPool = <WebSocketChannel, User?>{};

void _broadcast(Future<String> Function(bool obfuscate) builder, {required UserPrivilege requiredPrivilege}) async {
  // We only build and assign the values, if one is actually subscribed and has the permission to read it.
  Future<String>? futureData;
  Future<String>? futureObfuscatedData;

  Future<String> buildData() {
    if (futureData != null) return futureData!;
    futureData = builder(false);
    futureData!.then((value) => _logger.finest('Broadcast: $value'));
    return futureData!;
  }

  Future<String> buildObfuscatedData() {
    if (futureObfuscatedData != null) return futureObfuscatedData!;
    futureObfuscatedData = builder(true);
    return futureObfuscatedData!;
  }

  // Use map to perform asynchronously
  await Future.wait(
    webSocketPool.entries.map(
      (poolEntry) => _addDataToWsChannel(
        channel: poolEntry.key,
        userPrivilege: poolEntry.value?.privilege ?? UserPrivilege.none,
        buildData: buildData,
        buildObfuscatedData: buildObfuscatedData,
        requiredPrivilege: requiredPrivilege,
      ),
    ),
  );
}

Future<void> _addDataToWsChannel({
  required WebSocketChannel channel,
  required UserPrivilege userPrivilege,
  required UserPrivilege requiredPrivilege,
  required Future<String> Function() buildData,
  required Future<String> Function() buildObfuscatedData,
}) async {
  // Avoid sending data if not having the permission.
  if (userPrivilege < requiredPrivilege) {
    return;
  }

  // Send obfuscated data to users with no read privilege
  if (userPrivilege <= UserPrivilege.none) {
    channel.sink.add(await buildObfuscatedData());
  } else {
    channel.sink.add(await buildData());
  }
}

void _unicast(
  Future<String> Function(bool obfuscate) builder, {
  required User user,
  required UserPrivilege requiredPrivilege,
}) {
  final entry = webSocketPool.entries.singleWhereOrNull((element) => element.value?.id == user.id);
  if (entry != null) {
    _addDataToWsChannel(
      channel: entry.key,
      userPrivilege: entry.value?.privilege ?? UserPrivilege.none,
      buildData: () => builder(false),
      buildObfuscatedData: () => builder(true),
      requiredPrivilege: requiredPrivilege,
    );
  }
}

void unicastUpdateSingle<T extends DataObject>(Future<T> Function(bool obfuscate) builder, {required User user}) {
  _unicast(
    (obfuscate) async => jsonEncode(singleToJson(await builder(obfuscate), T, CRUD.update)),
    user: user,
    requiredPrivilege: ShelfController.getControllerFromDataType(T)!.controllerPrivilege,
  );
}

void broadcastUpdateSingle<T extends DataObject>(Future<T> Function(bool obfuscate) builder) {
  _broadcast(
    (obfuscate) async => jsonEncode(singleToJson(await builder(obfuscate), T, CRUD.update)),
    requiredPrivilege: ShelfController.getControllerFromDataType(T)!.controllerPrivilege,
  );
}

void broadcastUpdateMany<T extends DataObject>(
  Future<List<T>> Function(bool obfuscate) builder, {
  Type? filterType,
  int? filterId,
}) {
  _broadcast(
    (obfuscate) async => jsonEncode(
      manyToJson(await builder(obfuscate), T, CRUD.update, isRaw: false, filterType: filterType, filterId: filterId),
    ),
    requiredPrivilege: ShelfController.getControllerFromDataType(T)!.controllerPrivilege,
  );
}

void broadcastUpdateManyRaw(
  Future<List<Map<String, dynamic>>> Function(bool obfuscate) builder, {
  required Type dataType,
  Type? filterType,
  int? filterId,
}) {
  _broadcast(
    (obfuscate) async => jsonEncode(
      manyToJson(
        await builder(obfuscate),
        dataType,
        CRUD.update,
        isRaw: true,
        filterType: filterType,
        filterId: filterId,
      ),
    ),
    requiredPrivilege: ShelfController.getControllerFromDataType(dataType)!.controllerPrivilege,
  );
}

// Updates the filtered list, where the dataObject is contained.
void _broadcastUpdateManyInListOfFilter<T extends DataObject>(
  T dataObject, {
  Type? filterType,
  String? propertyTableRef,
  List<String> orderBy = const [],
}) {
  if (filterType == null || propertyTableRef == null) {
    broadcastUpdateMany<T>(
      (obfuscate) async => await EntityController.getManyFromDataType<T>(orderBy: orderBy, obfuscate: obfuscate),
    );
  }
  // TODO: Check whether this is performant enough:
  final propertyId = dataObject.toRaw()[propertyTableRef];
  if (propertyId == null) return;
  broadcastUpdateMany<T>(
    (obfuscate) async => await EntityController.getManyFromDataType<T>(
      orderBy: orderBy,
      conditions: ['$propertyTableRef = @id'],
      substitutionValues: {'id': propertyId},
      obfuscate: obfuscate,
    ),
    filterType: filterType,
    filterId: propertyId,
  );
}

// Updates the filtered list, where the raw dataObject is contained.
void _broadcastUpdateManyRawInListOfFilter(
  Type dataType,
  Map<String, dynamic> single,
  Type filterType,
  String propertyTableRef,
  List<String> orderBy,
) async {
  final propertyId = single[propertyTableRef];
  if (propertyId == null) return null;
  return broadcastUpdateManyRaw(
    (obfuscate) async => await ShelfController.getControllerFromDataType(dataType)!.getManyRaw(
      orderBy: orderBy,
      conditions: ['$propertyTableRef = @id'],
      substitutionValues: {'id': propertyId},
      obfuscate: obfuscate,
    ),
    dataType: dataType,
    filterType: filterType,
    filterId: propertyId,
  );
}

/// Update filtered lists (often the list they are contained in).
/// Currently do not update list of all entities (as it should only be used in special cases)
void broadcastDependants<T extends DataObject>(T single) async {
  directDataObjectRelations[T]?.forEach((propertyType, propertyConfigs) {
    for (final config in propertyConfigs) {
      _broadcastUpdateManyInListOfFilter(
        single,
        filterType: propertyType,
        propertyTableRef: config.property,
        orderBy: config.orderBy,
      );
    }
  });

  if (single is Bout) {
    // Update the competition bout, if its bout has changed, but only if the a result is present.
    if (single.result != null) {
      broadcastUpdateMany<CompetitionBout>(
        (obfuscate) async => await CompetitionBoutController().getMany(
          conditions: ['bout_id = @id'],
          substitutionValues: {'id': single.id},
          obfuscate: obfuscate,
        ),
        filterType: Bout,
        filterId: single.id,
      );
      final competitionBout =
          (await CompetitionBoutController().getMany(
            conditions: ['bout_id = @id'],
            substitutionValues: {'id': single.id},
            obfuscate: false,
          )).zeroOrOne;
      // Update the results in the according weight category
      if (competitionBout?.weightCategory != null) {
        broadcastUpdateMany(
          (obfuscate) async {
            return await CompetitionBoutController().getMany(
              conditions: ['weight_category_id = @id'],
              substitutionValues: {'id': competitionBout!.weightCategory?.id},
              obfuscate: obfuscate,
            );
          },
          filterType: CompetitionWeightCategory,
          filterId: competitionBout?.weightCategory?.id,
        );
      }
    }
  } else if (single is Organization) {
    // SpecialCase: the full Organization list has to be updated with no filter, shouldn't occur often
    _broadcastUpdateManyInListOfFilter(single);
  } else if (single is SecuredUser) {
    // SpecialCase: the full User list has to be updated with no filter, shouldn't occur often
    _broadcastUpdateManyInListOfFilter(single);
  } else if (single is TeamClubAffiliation) {
    broadcastUpdateMany<Team>(
      (obfuscate) async =>
          (await TeamClubAffiliationController().getMany(
            conditions: ['club_id = @id'],
            substitutionValues: {'id': single.club.id},
            obfuscate: obfuscate,
          )).map((tca) => tca.team).toList(),
      filterType: Club,
      filterId: single.club.id,
    );

    broadcastUpdateMany<Club>(
      (obfuscate) async =>
          (await TeamClubAffiliationController().getMany(
            conditions: ['team_id = @id'],
            substitutionValues: {'id': single.team.id},
            obfuscate: obfuscate,
          )).map((tca) => tca.club).toList(),
      filterType: Team,
      filterId: single.team.id,
    );
  } else if (single is TeamMatch) {
    final teamMatchController = TeamMatchController();

    broadcastUpdateMany<TeamMatch>(
      (obfuscate) async {
        final homeMatches = await teamMatchController.getManyFromQuery(
          TeamController.teamMatchesQuery,
          substitutionValues: {'id': single.home.team.id},
          obfuscate: obfuscate,
        );
        return homeMatches;
      },
      filterType: Team,
      filterId: single.home.team.id,
    );

    broadcastUpdateMany<TeamMatch>(
      (obfuscate) async {
        final guestMatches = await teamMatchController.getManyFromQuery(
          TeamController.teamMatchesQuery,
          substitutionValues: {'id': single.guest.team.id},
          obfuscate: obfuscate,
        );
        return guestMatches;
      },
      filterType: Team,
      filterId: single.guest.team.id,
    );
  }
}

void broadcastDependantsRaw<T extends DataObject>(Map<String, dynamic> single) async {
  directDataObjectRelations[T]?.forEach((propertyType, propertyConfigs) {
    for (final config in propertyConfigs) {
      _broadcastUpdateManyRawInListOfFilter(T, single, propertyType, config.property, config.orderBy);
    }
  });

  if (T == Organization) {
    // SpecialCase: the full Organization list has to be updated with no filter, shouldn't occur often
    broadcastUpdateManyRaw(
      (obfuscate) async => await OrganizationController().getManyRaw(obfuscate: obfuscate),
      dataType: Organization,
    );
  } else if (T == SecuredUser) {
    // SpecialCase: the full User list has to be updated with no filter, shouldn't occur often
    broadcastUpdateManyRaw(
      (obfuscate) async => await SecuredUserController().getManyRaw(obfuscate: obfuscate),
      dataType: SecuredUser,
    );
  } else if (T == TeamClubAffiliation) {
    broadcastUpdateManyRaw(
      (obfuscate) async =>
          (await TeamClubAffiliationController().getMany(
            conditions: ['club_id = @id'],
            substitutionValues: {'id': single['club_id']},
            obfuscate: obfuscate,
          )).map((tca) => tca.team.toRaw()).toList(),
      dataType: Team,
      filterType: Club,
      filterId: single['club_id'],
    );

    broadcastUpdateManyRaw(
      (obfuscate) async =>
          (await TeamClubAffiliationController().getMany(
            conditions: ['team_id = @id'],
            substitutionValues: {'id': single['team_id']},
            obfuscate: obfuscate,
          )).map((tca) => tca.club.toRaw()).toList(),
      dataType: Club,
      filterType: Team,
      filterId: single['team_id'],
    );
  } else if (T == TeamMatch) {
    final teamMatchController = TeamMatchController();

    final homeTeamId =
        (await EntityController.query(
          await TeamLineupController.teamIdStmt,
          substitutionValues: {'id': single['home_id']},
        ))['team_id'];
    final homeMatches = await teamMatchController.getManyRawFromQuery(
      TeamController.teamMatchesQuery,
      substitutionValues: {'id': homeTeamId},
    );
    broadcastUpdateManyRaw(
      (obfuscate) async => homeMatches,
      dataType: TeamMatch,
      filterType: Team,
      filterId: homeTeamId,
    );

    final guestTeamId =
        (await EntityController.query(
          await TeamLineupController.teamIdStmt,
          substitutionValues: {'id': single['guest_id']},
        ))['team_id'];
    final guestMatches = await teamMatchController.getManyRawFromQuery(
      TeamController.teamMatchesQuery,
      substitutionValues: {'id': guestTeamId},
    );
    broadcastUpdateManyRaw(
      (obfuscate) async => guestMatches,
      dataType: TeamMatch,
      filterType: Team,
      filterId: guestTeamId,
    );
  }
}

Future<int> handleSingle<T extends DataObject>({
  required CRUD operation,
  required T single,
  UserPrivilege privilege = UserPrivilege.write,
}) async {
  _logger.fine('${operation.name.toUpperCase()} ${single.tableName}/${single.id}');
  final controller = ShelfController.getControllerFromDataType(T);
  if (operation == CRUD.update) {
    if (privilege < UserPrivilege.write) {
      throw Exception('Not allowed to perform update operation on ${single.tableName}/${single.id}');
    }
    await controller!.updateSingle(single);
    _broadcast((obfuscate) async {
      // Need to provide an obfuscated version of the dataObject, but can reuse the `single` object for non obfuscated broadcast, to raise performance
      return jsonEncode(
        singleToJson(obfuscate ? await controller.getSingle(single.id!, obfuscate: true) : single, T, operation),
      );
    }, requiredPrivilege: controller.controllerPrivilege);
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
    broadcastDependants<T>(single);
  } else if (operation == CRUD.update &&
      (single is Bout /* Bout result changes ranking */ ||
          single is BoutAction /* Order of BoutAction changes */ ||
          single is CompetitionBout /* Mat changes in display */ )) {
    // Update nonetheless, if order of items has changed
    broadcastDependants<T>(single);
  }
  return single.id!;
}

Future<int> handleSingleRaw<T extends DataObject>({
  required CRUD operation,
  required Map<String, dynamic> single,
  UserPrivilege privilege = UserPrivilege.write,
}) async {
  _logger.fine('${operation.name.toUpperCase()} ${getTableNameFromType(T)}/${single['id']}');
  final controller = ShelfController.getControllerFromDataType(T);
  if (operation == CRUD.update) {
    if (privilege < UserPrivilege.write) {
      throw Exception('Not allowed to perform update operation on ${getTableNameFromType(T)}/${single['id']}');
    }
    await controller!.updateSingleRaw(single);
    _broadcast((obfuscate) async {
      // Need to provide an obfuscated version of the dataObject, but can reuse the `single` object for non obfuscated broadcast, to raise performance
      return jsonEncode(
        singleToJson(obfuscate ? await controller.getSingleRaw(single['id'], obfuscate: true) : single, T, operation),
      );
    }, requiredPrivilege: controller.controllerPrivilege);
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
    broadcastDependantsRaw<T>(single);
  } else if (operation == CRUD.update &&
      (T == BoutAction /* Order of BoutAction changes */ || T == CompetitionBout /* Mat changes in display */ )) {
    // Update nonetheless, if order of items has changed
    broadcastDependantsRaw<T>(single);
  }
  return single['id'];
}

Future<void> handleMany<T extends DataObject>({
  required CRUD operation,
  required ManyDataObject<T> many,
  UserPrivilege privilege = UserPrivilege.none,
}) {
  _logger.fine('${operation.name.toUpperCase()} ${getTableNameFromType(T)}s');
  throw DataUnimplementedError(operation, many.runtimeType);
}

Future<void> handleManyRaw<T extends DataObject>({
  required CRUD operation,
  required ManyDataObject<Map<String, dynamic>> many,
  UserPrivilege privilege = UserPrivilege.none,
}) {
  _logger.fine('${operation.name.toUpperCase()} ${getTableNameFromType(T)}s');
  throw DataUnimplementedError(operation, many.runtimeType);
}

final websocketHandler = webSocketHandler((WebSocketChannel webSocket, String? subProtocol) {
  _logger.fine('New websocket connection: ${webSocket.hashCode}');
  UserPrivilege privilege = UserPrivilege.none;
  webSocketPool[webSocket] = null;
  webSocket.stream.listen(
    (message) async {
      final json = jsonDecode(message);
      if (json['authorization'] != null) {
        final authService = BearerAuthService.fromHeader(json['authorization']);
        final user = await authService.getUser();
        // Upgrade user & privilege
        privilege = user?.privilege ?? UserPrivilege.none;
        webSocketPool[webSocket] = user;
        return;
      }
      await handleGenericJson(
        json,
        handleSingle:
            <T extends DataObject>({required CRUD operation, required T single}) async =>
                handleSingle<T>(operation: operation, single: single, privilege: privilege),
        handleMany:
            <T extends DataObject>({required CRUD operation, required ManyDataObject<T> many}) async =>
                handleMany<T>(operation: operation, many: many, privilege: privilege),
        handleSingleRaw:
            <T extends DataObject>({required CRUD operation, required Map<String, dynamic> single}) async =>
                handleSingleRaw<T>(operation: operation, single: single, privilege: privilege),
        handleManyRaw:
            <T extends DataObject>({
              required CRUD operation,
              required ManyDataObject<Map<String, dynamic>> many,
            }) async => handleManyRaw<T>(operation: operation, many: many, privilege: privilege),
      );
    },
    onDone: () {
      webSocketPool.remove(webSocket);
      _logger.fine(
        'Websocket connection done: ${webSocket.hashCode}, Code: ${webSocket.closeCode}, Reason: ${webSocket.closeReason}',
      );
    },
    onError: (err, st) {
      _logger.warning('Websocket connection error: ${webSocket.hashCode}', err, st);
    },
  );
}, pingInterval: Duration(seconds: env.webSocketPingIntervalSecs ?? 30));
