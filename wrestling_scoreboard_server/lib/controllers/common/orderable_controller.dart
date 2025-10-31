import 'dart:convert';

import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/request.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

mixin OrderableController<T extends PosOrderable> on ShelfController<T> {
  Future<Response> postRequestReorder(Request request, User? user, String idAsStr) async {
    final id = int.tryParse(idAsStr);
    if (id == null) {
      return Response.badRequest(body: 'Id "$idAsStr" cannot be parsed');
    }

    final newPos = jsonDecode(await request.readAsString());
    if (newPos is! int) {
      return Response.badRequest(body: 'newPos "$newPos" cannot be parsed');
    }

    final filterTypes = request.filterTypes.map((ft) => getTypeFromTableName(ft)).toList();
    final filterIds = request.filterIds;
    if (filterTypes.length != filterIds.length) {
      return Response.badRequest(body: 'FilterIds and FilterTypes have a different length');
    }

    final indexedFilter = Iterable<int>.generate(filterTypes.length);
    final conditions =
        indexedFilter.map((i) => '${directDataObjectRelations[T]![filterTypes[i]]!.first.property} = @fid$i').toList();
    await _reorder(
      conditions: conditions,
      id: id,
      newPos: newPos,
      substitutionValues: {...Map.fromEntries(indexedFilter.map((i) => MapEntry('fid$i', filterIds[i])))},
    );

    // Update list of its filterType + filterId
    for (final i in indexedFilter) {
      broadcastUpdateMany<T>(
        (obfuscate) async => await getMany(
          conditions: ['${directDataObjectRelations[T]![filterTypes[i]]!.first.property} = @fid'],
          substitutionValues: {'fid': filterIds[i]},
          obfuscate: obfuscate,
        ),
        filterType: filterTypes[i],
        filterId: filterIds[i],
      );
    }

    return Response.ok('{"status": "success"}');
  }

  /// Reorder items of type [T] by respecting [orderType] as primary order, filtered by [filterType] and [filterId].
  Future<void> reorderBlocks({
    required Type orderType,
    required Type filterType,
    required int filterId,
    String? orderByStmt,
  }) async {
    final orderTable = getTableNameFromType(orderType);
    final query = '''
WITH renumbered AS (
  SELECT
    t.id,
    ROW_NUMBER() OVER (ORDER BY ${orderByStmt == null ? '' : '$orderByStmt, '}ot.pos, t.pos) - 1 AS new_pos
  FROM $tableName AS t
  JOIN $orderTable AS ot
    ON t.${directDataObjectRelations[T]![orderType]!.first.property} = ot.id
  WHERE t.${directDataObjectRelations[T]![filterType]!.first.property} = @fid
)
UPDATE $tableName AS tgt
SET pos = rn.new_pos
FROM renumbered AS rn
WHERE tgt.id = rn.id;
    ''';
    await setManyRawFromQuery(query, substitutionValues: {'fid': filterId});

    broadcastUpdateMany<T>(
      (obfuscate) async => await getMany(
        conditions: ['${directDataObjectRelations[T]![filterType]!.first.property} = @fid'],
        substitutionValues: {'fid': filterId},
        obfuscate: obfuscate,
      ),
      filterType: filterType,
      filterId: filterId,
    );
  }

  Future<void> _reorder({
    required int id,
    required int newPos,
    List<String>? conditions,
    Conjunction conjunction = Conjunction.and,
    required Map<String, dynamic>? substitutionValues,
  }) async {
    if (conditions != null && conditions.isEmpty) {
      // If the list of conditions is empty, nothing fulfills this requirement,
      // in contrast to the conditions are null, that means everything fulfills the requirement.
      return;
    }

    final queryPosOthers = '''
WITH item AS (
  SELECT pos AS old_pos
  FROM $tableName
  WHERE id = @id
)

UPDATE $tableName
SET pos = CASE
  WHEN pos >= item.old_pos AND pos <= @newPos THEN pos - 1
  WHEN pos <= item.old_pos AND pos >= @newPos THEN pos + 1
  ELSE pos
END
FROM item
WHERE id <> @id
  ${conditions == null ? '' : 'AND (${conditions.join(' ${conjunction == Conjunction.and ? 'AND' : 'OR'} ')})'}
  AND (
    (item.old_pos < @newPos AND pos >= item.old_pos AND pos <= @newPos) OR
    (item.old_pos > @newPos AND pos <= item.old_pos AND pos >= @newPos)
  );
''';

    // Finally, set our row to its new position
    final queryPosSelf = '''
UPDATE $tableName
SET pos = @newPos
WHERE id = @id;
    ''';

    final baseSubstitutionValues = {'id': id, 'newPos': newPos};
    final conn = PostgresDb().connection;
    await conn.runTx((s) async {
      final stmtPosOthers = await s.prepare(psql.Sql.named(queryPosOthers));
      await stmtPosOthers.bind({...baseSubstitutionValues, ...?substitutionValues}).toList();

      final stmtPosSelf = await s.prepare(psql.Sql.named(queryPosSelf));
      await stmtPosSelf.bind(baseSubstitutionValues).toList();
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getManyRaw({
    List<String>? conditions,
    Conjunction conjunction = Conjunction.and,
    Map<String, dynamic>? substitutionValues,
    Map<String, String> joins = const {},
    List<String> orderBy = const [],
    required bool obfuscate,
  }) {
    return super.getManyRaw(
      conditions: conditions,
      conjunction: conjunction,
      substitutionValues: substitutionValues,
      joins: joins,
      orderBy: orderBy.contains('pos') ? orderBy : [...orderBy, 'pos'],
      obfuscate: obfuscate,
    );
  }
}
