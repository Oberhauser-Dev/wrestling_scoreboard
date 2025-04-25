import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_action_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_config_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_result_rule_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/club_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_team_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/membership_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/participant_state_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/person_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_club_affiliation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/user_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/controllers/weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

final logger = Logger('api_route');

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

mixin ImportController<T extends DataObject> implements ShelfController<T> {
  Map<int, DateTime> lastImportUtcDateTime = {};

  Future<Response> requestLastImportUtcDateTime(Request request, User? user, String entityId) async {
    return Response.ok(lastImportUtcDateTime[int.parse(entityId)]?.toIso8601String());
  }

  void updateLastImportUtcDateTime(int id) {
    lastImportUtcDateTime[id] = DateTime.now().toUtc();
  }

  Organization? getOrganization(T entity);

  Future<Response> postImport(Request request, User? user, String entityIdStr) async {
    final bool obfuscate = user?.obfuscate ?? true;
    final entityId = int.parse(entityIdStr);
    final queryParams = request.requestedUri.queryParameters;
    try {
      final message = await request.readAsString();

      // Only admins can call a subjacent import, to prevent overwriting critical entities.
      final includeSubjacent = bool.parse(queryParams['subjacent'] ?? 'false') &&
          (user?.privilege ?? UserPrivilege.none) >= UserPrivilege.admin;
      final entity = await getSingle(entityId, obfuscate: obfuscate);

      final organization = getOrganization(entity);
      if (organization == null) {
        throw Exception('No organization found for $T $entityId.');
      }

      final apiProvider = await OrganizationController().initApiProvider(message: message, organization: organization);
      if (apiProvider == null) {
        throw Exception('No API provider selected for the organization $organization.');
      }
      await import(entity: entity, apiProvider: apiProvider, obfuscate: obfuscate, includeSubjacent: includeSubjacent);
      return Response.ok('{"status": "success"}');
    } on HttpException catch (err, stackTrace) {
      return Response.badRequest(body: '{"err": "$err", "stackTrace": "$stackTrace"}');
    } catch (err, stackTrace) {
      return Response.internalServerError(body: '{"err": "$err", "stackTrace": "$stackTrace"}');
    }
  }

  Future<void> import({
    required WrestlingApi apiProvider,
    required T entity,
    bool obfuscate = true,
    bool includeSubjacent = false,
  });
}

abstract class ShelfController<T extends DataObject> extends EntityController<T> {
  ShelfController({super.primaryKeyName});

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
      logger.warning(errMessage.toString());
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
      case const (BoutResultRule):
        return BoutResultRuleController();
      case const (Club):
        return ClubController();
      case const (Competition):
        return CompetitionController();
      case const (Organization):
        return OrganizationController();
      case const (Division):
        return DivisionController();
      case const (DivisionWeightClass):
        return DivisionWeightClassController();
      case const (League):
        return LeagueController();
      case const (LeagueTeamParticipation):
        return LeagueTeamParticipationController();
      case const (LeagueWeightClass):
        return LeagueWeightClassController();
      case const (TeamLineup):
        return LineupController();
      case const (Membership):
        return MembershipController();
      case const (TeamMatchParticipation):
        return ParticipationController();
      case const (AthleteBoutState):
        return ParticipantStateController();
      case const (Person):
        return PersonController();
      case const (SecuredUser):
        return SecuredUserController();
      case const (Team):
        return TeamController();
      case const (TeamClubAffiliation):
        return TeamClubAffiliationController();
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
  late final String tableName;
  String primaryKeyName;

  late psql.Statement getSingleRawStmt;
  late psql.Statement deleteSingleStmt;

  EntityController({this.primaryKeyName = 'id'}) {
    tableName = getTableNameFromType(T);
  }

  static Future<void> initAll() async {
    // Reinit all prepared statements
    Iterable<ShelfController> entityControllers =
        dataTypes.map((t) => ShelfController.getControllerFromDataType(t)).nonNulls;
    await Future.forEach(entityControllers, (e) => e.init());
  }

  Future<void> init() async {
    getSingleRawStmt =
        await PostgresDb().connection.prepare(psql.Sql.named('SELECT * FROM $tableName WHERE $primaryKeyName = @id;'));

    deleteSingleStmt =
        await PostgresDb().connection.prepare(psql.Sql.named('DELETE FROM $tableName WHERE $primaryKeyName = @id;'));
  }

  Future<T> getSingle(int id, {required bool obfuscate}) async {
    final single = await getSingleRaw(id, obfuscate: obfuscate);
    return DataObjectParser.fromRaw<T>(
        single, <T extends DataObject>(int id) => getSingleFromDataType<T>(id, obfuscate: obfuscate));
  }

  Future<Map<String, dynamic>> getSingleRaw(
    int id, {
    required bool obfuscate,
  }) async {
    final resStream = getSingleRawStmt.bind({'id': id});
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

  Future<T> updateOnDiffSingle(T dataObject, {required T? previous}) async {
    if (previous == null) {
      return await createSingleReturn(dataObject);
    }
    dataObject = dataObject.copyWithId(previous.id) as T;
    if (dataObject != previous) {
      await updateSingle(dataObject);
    }
    return dataObject;
  }

  Future<List<T>> updateOnDiffMany(List<T> dataObjects, {required List<T> previous}) async {
    if (dataObjects.length != previous.length) {
      await Future.wait(previous.map((prev) => deleteSingle(prev.id!)));
      return await createManyReturn(dataObjects);
    } else {
      return await Future.wait(Map.fromIterables(dataObjects, previous)
          .entries
          .map((element) => updateOnDiffSingle(element.key, previous: element.value)));
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
      await deleteSingleStmt.bind({'id': id}).toList();
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
    required Type searchType,
  }) async {
    bool needsPreciseSearch = false;

    String? mapToCondition(attr, Type type, String searchTableName) {
      // TODO: get postgres types generated from attributes via macros.
      final postgresTypes = ShelfController.getControllerFromDataType(type)!.getPostgresDataTypes();
      final postgresType = postgresTypes.containsKey(attr) ? postgresTypes[attr] : psql.Type.varChar;
      final tableAttr = '$searchTableName.$attr';
      if (((postgresType == psql.Type.integer || postgresType == psql.Type.smallInteger) &&
              int.tryParse(searchStr) != null) ||
          (postgresType == psql.Type.double && double.tryParse(searchStr) != null)) {
        needsPreciseSearch = true;
        return '$tableAttr = @preciseSearch';
      } else if (postgresType == psql.Type.varChar) {
        return '$tableAttr ILIKE @search';
      }
      return null;
    }

    final joins = <String, String>{};

    // Add attributes of foreign key
    Set<String> getSearchableAttrTypeMapping(Type searchType, [String? searchTableName]) {
      searchTableName ??= getTableNameFromType(searchType);
      final orConditions = searchableDataTypes[searchType]
              ?.map((attr) => mapToCondition(attr, searchType, searchTableName!))
              .nonNulls
              .toSet() ??
          {};
      Map<String, Type> attrTypeMapping = searchableForeignAttributeMapping[searchType] ?? const {};

      // Recursively add foreign table attributes with the table name prefix (because they can have the same name as the current table).
      attrTypeMapping.forEach((foreignAttrName, foreignType) {
        final foreignTableName = getTableNameFromType(foreignType);
        final tableAlias =
            '${searchTableName}_${foreignAttrName.replaceRange(foreignAttrName.length - 3, foreignAttrName.length, '')}';
        joins['$foreignTableName AS $tableAlias'] = '$tableAlias.id = $searchTableName.$foreignAttrName';
        orConditions.addAll(getSearchableAttrTypeMapping(foreignType, tableAlias));
      });

      return orConditions;
    }

    final orConditions = getSearchableAttrTypeMapping(searchType);

    final List<String> conditions = [];
    if (orConditions.isNotEmpty) {
      conditions.add('(${orConditions.join(' OR ')})');
      // TODO: remove hacky OR composition by allowing nested query conditions.
    }
    if (organizationId != null) {
      // TODO: Check, which entities support queries with organization_id
      conditions.add('$tableName.organization_id = @org');
    }

    return await getManyJson(
      isRaw: isRaw,
      conditions: conditions,
      joins: joins,
      substitutionValues: {
        'search': '%$searchStr%',
        if (needsPreciseSearch) 'preciseSearch': searchStr,
        if (organizationId != null) 'org': organizationId,
      },
      conjunction: Conjunction.and,
      obfuscate: obfuscate,
    );
  }

  Future<List<T>> getMany({
    List<String>? conditions,
    Map<String, String> joins = const {},
    Conjunction conjunction = Conjunction.and,
    Map<String, dynamic>? substitutionValues,
    List<String> orderBy = const [],
    required bool obfuscate,
  }) async {
    return Future.wait((await getManyRaw(
      conditions: conditions,
      joins: joins,
      conjunction: conjunction,
      substitutionValues: substitutionValues,
      orderBy: orderBy,
      obfuscate: obfuscate,
    ))
        .map((e) async => await DataObjectParser.fromRaw<T>(
            e, <T extends DataObject>(int id) => getSingleFromDataType<T>(id, obfuscate: obfuscate)))
        .toList());
  }

  Future<List<T>> getManyFromQuery(
    String sqlQuery, {
    Map<String, dynamic>? substitutionValues,
    required bool obfuscate,
  }) async {
    return Future.wait((await getManyRawFromQuery(sqlQuery, substitutionValues: substitutionValues))
        .map((e) async => await DataObjectParser.fromRaw<T>(
            e, <T extends DataObject>(int id) => getSingleFromDataType<T>(id, obfuscate: obfuscate)))
        .toList());
  }

  /// The [joins] contains a map of the join statement and its condition,
  /// e.g. { "person AS membership_person": "membership_person.id = person_id"}.
  Future<List<Map<String, dynamic>>> getManyRaw({
    List<String>? conditions,
    Conjunction conjunction = Conjunction.and,
    Map<String, dynamic>? substitutionValues,
    Map<String, String> joins = const {},
    List<String> orderBy = const [],
    required bool obfuscate,
  }) async {
    if (conditions != null && conditions.isEmpty) {
      // If the list of conditions is empty, nothing fulfills this requirement,
      // in contrast to the conditions are null, that means everything fulfills the requirement.
      return [];
    }
    final query = 'SELECT $tableName.* FROM $tableName '
        '${joins.entries.map((join) {
      return 'JOIN ${join.key} ON ${join.value} ';
    }).join('\n')} '
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
    Map<String, String> joins = const {},
    Conjunction conjunction = Conjunction.and,
    Map<String, dynamic>? substitutionValues,
    List<String> orderBy = const [],
    required bool obfuscate,
  }) async {
    if (isRaw) {
      final many = await getManyRaw(
        conditions: conditions,
        joins: joins,
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
        joins: joins,
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
      return await DataObjectParser.fromRaw<T>(
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
