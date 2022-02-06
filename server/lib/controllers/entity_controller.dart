import 'dart:convert';

import 'package:common/common.dart';
import 'package:postgres/postgres.dart';
import 'package:server/controllers/club_controller.dart';
import 'package:server/controllers/fight_action_controller.dart';
import 'package:server/controllers/fight_controller.dart';
import 'package:server/controllers/league_controller.dart';
import 'package:server/controllers/league_weight_class_controller.dart';
import 'package:server/controllers/lineup_controller.dart';
import 'package:server/controllers/membership_controller.dart';
import 'package:server/controllers/participant_state_controller.dart';
import 'package:server/controllers/participation_controller.dart';
import 'package:server/controllers/person_controller.dart';
import 'package:server/controllers/team_controller.dart';
import 'package:server/controllers/team_match_controller.dart';
import 'package:server/controllers/team_match_fight_controller.dart';
import 'package:server/controllers/tournament_controller.dart';
import 'package:server/controllers/websocket_handler.dart';
import 'package:server/controllers/weight_class_controller.dart';
import 'package:server/services/postgres_db.dart';
import 'package:shelf/shelf.dart';

Map<Type, PostgreSQLDataType> typeDartToCodeMap = {
  String: PostgreSQLDataType.varChar,
  // 'int2': PostgreSQLDataType.smallInteger,
  int: PostgreSQLDataType.integer,
  // 'int8': PostgreSQLDataType.bigInteger,
  // 'float4': PostgreSQLDataType.real,
  double: PostgreSQLDataType.double,
  bool: PostgreSQLDataType.boolean,
  DateTime: PostgreSQLDataType.date,
  // 'timestamp': PostgreSQLDataType.timestampWithoutTimezone,
  // 'timestamptz': PostgreSQLDataType.timestampWithTimezone,
  // 'interval': PostgreSQLDataType.interval,
  PgPoint: PostgreSQLDataType.point,
  // 'jsonb': PostgreSQLDataType.jsonb,
  // 'bytea': PostgreSQLDataType.byteArray,
  // 'name': PostgreSQLDataType.name,
  // 'uuid': PostgreSQLDataType.uuid,
  // 'json': PostgreSQLDataType.json,
  // 'point': PostgreSQLDataType.point,
  List<int>: PostgreSQLDataType.integerArray,
  List<String>: PostgreSQLDataType.textArray,
  List<double>: PostgreSQLDataType.doubleArray,
  // 'varchar': PostgreSQLDataType.varChar,
  // '_jsonb': PostgreSQLDataType.jsonbArray,
};

class PostgresMap {
  Map<String, dynamic> map;
  Map<String, PostgreSQLDataType?> types;

  PostgresMap(this.map, [this.types = const {}]);
}

abstract class EntityController<T extends DataObject> {
  String tableName;
  String primaryKeyName;

  EntityController({required this.tableName, this.primaryKeyName = 'id'});

  Future<Response> postSingle(Request request) async {
    return handlePostSingleOfController(this, await request.readAsString().then((message) => jsonDecode(message)));
  }

  Future<Response> requestSingle(Request request, String id) async {
    return handleRequestSingleOfController(this, int.parse(id), isRaw: isRaw(request));
  }

  Future<T?> getSingle(int id) async {
    final single = await getSingleRaw(id);
    if (single == null) return Future.value(null);
    return DataObject.fromRaw<T>(single, getSingleFromDataType);
  }

  Future<Map<String, dynamic>?> getSingleRaw(int id) async {
    final res = await PostgresDb()
        .connection
        .mappedResultsQuery('SELECT * FROM $tableName WHERE $primaryKeyName = @id;', substitutionValues: {'id': id});
    final many = mapToTable(res);
    if (many.isEmpty) return Future.value(null);
    return many.first;
  }

  Future<int> createSingle(T dataObject) async {
    dataObject.id = await createSingleRaw(dataObject.toRaw());
    return dataObject.id!;
  }

  Future<int> createSingleRaw(Map<String, dynamic> data) async {
    final postgresTypes = getPostgresDataTypes();
    final sql = '''
        INSERT INTO $tableName (${data.keys.join(',')}) 
        VALUES (${Map.of(data).entries.map((e) {
      final postgresType =
          postgresTypes.containsKey(e.key) ? postgresTypes[e.key] : typeDartToCodeMap[e.value.runtimeType];
      // Trim all strings before inserting into db
      if (postgresType == PostgreSQLDataType.varChar || postgresType == PostgreSQLDataType.text) {
        data[e.key] = (e.value as String).trim();
      }
      return PostgreSQLFormat.id(e.key, type: postgresType);
    }).join(', ')}) RETURNING $primaryKeyName;
        ''';
    final res = await PostgresDb().connection.query(sql, substitutionValues: data);
    return res.last[0] as int;
  }

  Future<int> updateSingle(T dataObject) async {
    return updateSingleRaw(dataObject.toRaw());
  }

  Future<int> updateSingleRaw(Map<String, dynamic> data) async {
    final postgresTypes = getPostgresDataTypes();
    final sql = '''
        UPDATE $tableName 
        SET ${Map.of(data).entries.map((e) {
      final postgresType =
          postgresTypes.containsKey(e.key) ? postgresTypes[e.key] : typeDartToCodeMap[e.value.runtimeType];
      // Trim all strings before inserting into db
      if (postgresType == PostgreSQLDataType.varChar || postgresType == PostgreSQLDataType.text) {
        data[e.key] = (e.value as String).trim();
      }
      return '${e.key} = ${PostgreSQLFormat.id(e.key, type: postgresType)}';
    }).join(',')} 
        WHERE $primaryKeyName = ${data[primaryKeyName]} RETURNING $primaryKeyName;
        ''';
    final res = await PostgresDb().connection.query(sql, substitutionValues: data);
    if (res.isEmpty || res.last.isEmpty) {
      throw InvalidParameterException('The data object of table $tableName could not be updated. Check the parameters: $data');
    }
    return res.last[0] as int;
  }

  Future<bool> deleteSingle(int id) async {
    final res = await PostgresDb()
        .connection
        .query('DELETE FROM $tableName WHERE $primaryKeyName = @id;', substitutionValues: {'id': id});
    // TODO catch if row cannot be deleted, return false; alternatively select id before in order to check its existence.
    return true;
  }

  Future<Response> requestMany(Request request) async {
    return handleRequestManyOfController(this, isRaw: isRaw(request));
  }

  Future<List<T>> getMany(
      {List<String>? conditions,
      Conjunction conjunction = Conjunction.and,
      Map<String, dynamic>? substitutionValues}) async {
    return Future.wait(
        (await getManyRaw(conditions: conditions, conjunction: conjunction, substitutionValues: substitutionValues))
            .map((e) async => await DataObject.fromRaw<T>(e, getSingleFromDataType))
            .toList());
  }

  Future<List<T>> getManyFromQuery(String sqlQuery, {Map<String, dynamic>? substitutionValues}) async {
    return Future.wait((await getManyRawFromQuery(sqlQuery, substitutionValues: substitutionValues))
        .map((e) async => await DataObject.fromRaw<T>(e, getSingleFromDataType))
        .toList());
  }

  Future<List<Map<String, dynamic>>> getManyRaw(
      {List<String>? conditions,
      Conjunction conjunction = Conjunction.and,
      Map<String, dynamic>? substitutionValues}) async {
    return getManyRawFromQuery(
        'SELECT * FROM $tableName ${conditions == null ? '' : 'WHERE ' + conditions.join(' ${conjunction == Conjunction.and ? 'AND' : 'OR'} ')};',
        substitutionValues: substitutionValues);
  }

  Future<List<Map<String, dynamic>>> getManyRawFromQuery(String sqlQuery,
      {Map<String, dynamic>? substitutionValues}) async {
    final res = await PostgresDb().connection.mappedResultsQuery(sqlQuery, substitutionValues: substitutionValues);
    return mapToTable(res);
  }

  Future<List<T>> mapToEntity(List<Map<String, Map<String, dynamic>>> res) async {
    return Future.wait(res.map((row) async {
      final e = row[tableName]!;
      return await DataObject.fromRaw<T>(e, getSingleFromDataType);
    }));
  }

  List<Map<String, dynamic>> mapToTable(List<Map<String, Map<String, dynamic>>> res) {
    return res.map((row) => row[tableName]!).toList();
  }

  Map<String, PostgreSQLDataType?> getPostgresDataTypes() => {};

  bool isRaw(Request request) {
    return (request.url.queryParameters['isRaw'] ?? '').parseBool();
  }

  static Future<Map<String, dynamic>> query(String sqlQuery, {Map<String, dynamic>? substitutionValues}) async {
    return (await PostgresDb().connection.mappedResultsQuery(sqlQuery, substitutionValues: substitutionValues)).single;
  }

  static Future<Response> handlePostSingleOfController(EntityController controller, Map<String, dynamic> json) async {
    try {
      final id = await handleFromJson(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
      return Response.ok(jsonEncode(id));
    } on InvalidParameterException catch(e) {
      return Response.notFound(e.message);
    }
  }

  static Future<Response> handleRequestSingleOfController(EntityController controller, int id,
      {bool isRaw = false}) async {
    if (isRaw) {
      final single = await controller.getSingleRaw(id);
      if (single == null) {
        return Response.notFound('Object with ID $id not found in ${controller.tableName}');
      } else {
        return Response.ok(rawJsonEncode(single));
      }
    } else {
      final single = await controller.getSingle(id);
      if (single == null) {
        return Response.notFound('Object with ID $id not found in ${controller.tableName}');
      } else {
        return Response.ok(jsonEncode(single));
      }
    }
  }

  static Future<Response> handleRequestManyOfController(EntityController controller,
      {bool isRaw = false,
      List<String>? conditions,
      Conjunction conjunction = Conjunction.and,
      Map<String, dynamic>? substitutionValues}) async {
    if (isRaw) {
      final many = await controller.getManyRaw(
          conditions: conditions, conjunction: conjunction, substitutionValues: substitutionValues);
      return Response.ok(rawJsonEncode(many.toList()));
    } else {
      final many = await controller.getMany(
          conditions: conditions, conjunction: conjunction, substitutionValues: substitutionValues);
      return Response.ok(jsonEncode(many.toList()));
    }
  }

  static Future<Response> handleRequestManyOfControllerFromQuery(EntityController controller,
      {bool isRaw = false, required String sqlQuery, Map<String, dynamic>? substitutionValues}) async {
    if (isRaw) {
      final many = await controller.getManyRawFromQuery(sqlQuery, substitutionValues: substitutionValues);
      return Response.ok(rawJsonEncode(many.toList()));
    } else {
      final many = await controller.getManyFromQuery(sqlQuery, substitutionValues: substitutionValues);
      return Response.ok(jsonEncode(many.toList()));
    }
  }

  static Future<T?> getSingleFromDataType<T extends DataObject>(int id) {
    return getControllerFromDataType<T>().getSingle(id);
  }

  static Future<List<T>> getManyFromDataType<T extends DataObject>(
      {List<String>? conditions, Conjunction conjunction = Conjunction.and, Map<String, dynamic>? substitutionValues}) {
    return getControllerFromDataType<T>()
        .getMany(conditions: conditions, conjunction: conjunction, substitutionValues: substitutionValues);
  }

  static EntityController<T> getControllerFromDataType<T extends DataObject>() {
    switch (T) {
      case Club:
        return ClubController() as EntityController<T>;
      case Fight:
        return FightController() as EntityController<T>;
      case FightAction:
        return FightActionController() as EntityController<T>;
      case League:
        return LeagueController() as EntityController<T>;
      case LeagueWeightClass:
        return LeagueWeightClassController() as EntityController<T>;
      case Lineup:
        return LineupController() as EntityController<T>;
      case Membership:
        return MembershipController() as EntityController<T>;
      case Participation:
        return ParticipationController() as EntityController<T>;
      case ParticipantState:
        return ParticipantStateController() as EntityController<T>;
      case Person:
        return PersonController() as EntityController<T>;
      case Team:
        return TeamController() as EntityController<T>;
      case TeamMatch:
        return TeamMatchController() as EntityController<T>;
      case TeamMatchFight:
        return TeamMatchFightController() as EntityController<T>;
      case Tournament:
        return TournamentController() as EntityController<T>;
      case WeightClass:
        return WeightClassController() as EntityController<T>;
      default:
        throw UnimplementedError('Controller not available for type: $T');
    }
  }
}

enum Conjunction {
  and,
  or,
}

class InvalidParameterException implements Exception {
  String message;

  InvalidParameterException(this.message);
}
