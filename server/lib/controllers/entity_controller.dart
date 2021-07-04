import 'package:common/common.dart';
import 'package:server/services/postgres_db.dart';
import 'package:shelf/shelf.dart';

abstract class EntityController<T> {
  String tableName;
  String primaryKeyName;

  EntityController({required this.tableName, this.primaryKeyName = 'id'});

  Future<Map<String, dynamic>?> getSingleRest(int id) async {
    final res = await PostgresDb()
        .connection
        .mappedResultsQuery('SELECT * FROM $tableName WHERE $primaryKeyName = @id', substitutionValues: {'id': id});
    final multiple = mapToRest(res);
    if (multiple.isEmpty) return Future.value(null);
    return multiple.first;
  }

  Future<T?> getSingle(int id) async {
    final single = await getSingleRest(id);
    if (single == null) return Future.value(null);
    return parseToClass(single);
  }

  Future<Response> requestSingle(Request request, String id) async {
    final obj = await getSingleRest(int.parse(id));
    if (obj == null) {
      return Response.notFound('Object with ID $id not found in $tableName');
    } else {
      return Response.ok(betterJsonEncode(obj));
    }
  }

  Future<Iterable<Map<String, dynamic>>> getMultipleRest() async {
    final res = await PostgresDb().connection.mappedResultsQuery('SELECT * FROM $tableName');
    return mapToRest(res);
  }

  Future<List<T>> getMultiple() async {
    return Future.wait((await getMultipleRest()).map((e) async => await parseToClass(e)).toList());
  }

  Future<Response> requestMultiple(Request request) async {
    final multiple = await getMultipleRest();
    return Response.ok(betterJsonEncode(multiple.toList()));
  }

  Future<Iterable<T>> mapToEntity(List<Map<String, Map<String, dynamic>>> res) async {
    return Future.wait(res.map((row) async {
      final e = row[tableName]!;
      return await parseToClass(e);
    }));
  }

  Iterable<Map<String, dynamic>> mapToRest(List<Map<String, Map<String, dynamic>>> res) {
    return res.map((row) => row[tableName]!);
  }

  Future<T> parseToClass(Map<String, dynamic> e) {
    throw UnimplementedError('Parsing database object $tableName to ${T.toString()} is not supported yet');
  }
}
