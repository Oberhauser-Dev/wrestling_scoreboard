import '../data.dart';
import '../enums/crud.dart';

Map<String, dynamic> singleToJson(Object single, Type type, CRUD operation) => <String, dynamic>{
      'operation': operation.name,
      'isMany': false,
      'isRaw': single is! DataObject,
      'tableName': getTableNameFromType(type),
      'data': single is DataObject ? single.toJson() : single,
    };

Map<String, dynamic> manyToJson(List<Object> many, Type type, CRUD operation,
        {Type filterType = Object, int? filterId}) =>
    <String, dynamic>{
      'operation': operation.name,
      'isMany': true,
      'isRaw': many.isNotEmpty ? (many.first is DataObject ? false : true) : true,
      'filterType': getTableNameFromType(filterType),
      if (filterId != null) 'filterId': filterId,
      'tableName': getTableNameFromType(type),
      'data': many.map((e) => e is DataObject ? e.toJson() : e),
    };

typedef HandleSingleCallback = Future<int> Function<T extends DataObject>({required CRUD operation, required T single});
typedef HandleSingleRawCallback = Future<int> Function<T extends DataObject>(
    {required CRUD operation, required Map<String, dynamic> single});
typedef HandleManyCallback = Future<void> Function<T extends DataObject>(
    {required CRUD operation, required ManyDataObject<T> many});
typedef HandleManyRawCallback = Future<void> Function<T extends DataObject>(
    {required CRUD operation, required ManyDataObject<Map<String, dynamic>> many});

Future<int?> handleFromJson(Map<String, dynamic> json,
    {required HandleSingleCallback handleSingle,
    required HandleManyCallback handleMany,
    required HandleSingleRawCallback handleSingleRaw,
    required HandleManyRawCallback handleManyRaw}) {
  final type = getTypeFromTableName(json['tableName']);
  switch (type) {
    case Club:
      return _handleFromJsonGeneric<Club>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case Fight:
      return _handleFromJsonGeneric<Fight>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case FightAction:
      return _handleFromJsonGeneric<FightAction>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case League:
      return _handleFromJsonGeneric<League>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case Lineup:
      return _handleFromJsonGeneric<Lineup>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case Membership:
      return _handleFromJsonGeneric<Membership>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case Participation:
      return _handleFromJsonGeneric<Participation>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case ParticipantState:
      return _handleFromJsonGeneric<ParticipantState>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case Team:
      return _handleFromJsonGeneric<Team>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case TeamMatch:
      return _handleFromJsonGeneric<TeamMatch>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case Tournament:
      return _handleFromJsonGeneric<Tournament>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    default:
      throw UnimplementedError('Cannot handle Json for type "${type.toString()}".');
  }
}

Future<int?> _handleFromJsonGeneric<T extends DataObject>(Map<String, dynamic> json,
    {required HandleSingleCallback handleSingle,
    required HandleManyCallback handleMany,
    required HandleSingleRawCallback handleSingleRaw,
    required HandleManyRawCallback handleManyRaw}) async {
  final isMany = json['isMany'] == 'true';
  final isRaw = json['isRaw'] == 'true';
  final operation = CrudParser.valueOf(json['operation']);
  if (isMany) {
    final List<dynamic> data = json['data'];
    final Type? filterType = json['filterType'] == null ? Object : getTypeFromTableName(json['filterType']);
    final int? filterId = json['filterId'];
    if (isRaw) {
      await handleManyRaw<T>(
          operation: operation,
          many: ManyDataObject<Map<String, dynamic>>(
              data: data.map((e) => e as Map<String, dynamic>).toList(),
              filterType: filterType ?? Object,
              filterId: filterId));
    } else {
      await handleMany<T>(
          operation: operation,
          many: ManyDataObject<T>(
              data: data.map((e) => DataObject.fromJson<T>(e as Map<String, dynamic>)).toList(),
              filterType: filterType ?? Object,
              filterId: filterId));
    }
  } else {
    if (isRaw) {
      return await handleSingleRaw<T>(operation: operation, single: json['data']);
    } else {
      return await handleSingle<T>(operation: operation, single: DataObject.fromJson<T>(json['data']));
    }
  }
}

class ManyDataObject<T> {
  List<T> data;
  final Type filterType;
  final int? filterId;

  ManyDataObject({required this.data, this.filterType = Object, this.filterId});
}
