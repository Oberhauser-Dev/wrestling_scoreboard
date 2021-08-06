import '../data.dart';
import '../enums/crud.dart';

Map<String, dynamic> singleToJson(DataObject single, CRUD operation) =>
    <String, dynamic>{
      'operation': crudEncode(operation),
      'isMany': 'false',
      'tableName': single.tableName,
      'data': single,
    };

Map<String, dynamic> manyToJson(List<DataObject> many, CRUD operation, {Type filterType = Object}) =>
    <String, dynamic>{
      'operation': crudEncode(operation),
      'isMany': 'true',
      'filterType': getTableNameFromType(filterType),
      'filterId': getTableNameFromType(filterType),
      'tableName': many.first.tableName,
      'data': many,
    };

void handleFromJson(Map<String, dynamic> json,
    Function({required CRUD operation, required DataObject single})
    handleSingle,
    Function({required CRUD operation, required Iterable<DataObject> many, Type? filterType, int? filterId})
    handleMany) {
  final isMany = json['isMany'] == 'true';
  final type = getTypeFromTableName(json['tableName']);
  final Type? filterType = json['filterType'] == null ? Object : getTypeFromTableName(json['filterType']);
  final filterId = json['filterId'] == null ? null : int.parse(json['filterId']);
  if (isMany) {
    handleMany(
        operation: crudDecode(json['operation']),
        many: (json['data'] as List<Map<String, dynamic>>).map((e) => type.fromJson(e)),
        filterType: filterType,
        filterId: filterId);
  } else {
    handleSingle(operation: crudDecode(json['operation']), single: type.fromJson(json['data']));
  }
}
