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

void handleFromJson(
    Map<String, dynamic> json,
    void Function<U extends DataObject>({required CRUD operation, required U single}) handleSingle,
    void Function<V extends DataObject>({required CRUD operation, required ManyDataObject<V> many}) handleMany) {
  final isMany = json['isMany'] == 'true';
  final type = getTypeFromTableName(json['tableName']);
  final operation = CrudParser.valueOf(json['operation']);
  if (isMany) {
    final List data = json['data'];
    final Type? filterType = json['filterType'] == null ? Object : getTypeFromTableName(json['filterType']);
    final int? filterId = json['filterId'];
    handleMany(
        operation: operation,
        many: ManyDataObject(
            data: (data.map((e) => e as Map<String, dynamic>)).map((e) => type.fromJson(e)),
            filterType: filterType ?? Object,
            filterId: filterId));
  } else {
    handleSingle(operation: operation, single: type.fromJson(json['data']));
  }
}

class ManyDataObject<T extends DataObject> {
  Iterable<T> data;
  final Type filterType;
  final int? filterId;

  ManyDataObject({required this.data, this.filterType = Object, this.filterId});
}
