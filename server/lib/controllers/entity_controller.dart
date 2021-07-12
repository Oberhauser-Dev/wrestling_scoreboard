import 'dart:convert';

import 'package:common/common.dart';
import 'package:server/services/postgres_db.dart';
import 'package:shelf/shelf.dart';

abstract class EntityController<T> {
  String tableName;
  String primaryKeyName;

  EntityController({required this.tableName, this.primaryKeyName = 'id'});

  Future<Response> requestSingle(Request request, String id) async {
    return handleRequestSingleOfController(this, int.parse(id), isRaw: isRaw(request));
  }

  Future<T?> getSingle(int id) async {
    final single = await getSingleRaw(id);
    if (single == null) return Future.value(null);
    return parseToClass(single);
  }

  Future<Map<String, dynamic>?> getSingleRaw(int id) async {
    final res = await PostgresDb()
        .connection
        .mappedResultsQuery('SELECT * FROM $tableName WHERE $primaryKeyName = @id;', substitutionValues: {'id': id});
    final many = mapToTable(res);
    if (many.isEmpty) return Future.value(null);
    return many.first;
  }

  Future<Response> requestMany(Request request) async {
    return handleRequestManyOfController(this, isRaw: isRaw(request));
  }

  Future<List<T>> getMany({List<String>? conditions, Conjunction conjunction = Conjunction.and}) async {
    return Future.wait((await getManyRaw(conditions: conditions, conjunction: conjunction))
        .map((e) async => await parseToClass(e))
        .toList());
  }

  Future<List<T>> getManyFromQuery(String sqlQuery) async {
    return Future.wait((await getManyRawFromQuery(sqlQuery)).map((e) async => await parseToClass(e)).toList());
  }

  Future<Iterable<Map<String, dynamic>>> getManyRaw(
      {List<String>? conditions, Conjunction conjunction = Conjunction.and}) async {
    return getManyRawFromQuery(
        'SELECT * FROM $tableName ${conditions == null ? '' : 'WHERE ' + conditions.join(' ${conjunction == Conjunction.and ? 'AND' : 'OR'} ')};');
  }

  Future<Iterable<Map<String, dynamic>>> getManyRawFromQuery(String sqlQuery) async {
    final res = await PostgresDb().connection.mappedResultsQuery(sqlQuery);
    return mapToTable(res);
  }

  Future<Iterable<T>> mapToEntity(List<Map<String, Map<String, dynamic>>> res) async {
    return Future.wait(res.map((row) async {
      final e = row[tableName]!;
      return await parseToClass(e);
    }));
  }

  Iterable<Map<String, dynamic>> mapToTable(List<Map<String, Map<String, dynamic>>> res) {
    return res.map((row) => row[tableName]!);
  }

  Future<T> parseToClass(Map<String, dynamic> e);

  /*{
    throw UnimplementedError('Parsing database object $tableName to ${T.toString()} is not supported yet');
  }*/

  bool isRaw(Request request) {
    return (request.url.queryParameters['raw'] ?? '').parseBool();
  }

  static Future<Response> handleRequestSingleOfController(EntityController controller, int id,
      {bool isRaw = false}) async {
    if (isRaw) {
      final single = await controller.getSingleRaw(id);
      if (single == null) {
        return Response.notFound('Object with ID $id not found in ${controller.tableName}');
      } else {
        return Response.ok(betterJsonEncode(single));
      }
    } else {
      final single = await controller.getSingle(id);
      if (single == null) {
        return Response.notFound('Object with ID $id not found in ${controller.tableName}');
      } else {
        return Response.ok(jsonEncode(single));
      }
    }
  }

  static Future<Response> handleRequestManyOfController(EntityController controller,
      {bool isRaw = false, List<String>? conditions, Conjunction conjunction = Conjunction.and}) async {
    if (isRaw) {
      final many = await controller.getManyRaw(conditions: conditions, conjunction: conjunction);
      return Response.ok(betterJsonEncode(many.toList()));
    } else {
      final many = await controller.getMany(conditions: conditions, conjunction: conjunction);
      return Response.ok(jsonEncode(many.toList()));
    }
  }

  static Future<Response> handleRequestManyOfControllerFromQuery(EntityController controller,
      {bool isRaw = false, required String sqlQuery}) async {
    if (isRaw) {
      final many = await controller.getManyRawFromQuery(sqlQuery);
      return Response.ok(betterJsonEncode(many.toList()));
    } else {
      final many = await controller.getManyFromQuery(sqlQuery);
      return Response.ok(jsonEncode(many.toList()));
    }
  }
}

enum Conjunction {
  and,
  or,
}
