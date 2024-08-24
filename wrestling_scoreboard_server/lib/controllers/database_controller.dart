import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/user_controller.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

import 'entity_controller.dart';

class DatabaseController {
  // TODO: migration should be handled automatically at server start.

  /// Reset all tables
  Future<Response> reset(Request request, User user) async {
    try {
      await _restoreDefault();
      Iterable<ShelfController> entityControllers = dataTypes.map((t) => ShelfController.getControllerFromDataType(t));
      // Remove data
      await Future.forEach(entityControllers, (e) => e.deleteMany());
      // Create default admin
      await SecuredUserController().createSingle(
          User(username: 'admin', createdAt: DateTime.now(), privilege: UserPrivilege.admin, password: 'admin')
              .toSecuredUser());
      return Response.ok('{"status": "success"}');
    } catch (err) {
      return Response.internalServerError(body: '{"err": "$err"}');
    }
  }

  /// Export a database to dump
  Future<Response> export(Request request, User user) async {
    final db = PostgresDb();
    final args = <String>[
      // '--file',
      // './database/dump/${DateTime.now().toIso8601String().replaceAll(':', '-').replaceAll(RegExp(r'\.[0-9]{3}'), '')}-'
      //     'PostgreSQL-wrestling_scoreboard-dump.sql',
      '--username',
      db.dbUser,
      '--host',
      db.postgresHost,
      '--port',
      db.postgresPort.toString(),
      '--dbname',
      db.postgresDatabaseName,
      '--schema',
      'public'
    ];
    final process = await Process.run('pg_dump', args, environment: {'PGPASSWORD': db.dbPW});

    if (process.exitCode == 0) {
      return Response.ok(process.stdout);
    } else {
      return Response.internalServerError(body: '{"err": "${process.stderr}"}');
    }
  }

  /// Restore a database dump
  Future<Response> restore(Request request, User user) async {
    try {
      final message = await request.readAsString();
      File file =
          File('${Directory.systemTemp.path}/${message.hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0')}.sql');
      await file.writeAsString(message);
      await _restore(file.path);
      return Response.ok('{"status": "success"}');
    } catch (err) {
      return Response.internalServerError(body: '{"err": "$err"}');
    }
  }

  /// Restore the default database dump
  Future<Response> restoreDefault(Request request, User user) async {
    try {
      await _restoreDefault();
      return Response.ok('{"status": "success"}');
    } catch (err) {
      return Response.internalServerError(body: '{"err": "$err"}');
    }
  }

  Future<void> _restoreDefault() => _restore('./database/dump/PostgreSQL-wrestling_scoreboard-dump.sql');

  Future<void> _restore(String dumpPath) async {
    final db = PostgresDb();
    {
      await db.connection.execute('DROP SCHEMA IF EXISTS public CASCADE;');
      await db.close();
    }

    final args = <String>[
      '--file',
      dumpPath,
      '--username',
      db.dbUser,
      '--host',
      db.postgresHost,
      '--port',
      db.postgresPort.toString(),
      db.postgresDatabaseName,
    ];
    final processResult = await Process.run('psql', args, environment: {'PGPASSWORD': db.dbPW});
    await db.open();

    Iterable<ShelfController> entityControllers = dataTypes.map((t) => ShelfController.getControllerFromDataType(t));
    await Future.forEach(entityControllers, (e) => e.init());

    if (processResult.exitCode != 0) {
      throw processResult.stderr;
    }
  }
}
