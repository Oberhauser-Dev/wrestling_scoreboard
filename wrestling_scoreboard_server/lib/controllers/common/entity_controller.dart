import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/exceptions.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
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
  final _logger = Logger('EntityController<$T>');
  late final String tableName;
  String primaryKeyName;

  late psql.Statement getSingleRawStmt;
  late psql.Statement deleteSingleStmt;

  EntityController({this.primaryKeyName = 'id'}) {
    tableName = getTableNameFromType(T);
  }

  static Future<void> initAll() async {
    // Reinit all prepared statements
    final Iterable<ShelfController> entityControllers =
        dataTypes.map((t) => ShelfController.getControllerFromDataType(t)).nonNulls;
    await Future.forEach(entityControllers, (e) => e.init());
  }

  Future<void> init() async {
    getSingleRawStmt = await PostgresDb().connection.prepare(
      psql.Sql.named('SELECT * FROM $tableName WHERE $primaryKeyName = @id;'),
    );

    deleteSingleStmt = await PostgresDb().connection.prepare(
      psql.Sql.named('DELETE FROM $tableName WHERE $primaryKeyName = @id;'),
    );
  }

  Future<T> getSingle(int id, {required bool obfuscate}) async {
    final single = await getSingleRaw(id, obfuscate: obfuscate);
    return DataObjectParser.fromRaw<T>(
      single,
      <TSub extends DataObject>(int id) => getSingleFromDataType<TSub>(id, obfuscate: obfuscate),
    );
  }

  Future<Map<String, dynamic>> getSingleRaw(int id, {required bool obfuscate}) async {
    final resStream = getSingleRawStmt.bind({'id': id});
    final many = await resStream.toColumnMap().toList();
    if (many.isEmpty) throw InvalidParameterException('$T with id "$id" not found');
    final data = many.first;
    return obfuscate ? this.obfuscate(data) : data;
  }

  /// This method can be overridden in order to obfuscate the attributes.
  Map<String, dynamic> obfuscate(Map<String, dynamic> raw) {
    return raw;
  }

  Future<int> createSingle(T dataObject) async {
    return await createSingleRaw(dataObject.toRaw());
  }

  Future<List<int>> createMany(List<T> dataObjects) async {
    return await createManyRaw(dataObjects.map((dataObject) => dataObject.toRaw()).toList());
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
          'The data object of table "$tableName" could not be updated. Check the attributes: $data',
        );
      }
      return res.last[0] as int;
    } on psql.PgException catch (e) {
      throw InvalidParameterException(
        'The data object of table "$tableName" could not be created. Check the attributes: $data\n'
        'PgException: {"message": ${e.message}}',
      );
    }
  }

  Future<List<int>> createManyRaw(List<Map<String, dynamic>> dataList) async {
    if (dataList.isEmpty) return [];
    final keys = dataList.first.keys;
    final sql = '''
        INSERT INTO $tableName (${keys.join(',')}) 
        VALUES (${keys.map((key) => '@$key').join(', ')}) RETURNING $primaryKeyName;
        ''';
    final stmt = await PostgresDb().connection.prepare(psql.Sql.named(sql));
    return Future.wait(
      dataList.map((data) async {
        try {
          final bindingData = _prepareBindingData(data);
          final res = await stmt.bind(bindingData).toList();
          if (res.isEmpty || res.last.isEmpty) {
            throw InvalidParameterException(
              'The data object of table "$tableName" could not be updated. Check the attributes: $data',
            );
          }
          return res.last[0] as int;
        } on psql.PgException catch (e) {
          throw InvalidParameterException(
            'The data object of table "$tableName" could not be created. Check the attributes: $data\n'
            'PgException: {"message": ${e.message}}',
          );
        }
      }),
    );
  }

  Future<T> createSingleReturn(T dataObject) async {
    return dataObject.copyWithId(await createSingle(dataObject)) as T;
  }

  Future<List<T>> createManyReturn(List<T> dataObjects) async {
    final manyIds = await createMany(dataObjects);
    return dataObjects.mapIndexed((index, dataObject) => dataObject.copyWithId(manyIds[index]) as T).toList();
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
          'The data object of table "$tableName" could not be updated. Check the attributes: $data',
        );
      }
      return res.last[0] as int;
    } on psql.PgException catch (e) {
      throw InvalidParameterException(
        'The data object of table "$tableName" could not be updated. Check the attributes: $data'
        '\nPgException: {"message": ${e.message}',
      );
    }
  }

  Future<T> updateOnDiffSingle(T dataObject, {required T? previous}) async {
    if (previous == null) {
      return await createSingleReturn(dataObject);
    }
    dataObject = dataObject.copyWithId(previous.id) as T;
    if (dataObject != previous) {
      _logger.fine(
        'updateOnDiffSingle: Update single as of different properties: (prev: ${previous.toJson()}, curr: ${dataObject.toJson()})',
      );
      await updateSingle(dataObject);
    }
    return dataObject;
  }

  Future<List<T>> updateOnDiffMany(List<T> dataObjects, {required List<T> previous}) async {
    final listLengthDiff = dataObjects.length - previous.length;
    List<T> updatingDataObjects;
    List<T> creatingDataObjects;
    List<T> updatingPrevDataObjects;
    List<T> deletingPrevDataObjects;
    if (listLengthDiff > 0) {
      updatingDataObjects = dataObjects.sublist(0, previous.length);
      creatingDataObjects = dataObjects.sublist(previous.length);
      updatingPrevDataObjects = previous;
      deletingPrevDataObjects = [];
    } else if (listLengthDiff < 0) {
      updatingDataObjects = dataObjects;
      creatingDataObjects = [];
      updatingPrevDataObjects = previous.sublist(0, dataObjects.length);
      deletingPrevDataObjects = previous.sublist(dataObjects.length);
    } else {
      updatingDataObjects = dataObjects;
      creatingDataObjects = [];
      deletingPrevDataObjects = [];
      updatingPrevDataObjects = previous;
    }
    _logger.fine(
      'updateOnDiffMany: Update list of data objects: (updating: ${updatingDataObjects.length}, creating: ${creatingDataObjects.length}, deleting: ${deletingPrevDataObjects.length})',
    );
    await Future.wait(deletingPrevDataObjects.map((prev) => deleteSingle(prev.id!)));
    updatingDataObjects = await Future.wait(
      Map.fromIterables(
        updatingDataObjects,
        updatingPrevDataObjects,
      ).entries.map((element) => updateOnDiffSingle(element.key, previous: element.value)),
    );
    creatingDataObjects = await createManyReturn(creatingDataObjects);
    return [...updatingDataObjects, ...creatingDataObjects];
  }

  // TODO: Probably can predefine dataTypes for all properties instead of retrieving them from the value.
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

  Future<void> deleteManyRaw({
    List<String>? conditions,
    Conjunction conjunction = Conjunction.and,
    Map<String, dynamic>? substitutionValues,
  }) async {
    return setManyRawFromQuery(
      'DELETE FROM $tableName ${conditions == null ? '' : 'WHERE ${conditions.join(' ${conjunction == Conjunction.and ? 'AND' : 'OR'} ')}'};',
      substitutionValues: substitutionValues,
    );
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
    final Iterable<String> searchTokens = searchStr.split(RegExp(r'\s|,|;')).where((str) => str.isNotEmpty);

    final joins = <String, String>{};
    final List<String> conditions = [];
    final substitutionValues = <String, dynamic>{};

    for (final (tokenIndex, token) in searchTokens.indexed) {
      final List<String> orConditions = [];
      final List<String> preciseSearchConditions = [];
      final List<String> searchConditions = [];

      void addCondition(attr, Type type, String searchTableName) {
        // TODO: get postgres types generated from attributes via macros.
        final postgresTypes = ShelfController.getControllerFromDataType(type)!.getPostgresDataTypes();
        final postgresType = postgresTypes.containsKey(attr) ? postgresTypes[attr] : psql.Type.varChar;
        final tableAttr = '$searchTableName.$attr';
        if (((postgresType == psql.Type.integer || postgresType == psql.Type.smallInteger) &&
                int.tryParse(token) != null) ||
            (postgresType == psql.Type.double && double.tryParse(token) != null)) {
          preciseSearchConditions.add('$tableAttr = @preciseSearch$tokenIndex');
        } else if (postgresType == psql.Type.varChar) {
          searchConditions.add('$tableAttr ILIKE @search$tokenIndex');
        }
      }

      // Add attributes of foreign key
      void addSearchableAttrTypeMapping(Type searchType, [String? searchTableName]) {
        searchTableName ??= getTableNameFromType(searchType);
        searchableDataTypes[searchType]?.forEach((attr) => addCondition(attr, searchType, searchTableName!));
        final Map<String, Type> attrTypeMapping = searchableForeignAttributeMapping[searchType] ?? const {};

        // Recursively add foreign table attributes with the table name prefix (because they can have the same name as the current table).
        attrTypeMapping.forEach((foreignAttrName, foreignType) {
          final foreignTableName = getTableNameFromType(foreignType);
          final tableAlias =
              '${searchTableName}_${foreignAttrName.replaceRange(foreignAttrName.length - 3, foreignAttrName.length, '')}';
          joins['$foreignTableName AS $tableAlias'] = '$tableAlias.id = $searchTableName.$foreignAttrName';
          addSearchableAttrTypeMapping(foreignType, tableAlias);
        });
      }

      addSearchableAttrTypeMapping(searchType);

      if (searchConditions.isNotEmpty) {
        // TODO: remove hacky OR composition by allowing nested query conditions.
        orConditions.add(searchConditions.join(' OR '));
        substitutionValues['search$tokenIndex'] = '%$token%';
      }
      if (preciseSearchConditions.isNotEmpty) {
        // TODO: remove hacky OR composition by allowing nested query conditions.
        orConditions.add(preciseSearchConditions.join(' OR '));
        substitutionValues['preciseSearch$tokenIndex'] = token;
      }

      if (orConditions.isNotEmpty) {
        conditions.add(orConditions.map((e) => '($e)').join(' OR '));
      }
    }

    if (organizationId != null) {
      // TODO: Check, which entities support queries with organization_id
      conditions.add('$tableName.organization_id = @org');
    }

    if (organizationId != null) substitutionValues['org'] = organizationId;
    return await getManyJson(
      isRaw: isRaw,
      conditions: conditions,
      joins: joins,
      substitutionValues: substitutionValues,
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
    return Future.wait(
      (await getManyRaw(
            conditions: conditions,
            joins: joins,
            conjunction: conjunction,
            substitutionValues: substitutionValues,
            orderBy: orderBy,
            obfuscate: obfuscate,
          ))
          .map(
            (e) async => await DataObjectParser.fromRaw<T>(
              e,
              <TSub extends DataObject>(int id) => getSingleFromDataType<TSub>(id, obfuscate: obfuscate),
            ),
          )
          .toList(),
    );
  }

  Future<List<T>> getManyFromQuery(
    String sqlQuery, {
    Map<String, dynamic>? substitutionValues,
    required bool obfuscate,
  }) async {
    return Future.wait(
      (await getManyRawFromQuery(sqlQuery, substitutionValues: substitutionValues))
          .map(
            (e) async => await DataObjectParser.fromRaw<T>(
              e,
              <TSub extends DataObject>(int id) => getSingleFromDataType<TSub>(id, obfuscate: obfuscate),
            ),
          )
          .toList(),
    );
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
    // Always order at least by id to get more consistent results
    orderBy = [...orderBy, 'id'];
    final query =
        'SELECT $tableName.* FROM $tableName '
        '${joins.entries.map((join) {
          return 'JOIN ${join.key} ON ${join.value} ';
        }).join('\n')} '
        '${conditions == null ? '' : 'WHERE ${conditions.join(' ${conjunction == Conjunction.and ? 'AND' : 'OR'} ')}'} '
        '${'ORDER BY ${orderBy.join(',')}'};';
    final many = await getManyRawFromQuery(query, substitutionValues: substitutionValues);
    return obfuscate ? many.map((e) => this.obfuscate(e)).toList() : many;
  }

  Future<List<Map<String, dynamic>>> getManyRawFromQuery(
    String sqlQuery, {
    Map<String, dynamic>? substitutionValues,
  }) async {
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

  Future<List<T>> mapToEntity(List<Map<String, Map<String, dynamic>>> res, {required bool obfuscate}) async {
    return Future.wait(
      res.map((row) async {
        final e = row[tableName]!;
        return await DataObjectParser.fromRaw<T>(
          e,
          <TSub extends DataObject>(int id) => getSingleFromDataType<TSub>(id, obfuscate: obfuscate),
        );
      }),
    );
  }

  Map<String, psql.Type?> getPostgresDataTypes() => {};

  static Future<Map<String, dynamic>> query(psql.Statement stmt, {Map<String, dynamic>? substitutionValues}) async {
    final resStream = stmt.bind(substitutionValues);
    return resStream.toColumnMap().single;
  }

  static Future<T> getSingleFromDataType<T extends DataObject>(int id, {required bool obfuscate}) {
    return ShelfController.getControllerFromDataType(T)?.getSingle(id, obfuscate: obfuscate) as Future<T>;
  }

  static Future<List<T>> getManyFromDataType<T extends DataObject>({
    List<String>? conditions,
    Conjunction conjunction = Conjunction.and,
    Map<String, dynamic>? substitutionValues,
    List<String> orderBy = const [],
    required bool obfuscate,
  }) {
    return ShelfController.getControllerFromDataType(T)?.getMany(
          conditions: conditions,
          conjunction: conjunction,
          substitutionValues: substitutionValues,
          obfuscate: obfuscate,
          orderBy: orderBy,
        )
        as Future<List<T>>;
  }
}

enum Conjunction { and, or }

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
