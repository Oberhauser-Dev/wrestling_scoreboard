import 'dart:convert';

import 'package:common/common.dart';
import 'package:postgres/postgres.dart';
import 'package:server/controllers/club_controller.dart';
import 'package:server/controllers/fight_controller.dart';
import 'package:server/controllers/league_controller.dart';
import 'package:server/controllers/lineup_controller.dart';
import 'package:server/controllers/membership_controller.dart';
import 'package:server/controllers/participation_controller.dart';
import 'package:server/controllers/team_controller.dart';
import 'package:server/controllers/team_match_controller.dart';
import 'package:server/controllers/tournament_controller.dart';
import 'package:server/controllers/websocket_handler.dart';
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
    return parseFromRaw(single);
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
        VALUES (${data.entries.map((e) => PostgreSQLFormat.id(e.key, type: postgresTypes[e.key] ?? typeDartToCodeMap[e.value.runtimeType])).join(', ')}) RETURNING $primaryKeyName;
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
        SET ${data.entries.map((e) => '${e.key} = ${PostgreSQLFormat.id(e.key, type: postgresTypes[e.key] ?? typeDartToCodeMap[e.value.runtimeType])}').join(',')} 
        WHERE $primaryKeyName = ${data[primaryKeyName]} RETURNING $primaryKeyName;
        ''';
    final res = await PostgresDb().connection.query(sql, substitutionValues: data);
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
            .map((e) async => await parseFromRaw(e))
            .toList());
  }

  Future<List<T>> getManyFromQuery(String sqlQuery, {Map<String, dynamic>? substitutionValues}) async {
    return Future.wait((await getManyRawFromQuery(sqlQuery, substitutionValues: substitutionValues))
        .map((e) async => await parseFromRaw(e))
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
      return await parseFromRaw(e);
    }));
  }

  List<Map<String, dynamic>> mapToTable(List<Map<String, Map<String, dynamic>>> res) {
    return res.map((row) => row[tableName]!).toList();
  }

  Future<T> parseFromRaw(Map<String, dynamic> e);

  Map<String, PostgreSQLDataType> getPostgresDataTypes() => {};

  bool isRaw(Request request) {
    return (request.url.queryParameters['raw'] ?? '').parseBool();
  }

  static Future<Response> handlePostSingleOfController(EntityController controller, Map<String, dynamic> json) async {
    final id = await handleFromJson(json, handleSingle, handleMany);
    return Response.ok(jsonEncode(id));
  }

  static Future<Response> handleRequestSingleOfController(EntityController controller, int id,
      {bool isRaw = false}) async {
    if (isRaw) {
      final single = await controller.getSingleRaw(id);
      if (single == null) {
        return Response.notFound('Object with ID $id not found in ${controller.tableName}');
      } else {
        return Response.ok(betterJsonEncode(single));
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
      return Response.ok(betterJsonEncode(many.toList()));
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
      return Response.ok(betterJsonEncode(many.toList()));
    } else {
      final many = await controller.getManyFromQuery(sqlQuery, substitutionValues: substitutionValues);
      return Response.ok(jsonEncode(many.toList()));
    }
  }

  static EntityController getControllerFromDataType(Type t) {
    switch (t) {
      case Club:
        return ClubController();
      case Fight:
        return FightController();
      case League:
        return LeagueController();
      case Lineup:
        return LineupController();
      case Membership:
        return MembershipController();
      case Participation:
        return ParticipationController();
      case Team:
        return TeamController();
      case TeamMatch:
        return TeamMatchController();
      case Tournament:
        return TournamentController();
      default:
        throw UnimplementedError('Controller not available for type: $t');
    }
  }
}

enum Conjunction {
  and,
  or,
}
