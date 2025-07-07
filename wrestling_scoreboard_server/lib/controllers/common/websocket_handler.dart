import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/club_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_club_affiliation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/routes/data_object_relations.dart';
import 'package:wrestling_scoreboard_server/services/auth.dart';
import 'package:wrestling_scoreboard_server/services/environment.dart';

final _logger = Logger('Websocket');

final Map<WebSocketChannel, UserPrivilege> webSocketPool = <WebSocketChannel, UserPrivilege>{};

void broadcast(Future<String?> Function(bool obfuscate) builder) async {
  final futureData = builder(false);
  final futureObfuscatedData = builder(true);

  futureData.then((value) => _logger.finest('Broadcast: $value'));

  // Use map to perform asynchronously
  await Future.wait(
    webSocketPool.entries.map((poolEntry) async {
      // Send obfuscated data to users with no read privilege
      if (poolEntry.value <= UserPrivilege.none) {
        final obfuscatedData = await futureObfuscatedData;
        if (obfuscatedData != null) {
          poolEntry.key.sink.add(obfuscatedData);
        }
      } else {
        final data = await futureData;
        if (data != null) {
          poolEntry.key.sink.add(data);
        }
      }
    }),
  );
}

/// Update filtered lists (often the list they are contained in).
/// Currently do not update list of all entities (as it should only be used in special cases)
void broadcastDependants<T extends DataObject>(T single) async {
  directDataObjectRelations[T]?.forEach((propertyType, propertyConfig) {
    final (propertyTableRef, orderBy) = propertyConfig;
    broadcast((obfuscate) async {
      return _updateInListOfFilter(single, propertyType, propertyTableRef, orderBy, obfuscate);
    });
  });

  if (single is Bout) {
    // Update the competition bout, if its bout has changed, but only if the a result is present.
    if (single.result != null) {
      broadcast(
        (obfuscate) async => jsonEncode(
          manyToJson(
            await CompetitionBoutController().getMany(
              conditions: ['bout_id = @id'],
              substitutionValues: {'id': single.id},
              obfuscate: obfuscate,
            ),
            CompetitionBout,
            CRUD.update,
            isRaw: false,
            filterType: Bout,
            filterId: single.id,
          ),
        ),
      );
      final competitionBout =
          (await CompetitionBoutController().getMany(
            conditions: ['bout_id = @id'],
            substitutionValues: {'id': single.id},
            obfuscate: false,
          )).zeroOrOne;
      // Update the results in the according weight category
      if (competitionBout?.weightCategory != null) {
        broadcast((obfuscate) async {
          return jsonEncode(
            manyToJson(
              await CompetitionBoutController().getMany(
                conditions: ['weight_category_id = @id'],
                substitutionValues: {'id': competitionBout!.weightCategory?.id},
                obfuscate: obfuscate,
              ),
              CompetitionBout,
              CRUD.update,
              isRaw: false,
              filterType: CompetitionWeightCategory,
              filterId: competitionBout.weightCategory?.id,
            ),
          );
        });
      }
    }
  } else if (single is Club) {
    broadcast(
      (obfuscate) async => jsonEncode(
        manyToJson(
          await ClubController().getMany(
            conditions: ['organization_id = @id'],
            substitutionValues: {'id': single.organization.id},
            obfuscate: obfuscate,
          ),
          Club,
          CRUD.update,
          isRaw: false,
          filterType: Organization,
          filterId: single.organization.id,
        ),
      ),
    );
  } else if (single is Organization) {
    // SpecialCase: the full Organization list has to be updated with no filter, shouldn't occur often
    broadcast(
      (obfuscate) async => jsonEncode(
        manyToJson(
          await OrganizationController().getMany(obfuscate: obfuscate),
          Organization,
          CRUD.update,
          isRaw: false,
        ),
      ),
    );
  } else if (single is SecuredUser) {
    // SpecialCase: the full User list has to be updated with no filter, shouldn't occur often
    // TODO: Don't broadcast to people with no admin access
    /*broadcast((obfuscate) async => jsonEncode(manyToJson(
        await SecuredUserController().getManyRaw(obfuscate: obfuscate), Organization, CRUD.update,
        isRaw: true)));*/
  } else if (single is TeamClubAffiliation) {
    broadcast(
      (obfuscate) async => jsonEncode(
        manyToJson(
          (await TeamClubAffiliationController().getMany(
            conditions: ['club_id = @id'],
            substitutionValues: {'id': single.club.id},
            obfuscate: obfuscate,
          )).map((tca) => tca.team).toList(),
          Team,
          CRUD.update,
          isRaw: false,
          filterType: Club,
          filterId: single.club.id,
        ),
      ),
    );

    broadcast(
      (obfuscate) async => jsonEncode(
        manyToJson(
          (await TeamClubAffiliationController().getMany(
            conditions: ['team_id = @id'],
            substitutionValues: {'id': single.team.id},
            obfuscate: obfuscate,
          )).map((tca) => tca.club).toList(),
          Club,
          CRUD.update,
          isRaw: false,
          filterType: Team,
          filterId: single.team.id,
        ),
      ),
    );
  } else if (single is TeamMatch) {
    final teamMatchController = TeamMatchController();

    broadcast((obfuscate) async {
      final homeMatches = await teamMatchController.getManyFromQuery(
        TeamController.teamMatchesQuery,
        substitutionValues: {'id': single.home.team.id},
        obfuscate: obfuscate,
      );
      return jsonEncode(
        manyToJson(homeMatches, TeamMatch, CRUD.update, isRaw: false, filterType: Team, filterId: single.home.team.id),
      );
    });

    broadcast((obfuscate) async {
      final guestMatches = await teamMatchController.getManyFromQuery(
        TeamController.teamMatchesQuery,
        substitutionValues: {'id': single.guest.team.id},
        obfuscate: obfuscate,
      );
      return jsonEncode(
        manyToJson(
          guestMatches,
          TeamMatch,
          CRUD.update,
          isRaw: false,
          filterType: Team,
          filterId: single.guest.team.id,
        ),
      );
    });
  }
}

// Updates the filtered list, where the dataObject is contained.
Future<String?> _updateInListOfFilter<T extends DataObject>(
  T dataObject,
  Type filterType,
  String propertyTableName,
  List<String> orderBy,
  bool obfuscate,
) async {
  // TODO: Check whether this is performant enough:
  final propertyId = dataObject.toRaw()[propertyTableName];
  if (propertyId == null) return null;
  return jsonEncode(
    manyToJson(
      await ShelfController.getControllerFromDataType(T)!.getMany(
        conditions: ['$propertyTableName = @id'],
        substitutionValues: {'id': propertyId},
        orderBy: orderBy,
        obfuscate: obfuscate,
      ),
      T,
      CRUD.update,
      isRaw: false,
      filterType: filterType,
      filterId: propertyId,
    ),
  );
}

void broadcastDependantsRaw<T extends DataObject>(Map<String, dynamic> single) async {
  directDataObjectRelations[T]?.forEach((propertyType, propertyConfig) {
    final (propertyTableRef, orderBy) = propertyConfig;
    broadcast(
      (obfuscate) async => _updateRawInListOfFilter(T, single, propertyType, propertyTableRef, orderBy, obfuscate),
    );
  });

  if (T == Organization) {
    // SpecialCase: the full Organization list has to be updated with no filter, shouldn't occur often
    broadcast(
      (obfuscate) async => jsonEncode(
        manyToJson(
          await OrganizationController().getManyRaw(obfuscate: obfuscate),
          Organization,
          CRUD.update,
          isRaw: true,
        ),
      ),
    );
  } else if (T == TeamClubAffiliation) {
    broadcast(
      (obfuscate) async => jsonEncode(
        manyToJson(
          (await TeamClubAffiliationController().getMany(
            conditions: ['club_id = @id'],
            substitutionValues: {'id': single['club_id']},
            obfuscate: obfuscate,
          )).map((tca) => tca.team.toRaw()).toList(),
          Team,
          CRUD.update,
          isRaw: true,
          filterType: Club,
          filterId: single['club_id'],
        ),
      ),
    );

    broadcast(
      (obfuscate) async => jsonEncode(
        manyToJson(
          (await TeamClubAffiliationController().getMany(
            conditions: ['team_id = @id'],
            substitutionValues: {'id': single['team_id']},
            obfuscate: obfuscate,
          )).map((tca) => tca.club.toRaw()).toList(),
          Club,
          CRUD.update,
          isRaw: true,
          filterType: Team,
          filterId: single['team_id'],
        ),
      ),
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
    broadcast(
      (obfuscate) async => jsonEncode(
        manyToJson(homeMatches, TeamMatch, CRUD.update, isRaw: true, filterType: Team, filterId: homeTeamId),
      ),
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
    broadcast(
      (obfuscate) async => jsonEncode(
        manyToJson(guestMatches, TeamMatch, CRUD.update, isRaw: true, filterType: Team, filterId: guestTeamId),
      ),
    );
  }
}

// Updates the filtered list, where the raw dataObject is contained.
Future<String?> _updateRawInListOfFilter<F extends DataObject>(
  Type dataType,
  Map<String, dynamic> single,
  Type filterType,
  String propertyTableName,
  List<String> orderBy,
  bool obfuscate,
) async {
  final propertyId = single[propertyTableName];
  if (propertyId == null) return null;
  return jsonEncode(
    manyToJson(
      await ShelfController.getControllerFromDataType(dataType)!.getManyRaw(
        orderBy: orderBy,
        conditions: ['$propertyTableName = @id'],
        substitutionValues: {'id': propertyId},
        obfuscate: obfuscate,
      ),
      dataType,
      CRUD.update,
      isRaw: true,
      filterType: filterType,
      filterId: propertyId,
    ),
  );
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
  _logger.fine('${DateTime.now()} ${operation.name.toUpperCase()} ${getTableNameFromType(T)}/${single['id']}');
  final controller = ShelfController.getControllerFromDataType(T);
  if (operation == CRUD.update) {
    if (privilege < UserPrivilege.write) {
      throw Exception('Not allowed to perform update operation on ${getTableNameFromType(T)}/${single['id']}');
    }
    await controller!.updateSingleRaw(single);
    broadcast((obfuscate) async {
      // Need to provide an obfuscated version of the dataObject, but can reuse the `single` object for non obfuscated broadcast, to raise performance
      return jsonEncode(
        singleToJson(obfuscate ? await controller.getSingleRaw(single['id'], obfuscate: true) : single, T, operation),
      );
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

final websocketHandler = webSocketHandler((WebSocketChannel webSocket, String? subProtocol) {
  UserPrivilege privilege = UserPrivilege.none;
  webSocketPool[webSocket] = privilege;
  webSocket.stream.listen(
    (message) async {
      final json = jsonDecode(message);
      if (json['authorization'] != null) {
        final authService = BearerAuthService.fromHeader(json['authorization']);
        final user = await authService.getUser();
        privilege = user?.privilege ?? UserPrivilege.none;
        // Upgrade privilege
        webSocketPool[webSocket] = privilege;
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
    },
  );
}, pingInterval: Duration(seconds: env.webSocketPingIntervalSecs ?? 30));
