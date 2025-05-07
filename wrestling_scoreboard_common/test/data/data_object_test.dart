import 'package:collection/collection.dart';
import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';
// ignore_for_file: avoid_print

void main() {
  test('Conversion of data types to table names', () {
    for (final dataType in dataTypes) {
      expect(dataType, getTypeFromTableName(getTableNameFromType(dataType)));
    }

    final sortedTableNames = dataTypes
        .map((dataType) => getTableNameFromType(dataType))
        .sorted((a, b) => a.compareTo(b));
    print(sortedTableNames.indexed.map((e) => '${e.$1} ${e.$2}').join('\n'));
  });

  test('Handle generic json', () async {
    Future<int> handleSingle<T extends DataObject>({required CRUD operation, required T single}) async {
      return single.id!;
    }

    Future<int> handleSingleRaw<T extends DataObject>({
      required CRUD operation,
      required Map<String, dynamic> single,
    }) async {
      return single['id'];
    }

    Future<void> handleMany<T extends DataObject>({required CRUD operation, required ManyDataObject<T> many}) async {}

    Future<void> handleManyRaw<T extends DataObject>({
      required CRUD operation,
      required ManyDataObject<Map<String, dynamic>> many,
    }) async {}

    for (final dataType in dataTypes) {
      await handleGenericJson(
        singleToJson({'id': 0}, dataType, CRUD.read),
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw,
      );
    }
  });
}
