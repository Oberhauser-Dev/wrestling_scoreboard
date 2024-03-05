import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

import 'entity_controller.dart';

class DatabaseController {
  /// Reset all tables
  Future<Response> reset(Request request) async {
    try {
      await _restoreDefault();
      Iterable<EntityController> entityControllers =
          dataTypes.map((t) => EntityController.getControllerFromDataType(t));
      await Future.forEach(entityControllers, (e) => e.deleteMany());
      return Response.ok('{"status": "success"}');
    } catch (err) {
      return Response.internalServerError(body: '{"err": "$err"}');
    }
  }

  /// Upgrade the existing database
  Future<Response> upgrade(Request request) async {
    return Response.notFound('{"status": "not yet implemented"}');
  }

  /// Restore a database dump
  Future<Response> export(Request request) async {
    final db = PostgresDb();
    final args = <String>[
      '--file',
      './database/dump/${DateTime.now().toIso8601String().replaceAll(':', '-').replaceAll(RegExp(r'\.[0-9]{3}'), '')}-'
          'PostgreSQL-wrestling_scoreboard-dump.sql',
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
      return Response.ok('{"status": "success"}');
    } else {
      return Response.internalServerError(body: '{"err": "${process.stderr}"}');
    }
  }

  /// Restore the default database dump
  Future<Response> restoreDefault(Request request) async {
    try {
      await _restoreDefault();
      return Response.ok('{"status": "success"}');
    } catch (err) {
      return Response.internalServerError(body: '{"err": "$err"}');
    }
  }

  Future<void> _restoreDefault() async {
    final db = PostgresDb();
    final conn = db.connection;
    {
      await conn.execute('DROP SCHEMA IF EXISTS public CASCADE;');
      await db.close();
    }

    final args = <String>[
      '--file',
      './database/dump/PostgreSQL-wrestling_scoreboard-dump.sql',
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

    if (processResult.exitCode != 0) {
      throw processResult.stderr;
    }
  }
}
