import 'dart:convert';
import 'dart:developer';

import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_action_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_config_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/club_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_team_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/membership_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/participant_state_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/person_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/controllers/weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

Map<Type, psql.Type> typeDartToCodeMap = {
  String: psql.Type.varChar,
  // 'int2': psql.Type.smallInteger,
  int: psql.Type.integer,
  // 'int8': psql.Type.bigInteger,
  // 'float4': psql.Type.real,
  double: psql.Type.double,
  bool: psql.Type.boolean,
  DateTime: psql.Type.date,
  // 'timestamp': psql.Type.timestampWithoutTimezone,
  // 'timestamptz': psql.Type.timestampWithTimezone,
  // 'interval': psql.Type.interval,
  // PgPoint: psql.Type.point,
  // 'jsonb': psql.Type.jsonb,
  // 'bytea': psql.Type.byteArray,
  // 'name': psql.Type.name,
  // 'uuid': psql.Type.uuid,
  // 'json': psql.Type.json,
  // 'point': psql.Type.point,
  List<int>: psql.Type.integerArray,
  List<String>: psql.Type.textArray,
  List<double>: psql.Type.doubleArray,
  // 'varchar': psql.Type.varChar,
  // '_jsonb': psql.Type.jsonbArray,
};

abstract class EntityController<T extends DataObject> {
  String tableName;
  String primaryKeyName;

  EntityController({required this.tableName, this.primaryKeyName = 'id'});

  Future<Response> postSingle(Request request) async {
    final message = await request.readAsString();
    try {
      return handlePostSingleOfController(this, jsonDecode(message));
    } on FormatException catch (e) {
      final errMessage = 'The data object of table $tableName could not be created. Check the format: $message'
          '\nFormatException: ${e.message}';
      log(errMessage.toString());
      return Response.notFound(errMessage);
    }
  }

  Future<Response> requestSingle(Request request, String id) async {
    return handleRequestSingleOfController(this, int.parse(id), isRaw: isRaw(request));
  }

  Future<T> getSingle(int id) async {
    final single = await getSingleRaw(id);
    return DataObject.fromRaw<T>(single, getSingleFromDataType);
  }

  late final getSingleRawStmt =
      PostgresDb().connection.prepare(psql.Sql.named('SELECT * FROM $tableName WHERE $primaryKeyName = @id;'));

  Future<Map<String, dynamic>> getSingleRaw(int id) async {
    final resStream = (await getSingleRawStmt).bind({'id': id});
    final many = await resStream.toColumnMap().toList();
    if (many.isEmpty) throw Exception('$T with id "$id" not found');
    return many.first;
  }

  Future<int> createSingle(T dataObject) async {
    return await createSingleRaw(dataObject.toRaw());
  }

  Future<int> createSingleRaw(Map<String, dynamic> data) async {
    final sql = '''
        INSERT INTO $tableName (${data.keys.join(',')}) 
        VALUES (${data.keys.map((key) => '@$key').join(', ')}) RETURNING $primaryKeyName;
        ''';
    try {
      final stmt = await PostgresDb().connection.prepare(psql.Sql.named(sql));
      final bindingData = _prepareBindingData(data);
      final res = await stmt.bind(bindingData).toList();
      if (res.isEmpty || res.last.isEmpty) {
        throw InvalidParameterException(
            'The data object of table $tableName could not be updated. Check the attributes: $data');
      }
      return res.last[0] as int;
    } on psql.PgException catch (e) {
      throw InvalidParameterException(
          'The data object of table $tableName could not be created. Check the attributes: $data\n'
          'PgException: {"message": ${e.message}}');
    }
  }

  Future<int> updateSingle(T dataObject) async {
    return updateSingleRaw(dataObject.toRaw());
  }

  Future<int> updateSingleRaw(Map<String, dynamic> data) async {
    final sql = '''
        UPDATE $tableName 
        SET ${data.keys.map((key) {
      return '$key = @$key';
    }).join(',')} 
        WHERE $primaryKeyName = ${data[primaryKeyName]} RETURNING $primaryKeyName;
        ''';
    try {
      final stmt = await PostgresDb().connection.prepare(psql.Sql.named(sql));
      final bindingData = _prepareBindingData(data);
      final res = await stmt.bind(bindingData).toList();
      if (res.isEmpty || res.last.isEmpty) {
        throw InvalidParameterException(
            'The data object of table $tableName could not be updated. Check the attributes: $data');
      }
      return res.last[0] as int;
    } on psql.PgException catch (e) {
      throw InvalidParameterException(
          'The data object of table $tableName could not be updated. Check the attributes: $data'
          '\nPgException: {"message": ${e.message}');
    }
  }

  Map<String, dynamic> _prepareBindingData(Map<String, dynamic> data) {
    final postgresTypes = getPostgresDataTypes();
    return data.map((key, value) {
      final postgresType = postgresTypes.containsKey(key) ? postgresTypes[key] : typeDartToCodeMap[value.runtimeType];
      // Trim all strings before inserting into db
      if (postgresType == psql.Type.varChar || postgresType == psql.Type.text && value != null) {
        value = (value as String).trim();
      }
      return MapEntry(key, postgresType == null ? value : psql.TypedValue(postgresType, value));
    });
  }

  late final deleteSingleStmt =
      PostgresDb().connection.prepare(psql.Sql.named('DELETE FROM $tableName WHERE $primaryKeyName = @id;'));

  Future<bool> deleteSingle(int id) async {
    try {
      await (await deleteSingleStmt).bind({'id': id}).toList();
    } on psql.PgException catch (_) {
      return false;
    }
    return true;
  }

  Future<void> deleteMany({
    List<String>? conditions,
    Conjunction conjunction = Conjunction.and,
    Map<String, dynamic>? substitutionValues,
  }) async {
    await deleteManyRaw(conditions: conditions, conjunction: conjunction, substitutionValues: substitutionValues);
  }

  Future<void> deleteManyRaw(
      {List<String>? conditions,
      Conjunction conjunction = Conjunction.and,
      Map<String, dynamic>? substitutionValues}) async {
    return setManyRawFromQuery(
        'DELETE FROM $tableName ${conditions == null ? '' : 'WHERE ${conditions.join(' ${conjunction == Conjunction.and ? 'AND' : 'OR'} ')}'};',
        substitutionValues: substitutionValues);
  }

  Future<void> setManyRawFromQuery(String sqlQuery, {Map<String, dynamic>? substitutionValues}) async {
    final stmt = await PostgresDb().connection.prepare(psql.Sql.named(sqlQuery));
    await stmt.bind(substitutionValues).toList();
  }

  Future<Response> requestMany(Request request) async {
    return handleRequestManyOfController(this, isRaw: isRaw(request));
  }

  Future<List<T>> getMany({
    List<String>? conditions,
    Conjunction conjunction = Conjunction.and,
    Map<String, dynamic>? substitutionValues,
    List<String> orderBy = const [],
  }) async {
    return Future.wait((await getManyRaw(
            conditions: conditions, conjunction: conjunction, substitutionValues: substitutionValues, orderBy: orderBy))
        .map((e) async => await DataObject.fromRaw<T>(e, getSingleFromDataType))
        .toList());
  }

  Future<List<T>> getManyFromQuery(String sqlQuery, {Map<String, dynamic>? substitutionValues}) async {
    return Future.wait((await getManyRawFromQuery(sqlQuery, substitutionValues: substitutionValues))
        .map((e) async => await DataObject.fromRaw<T>(e, getSingleFromDataType))
        .toList());
  }

  Future<List<Map<String, dynamic>>> getManyRaw({
    List<String>? conditions,
    Conjunction conjunction = Conjunction.and,
    Map<String, dynamic>? substitutionValues,
    List<String> orderBy = const [],
  }) async {
    return getManyRawFromQuery(
        'SELECT * FROM $tableName ${conditions == null ? '' : 'WHERE ${conditions.join(' ${conjunction == Conjunction.and ? 'AND' : 'OR'} ')}'} ${orderBy.isEmpty ? '' : 'ORDER BY ${orderBy.join(',')}'};',
        substitutionValues: substitutionValues);
  }

  Future<List<Map<String, dynamic>>> getManyRawFromQuery(String sqlQuery,
      {Map<String, dynamic>? substitutionValues}) async {
    final stmt = await PostgresDb().connection.prepare(psql.Sql.named(sqlQuery));
    final resStream = stmt.bind(substitutionValues);
    return await resStream.toColumnMap().toList();
  }

  Future<List<T>> mapToEntity(List<Map<String, Map<String, dynamic>>> res) async {
    return Future.wait(res.map((row) async {
      final e = row[tableName]!;
      return await DataObject.fromRaw<T>(e, getSingleFromDataType);
    }));
  }

  Map<String, psql.Type?> getPostgresDataTypes() => {};

  bool isRaw(Request request) {
    return (request.url.queryParameters['isRaw'] ?? '').parseBool();
  }

  static Future<Map<String, dynamic>> query(psql.Statement stmt, {Map<String, dynamic>? substitutionValues}) async {
    final resStream = stmt.bind(substitutionValues);
    return resStream.toColumnMap().single;
  }

  static Future<Response> handlePostSingleOfController(EntityController controller, Map<String, Object?> json) async {
    try {
      final id = await handleFromJson(
        json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw,
      );
      return Response.ok(jsonEncode(id));
    } on InvalidParameterException catch (e) {
      return Response.notFound(e.message);
    }
  }

  static Future<Response> handleRequestSingleOfController(EntityController controller, int id,
      {bool isRaw = false}) async {
    if (isRaw) {
      final single = await controller.getSingleRaw(id);
      return Response.ok(rawJsonEncode(single));
    } else {
      final single = await controller.getSingle(id);
      return Response.ok(jsonEncode(single));
    }
  }

  static Future<Response> handleRequestManyOfController(
    EntityController controller, {
    bool isRaw = false,
    List<String>? conditions,
    Conjunction conjunction = Conjunction.and,
    Map<String, dynamic>? substitutionValues,
    List<String> orderBy = const [],
  }) async {
    if (isRaw) {
      final many = await controller.getManyRaw(
          conditions: conditions, conjunction: conjunction, substitutionValues: substitutionValues, orderBy: orderBy);
      return Response.ok(rawJsonEncode(many.toList()));
    } else {
      final many = await controller.getMany(
          conditions: conditions, conjunction: conjunction, substitutionValues: substitutionValues, orderBy: orderBy);
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

  static Future<T> getSingleFromDataType<T extends DataObject>(int id) {
    return getControllerFromDataType(T).getSingle(id) as Future<T>;
  }

  static Future<List<T>> getManyFromDataType<T extends DataObject>(
      {List<String>? conditions, Conjunction conjunction = Conjunction.and, Map<String, dynamic>? substitutionValues}) {
    return getControllerFromDataType(T).getMany(
        conditions: conditions, conjunction: conjunction, substitutionValues: substitutionValues) as Future<List<T>>;
  }

  static EntityController getControllerFromDataType(Type t) {
    switch (t) {
      case BoutConfig:
        return BoutConfigController();
      case Club:
        return ClubController();
      case Bout:
        return BoutController();
      case BoutAction:
        return BoutActionController();
      case League:
        return LeagueController();
      case LeagueWeightClass:
        return LeagueWeightClassController();
      case LeagueTeamParticipation:
        return LeagueTeamParticipationController();
      case Lineup:
        return LineupController();
      case Membership:
        return MembershipController();
      case Participation:
        return ParticipationController();
      case ParticipantState:
        return ParticipantStateController();
      case Person:
        return PersonController();
      case Team:
        return TeamController();
      case TeamMatch:
        return TeamMatchController();
      case TeamMatchBout:
        return TeamMatchBoutController();
      case Competition:
        return CompetitionController();
      case WeightClass:
        return WeightClassController();
      default:
        throw UnimplementedError('Controller not available for type: $t');
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

extension on Map<String, dynamic> {
  /// Parse custom postgres types
  /// https://github.com/isoos/postgresql-dart/issues/276
  Map<String, dynamic> parse() {
    return map((key, value) => MapEntry(key, value is psql.UndecodedBytes ? value.asString : value));
  }
}

extension on psql.ResultStream {
  /// Parse custom postgres types
  /// https://github.com/isoos/postgresql-dart/issues/276
  // ignore: unused_element
  Stream<Iterable<dynamic>> parse() {
    return map((row) => row.map((value) => value is psql.UndecodedBytes ? value.asString : value));
  }

  Stream<Map<String, dynamic>> toColumnMap() {
    return map((row) => row.toColumnMap().parse());
  }
}
