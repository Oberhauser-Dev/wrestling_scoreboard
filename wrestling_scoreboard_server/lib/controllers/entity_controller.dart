import 'dart:convert';
import 'dart:developer';

import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_action_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_config_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/club_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_team_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/membership_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/participant_state_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/person_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/user_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/controllers/weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';
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

abstract class ShelfController<T extends DataObject> extends EntityController<T> {
  ShelfController({required super.tableName, super.primaryKeyName});

  Future<Response> requestSingle(Request request, User? user, String id) async {
    return handleRequestSingle(
      int.parse(id),
      isRaw: request.isRaw,
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<Response> requestMany(Request request, User? user) async {
    return handleRequestMany(
      isRaw: request.isRaw,
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<Response> handleRequestSingle(
    int id, {
    bool isRaw = false,
    bool obfuscate = false,
  }) async {
    if (isRaw) {
      final single = await getSingleRaw(id, obfuscate: obfuscate);
      return Response.ok(rawJsonEncode(single));
    } else {
      final single = await getSingle(id, obfuscate: obfuscate);
      return Response.ok(jsonEncode(single));
    }
  }

  Future<Response> handleRequestMany({
    bool isRaw = false,
    List<String>? conditions,
    Conjunction conjunction = Conjunction.and,
    Map<String, dynamic>? substitutionValues,
    List<String> orderBy = const [],
    required bool obfuscate,
  }) async {
    if (isRaw) {
      final many = await getManyRaw(
        conditions: conditions,
        conjunction: conjunction,
        substitutionValues: substitutionValues,
        orderBy: orderBy,
        obfuscate: obfuscate,
      );
      return Response.ok(rawJsonEncode(many.toList()));
    } else {
      final many = await getMany(
        conditions: conditions,
        conjunction: conjunction,
        substitutionValues: substitutionValues,
        orderBy: orderBy,
        obfuscate: obfuscate,
      );
      return Response.ok(jsonEncode(many.toList()));
    }
  }

  Future<Response> handleRequestManyFromQuery({
    bool isRaw = false,
    required String sqlQuery,
    Map<String, dynamic>? substitutionValues,
    required bool obfuscate,
  }) async {
    if (isRaw) {
      final many = await getManyRawFromQuery(sqlQuery, substitutionValues: substitutionValues);
      return Response.ok(rawJsonEncode(many.toList()));
    } else {
      final many = await getManyFromQuery(sqlQuery, substitutionValues: substitutionValues, obfuscate: obfuscate);
      return Response.ok(jsonEncode(many.toList()));
    }
  }

  Future<T> readSingle(Request request) async {
    final message = await request.readAsString();
    return parseSingleJson<T>(jsonDecode(message));
  }

  Future<Response> postSingle(Request request, User? user) async {
    final message = await request.readAsString();
    try {
      return _handlePostSingle(jsonDecode(message));
    } on FormatException catch (e) {
      final errMessage = 'The data object of table $tableName could not be created. Check the format: $message'
          '\nFormatException: ${e.message}';
      log(errMessage.toString());
      return Response.notFound(errMessage);
    }
  }

  Future<Response> _handlePostSingle(Map<String, Object?> json) async {
    try {
      final id = await handleJson<T>(
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

  static ShelfController? getControllerFromDataType(Type t) {
    switch (t) {
      case const (Bout):
        return BoutController();
      case const (BoutAction):
        return BoutActionController();
      case const (BoutConfig):
        return BoutConfigController();
      case const (Club):
        return ClubController();
      case const (Competition):
        return CompetitionController();
      case const (Organization):
        return OrganizationController();
      case const (Division):
        return DivisionController();
      case const (League):
        return LeagueController();
      case const (DivisionWeightClass):
        return DivisionWeightClassController();
      case const (LeagueTeamParticipation):
        return LeagueTeamParticipationController();
      case const (Lineup):
        return LineupController();
      case const (Membership):
        return MembershipController();
      case const (Participation):
        return ParticipationController();
      case const (ParticipantState):
        return ParticipantStateController();
      case const (Person):
        return PersonController();
      case const (SecuredUser):
        return SecuredUserController();
      case const (Team):
        return TeamController();
      case const (TeamMatch):
        return TeamMatchController();
      case const (TeamMatchBout):
        return TeamMatchBoutController();
      case const (WeightClass):
        return WeightClassController();
      default:
        return null;
    }
  }
}

abstract class EntityController<T extends DataObject> {
  String tableName;
  String primaryKeyName;

  late Future<psql.Statement> getSingleRawStmt;
  late Future<psql.Statement> deleteSingleStmt;

  EntityController({required this.tableName, this.primaryKeyName = 'id'}) {
    init();
  }

  void init() {
    getSingleRawStmt =
        PostgresDb().connection.prepare(psql.Sql.named('SELECT * FROM $tableName WHERE $primaryKeyName = @id;'));

    deleteSingleStmt =
        PostgresDb().connection.prepare(psql.Sql.named('DELETE FROM $tableName WHERE $primaryKeyName = @id;'));
  }

  Future<T> getSingle(int id, {required bool obfuscate}) async {
    final single = await getSingleRaw(id, obfuscate: obfuscate);
    return DataObject.fromRaw<T>(
        single, <T extends DataObject>(int id) => getSingleFromDataType<T>(id, obfuscate: obfuscate));
  }

  Future<Map<String, dynamic>> getSingleRaw(
    int id, {
    required bool obfuscate,
  }) async {
    final resStream = (await getSingleRawStmt).bind({'id': id});
    final many = await resStream.toColumnMap().toList();
    if (many.isEmpty) throw InvalidParameterException('$T with id "$id" not found');
    var data = many.first;
    return obfuscate ? this.obfuscate(data) : data;
  }

  /// This method can be overridden in order to obfuscate the attributes.
  Map<String, dynamic> obfuscate(Map<String, dynamic> raw) {
    return raw;
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

  Future<T> createSingleReturn(T dataObject) async {
    return dataObject.copyWithId(await createSingle(dataObject)) as T;
  }

  Future<List<int>> createMany(List<T> dataObjects) async {
    return await Future.wait(dataObjects.map((element) => createSingle(element)));
  }

  Future<List<T>> createManyReturn(List<T> dataObjects) async {
    return await Future.wait(dataObjects.map((element) => createSingleReturn(element)));
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

  Future<Map<String, dynamic>?> getManyJsonLike(
    bool isRaw,
    String searchStr, {
    int? organizationId,
    required bool obfuscate,
  }) async {
    final postgresTypes = getPostgresDataTypes();
    bool needsPreciseSearch = false;
    final orConditions = getSearchableAttributes()
        .map((attr) {
          // TODO: get postgres types generated from attributes via macros.
          final postgresType = postgresTypes.containsKey(attr) ? postgresTypes[attr] : psql.Type.varChar;
          if (((postgresType == psql.Type.integer || postgresType == psql.Type.smallInteger) &&
                  int.tryParse(searchStr) != null) ||
              (postgresType == psql.Type.double && double.tryParse(searchStr) != null)) {
            needsPreciseSearch = true;
            return '$attr = @preciseSearch';
          } else if (postgresType == psql.Type.varChar) {
            return '$attr ILIKE @search';
          }
          return null;
        })
        .nonNulls
        .toList();

    final List<String> conditions = [];
    if (orConditions.isNotEmpty) {
      conditions.add(orConditions.join(' OR '));
      // TODO: remove hacky OR composition by allowing nested query conditions.
    }
    if (organizationId != null) {
      // TODO: Check, which entities support queries with organization_id
      conditions.add('organization_id = @org');
    }

    return await getManyJson(
      isRaw: isRaw,
      conditions: conditions,
      substitutionValues: {
        'search': '%$searchStr%',
        if (needsPreciseSearch) 'preciseSearch': searchStr,
        if (organizationId != null) 'org': organizationId,
      },
      conjunction: Conjunction.and,
      obfuscate: obfuscate,
    );
  }

  /// Returns a list of searchable attributes.
  /// TODO: with macros, apply it to the property @Searchable.
  Set<String> getSearchableAttributes() => {};

  Future<List<T>> getMany({
    List<String>? conditions,
    Conjunction conjunction = Conjunction.and,
    Map<String, dynamic>? substitutionValues,
    List<String> orderBy = const [],
    required bool obfuscate,
  }) async {
    return Future.wait((await getManyRaw(
      conditions: conditions,
      conjunction: conjunction,
      substitutionValues: substitutionValues,
      orderBy: orderBy,
      obfuscate: obfuscate,
    ))
        .map((e) async => await DataObject.fromRaw<T>(
            e, <T extends DataObject>(int id) => getSingleFromDataType<T>(id, obfuscate: obfuscate)))
        .toList());
  }

  Future<List<T>> getManyFromQuery(
    String sqlQuery, {
    Map<String, dynamic>? substitutionValues,
    required bool obfuscate,
  }) async {
    return Future.wait((await getManyRawFromQuery(sqlQuery, substitutionValues: substitutionValues))
        .map((e) async => await DataObject.fromRaw<T>(
            e, <T extends DataObject>(int id) => getSingleFromDataType<T>(id, obfuscate: obfuscate)))
        .toList());
  }

  Future<List<Map<String, dynamic>>> getManyRaw({
    List<String>? conditions,
    Conjunction conjunction = Conjunction.and,
    Map<String, dynamic>? substitutionValues,
    List<String> orderBy = const [],
    required bool obfuscate,
  }) async {
    if (conditions != null && conditions.isEmpty) {
      // If the list of conditions is empty, nothing fulfills this requirement,
      // in contrast to the conditions are null, that means everything fulfills the requirement.
      return [];
    }
    final query = 'SELECT * FROM $tableName '
        '${conditions == null ? '' : 'WHERE ${conditions.join(' ${conjunction == Conjunction.and ? 'AND' : 'OR'} ')}'} '
        '${orderBy.isEmpty ? '' : 'ORDER BY ${orderBy.join(',')}'};';
    final many = await getManyRawFromQuery(query, substitutionValues: substitutionValues);
    return obfuscate ? many.map((e) => this.obfuscate(e)).toList() : many;
  }

  Future<List<Map<String, dynamic>>> getManyRawFromQuery(String sqlQuery,
      {Map<String, dynamic>? substitutionValues}) async {
    final stmt = await PostgresDb().connection.prepare(psql.Sql.named(sqlQuery));
    final resStream = stmt.bind(substitutionValues);
    return await resStream.toColumnMap().toList();
  }

  Future<Map<String, dynamic>?> getManyJson({
    bool isRaw = false,
    List<String>? conditions,
    Conjunction conjunction = Conjunction.and,
    Map<String, dynamic>? substitutionValues,
    List<String> orderBy = const [],
    required bool obfuscate,
  }) async {
    if (isRaw) {
      final many = await getManyRaw(
        conditions: conditions,
        conjunction: conjunction,
        substitutionValues: substitutionValues,
        orderBy: orderBy,
        obfuscate: obfuscate,
      );
      if (many.isEmpty) {
        return null;
      }
      return manyToJson(many, T, CRUD.read, isRaw: true);
    } else {
      final many = await getMany(
        conditions: conditions,
        conjunction: conjunction,
        substitutionValues: substitutionValues,
        orderBy: orderBy,
        obfuscate: obfuscate,
      );
      if (many.isEmpty) {
        return null;
      }
      return manyToJson(many, T, CRUD.read, isRaw: false);
    }
  }

  Future<List<T>> mapToEntity(
    List<Map<String, Map<String, dynamic>>> res, {
    required bool obfuscate,
  }) async {
    return Future.wait(res.map((row) async {
      final e = row[tableName]!;
      return await DataObject.fromRaw<T>(
          e, <T extends DataObject>(int id) => getSingleFromDataType<T>(id, obfuscate: obfuscate));
    }));
  }

  Map<String, psql.Type?> getPostgresDataTypes() => {};

  static Future<Map<String, dynamic>> query(psql.Statement stmt, {Map<String, dynamic>? substitutionValues}) async {
    final resStream = stmt.bind(substitutionValues);
    return resStream.toColumnMap().single;
  }

  static Future<T> getSingleFromDataType<T extends DataObject>(
    int id, {
    required bool obfuscate,
  }) {
    return ShelfController.getControllerFromDataType(T)?.getSingle(id, obfuscate: obfuscate) as Future<T>;
  }

  static Future<List<T>> getManyFromDataType<T extends DataObject>({
    List<String>? conditions,
    Conjunction conjunction = Conjunction.and,
    Map<String, dynamic>? substitutionValues,
    required bool obfuscate,
  }) {
    return ShelfController.getControllerFromDataType(T)?.getMany(
        conditions: conditions,
        conjunction: conjunction,
        substitutionValues: substitutionValues,
        obfuscate: obfuscate) as Future<List<T>>;
  }
}

enum Conjunction {
  and,
  or,
}

class InvalidParameterException implements Exception {
  String message;

  InvalidParameterException(this.message);

  @override
  String toString() {
    return 'InvalidParameterException(message: "$message")';
  }
}

extension ToPsqlParser on Map<String, dynamic> {
  /// Parse custom postgres types
  /// https://github.com/isoos/postgresql-dart/issues/276
  Map<String, dynamic> parse() {
    return map((key, value) => MapEntry(key, value is psql.UndecodedBytes ? value.asString : value));
  }
}

extension FromPsqlParser on psql.ResultStream {
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
