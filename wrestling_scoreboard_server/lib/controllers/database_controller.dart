import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

class DatabaseController {
  /// Reset all tables
  Future<Response> reset(Request request, User? user) async {
    try {
      await PostgresDb().reset();
      return Response.ok('{"status": "success"}');
    } catch (err) {
      return Response.internalServerError(body: '{"err": "$err"}');
    }
  }

  /// Export a database to dump
  Future<Response> export(Request request, User? user) async {
    final sqlStr = await PostgresDb().export();
    return Response.ok(sqlStr);
  }

  /// Restore a database dump
  Future<Response> restore(Request request, User? user) async {
    try {
      final message = await request.readAsString();
      File file =
          File('${Directory.systemTemp.path}/${message.hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0')}.sql');
      await file.writeAsString(message);
      await PostgresDb().restore(file.path);
      return Response.ok('{"status": "success"}');
    } catch (err) {
      return Response.internalServerError(body: '{"err": "$err"}');
    }
  }

  /// Restore the default database dump
  Future<Response> restoreDefault(Request request, User? user) async {
    try {
      await PostgresDb().restoreDefault();
      return Response.ok('{"status": "success"}');
    } catch (err) {
      return Response.internalServerError(body: '{"err": "$err"}');
    }
  }
}
