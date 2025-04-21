import 'package:collection/collection.dart';
import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';
// ignore_for_file: avoid_print

void main() {
  test('Sync data object types', () {
    print(dataTypes
        .map((dataType) => getTableNameFromType(dataType))
        .sorted((a, b) => a.compareTo(b))
        .indexed
        .map((e) => '${e.$1} ${e.$2}')
        .join('\n'));
  });
}
