import '../../common.dart';

/// Returns a map of data types with searchable attributes.
/// TODO: with build generator, apply it to the property @Searchable.
final Map<Type, Set<String>> searchableDataTypes = {
  Bout: Bout.searchableAttributes,
  Club: Club.searchableAttributes,
  Organization: Organization.searchableAttributes,
  WeightClass: WeightClass.searchableAttributes,
  // Uses same attributes as WrestlingEvent ATM
  Competition: WrestlingEvent.searchableAttributes,
  // Uses same attributes as WrestlingEvent ATM
  TeamMatch: WrestlingEvent.searchableAttributes,
  Division: Division.searchableAttributes,
  League: League.searchableAttributes,
  Membership: Membership.searchableAttributes,
  Person: Person.searchableAttributes,
  Team: Team.searchableAttributes,
  TeamMatchBout: TeamMatchBout.searchableAttributes,
};

final Map<Type, Map<String, Type>> searchableForeignAttributeMapping = {
  Bout: Bout.searchableForeignAttributeMapping,
  Membership: Membership.searchableForeignAttributeMapping,
  AthleteBoutState: AthleteBoutState.searchableForeignAttributeMapping,
  TeamLineupParticipation: TeamLineupParticipation.searchableForeignAttributeMapping,
  TeamMatchBout: TeamMatchBout.searchableForeignAttributeMapping,
};

Map<String, dynamic> singleToJson(Object single, Type type, CRUD operation) {
  return <String, dynamic>{
    'operation': operation.name,
    'isMany': false,
    'isRaw': single is! DataObject,
    'tableName': getTableNameFromType(type),
    'data': single, // Is converted automatically with jsonEncode
  };
}

Map<String, dynamic> manyToJson(
  List<Object> many,
  Type type,
  CRUD operation, {
  required bool isRaw,
  Type? filterType,
  int? filterId,
}) {
  return <String, dynamic>{
    'operation': operation.name,
    'isMany': true,
    'isRaw': isRaw,
    'filterType': filterType == null ? null : getTableNameFromType(filterType),
    if (filterId != null) 'filterId': filterId,
    'tableName': getTableNameFromType(type),
    'data': many, // Is converted automatically with jsonEncode
  };
}

typedef HandleSingleCallback = Future<int> Function<T extends DataObject>({required CRUD operation, required T single});
typedef HandleSingleRawCallback =
    Future<int> Function<T extends DataObject>({required CRUD operation, required Map<String, dynamic> single});
typedef HandleManyCallback =
    Future<void> Function<T extends DataObject>({required CRUD operation, required ManyDataObject<T> many});
typedef HandleManyRawCallback =
    Future<void> Function<T extends DataObject>({
      required CRUD operation,
      required ManyDataObject<Map<String, dynamic>> many,
    });

Map<String, dynamic> parseSingleRawJson(Map<String, dynamic> json) {
  return json['data'];
}

T parseSingleJson<T extends DataObject>(Map<String, dynamic> json) {
  return DataObjectParser.fromJson<T>(json['data']);
}

ManyDataObject<Map<String, dynamic>> parseManyRawJson(Map<String, dynamic> json) {
  final List<dynamic> data = json['data'];
  final filterType = json['filterType'] == null ? null : getTypeFromTableName(json['filterType']);
  final int? filterId = json['filterId'];
  return ManyDataObject<Map<String, dynamic>>(
    data:
        data.map((e) {
          return e as Map<String, dynamic>;
        }).toList(),
    filterType: filterType,
    filterId: filterId,
  );
}

ManyDataObject<T> parseManyJson<T extends DataObject>(Map<String, dynamic> json) {
  final List<dynamic> data = json['data'];
  final filterType = json['filterType'] == null ? null : getTypeFromTableName(json['filterType']);
  final int? filterId = json['filterId'];
  return ManyDataObject<T>(
    data:
        data.map((e) {
          return DataObjectParser.fromJson<T>(e as Map<String, dynamic>);
        }).toList(),
    filterType: filterType,
    filterId: filterId,
  );
}

Future<int?> handleJson<T extends DataObject>(
  Map<String, dynamic> json, {
  required HandleSingleCallback handleSingle,
  required HandleManyCallback handleMany,
  required HandleSingleRawCallback handleSingleRaw,
  required HandleManyRawCallback handleManyRaw,
}) async {
  final isMany = json['isMany'] as bool;
  final isRaw = json['isRaw'] as bool;
  final operation = CRUD.values.byName(json['operation']);

  if (isMany) {
    if (isRaw) {
      await handleManyRaw<T>(operation: operation, many: parseManyRawJson(json));
    } else {
      await handleMany<T>(operation: operation, many: parseManyJson<T>(json));
    }
  } else {
    if (isRaw) {
      return await handleSingleRaw<T>(operation: operation, single: parseSingleRawJson(json));
    } else {
      final single = parseSingleJson<T>(json);
      return await handleSingle<T>(operation: operation, single: single);
    }
  }
  return null;
}

class ManyDataObject<T> {
  List<T> data;
  final Type? filterType;
  final int? filterId;

  ManyDataObject({required this.data, this.filterType, this.filterId});
}
