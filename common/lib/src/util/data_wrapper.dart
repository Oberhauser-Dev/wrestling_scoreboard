import '../data.dart';
import '../enums/crud.dart';

Map<String, dynamic> singleToJson(DataObject single, CRUD operation) => <String, dynamic>{
      'operation': operation.name,
      'isMany': 'false',
      'tableName': single.tableName,
      'data': single,
    };

Map<String, dynamic> manyToJson(List<DataObject> many, Type type, CRUD operation, {Type filterType = Object, int? filterId}) =>
    <String, dynamic>{
      'operation': operation.name,
      'isMany': 'true',
      'filterType': getTableNameFromType(filterType),
      if (filterId != null) 'filterId': filterId,
      'tableName': getTableNameFromType(type),
      'data': many,
    };

typedef HandleSingleCallback = Future<int> Function<T extends DataObject>({required CRUD operation, required T single});
typedef HandleManyCallback = Future<void> Function<T extends DataObject>({required CRUD operation, required ManyDataObject<T> many});

Future<int?> handleFromJson(
    Map<String, dynamic> json,
    HandleSingleCallback handleSingle,
    HandleManyCallback handleMany) {
  final type = getTypeFromTableName(json['tableName']);
  switch (type) {
    case Club:
      return _handleFromJsonGeneric<Club>(json, handleSingle, handleMany);
    case Fight:
      return _handleFromJsonGeneric<Fight>(json, handleSingle, handleMany);
    case League:
      return _handleFromJsonGeneric<League>(json, handleSingle, handleMany);
    case Lineup:
      return _handleFromJsonGeneric<Lineup>(json, handleSingle, handleMany);
    case Membership:
      return _handleFromJsonGeneric<Membership>(json, handleSingle, handleMany);
    case Participation:
      return _handleFromJsonGeneric<Participation>(json, handleSingle, handleMany);
    case Team:
      return _handleFromJsonGeneric<Team>(json, handleSingle, handleMany);
    case TeamMatch:
      return _handleFromJsonGeneric<TeamMatch>(json, handleSingle, handleMany);
    case Tournament:
      return _handleFromJsonGeneric<Tournament>(json, handleSingle, handleMany);
    default:
      throw UnimplementedError('Cannot handle Json for type "${type.toString()}".');
  }
}

Future<int?> _handleFromJsonGeneric<T extends DataObject>(Map<String, dynamic> json,
    HandleSingleCallback handleSingle,
    HandleManyCallback handleMany) async {
  final isMany = json['isMany'] == 'true';
  final operation = CrudParser.valueOf(json['operation']);
  if (isMany) {
    final List<dynamic> data = json['data'];
    final Type? filterType = json['filterType'] == null
        ? Object
        : getTypeFromTableName(json['filterType']);
    final int? filterId = json['filterId'];
    await handleMany<T>(
        operation: operation,
        many: ManyDataObject<T>(
            data: data.map((e) => T.fromJson(e as Map<String, dynamic>) as T).toList(),
            filterType: filterType ?? Object,
            filterId: filterId));
  } else {
    return await handleSingle<T>(operation: operation, single: T.fromJson(json['data']) as T);
  }
}

class ManyDataObject<T extends DataObject> {
  List<T> data;
  final Type filterType;
  final int? filterId;

  ManyDataObject({required this.data, this.filterType = Object, this.filterId});
}
