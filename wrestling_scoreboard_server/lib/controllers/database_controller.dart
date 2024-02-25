import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

import 'entity_controller.dart';

class DatabaseController {
  /// Reset all tables
  Future<Response> reset(Request request) async {
    Iterable<EntityController> entityControllers = dataTypes.map((t) => EntityController.getControllerFromDataType(t));
    await Future.forEach(entityControllers, (e) => e.deleteMany());
    return Response.ok('{"status": "success"}');
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

  /// Restore a database dump
  Future<Response> restore(Request request) async {
    final db = PostgresDb();
    final conn = db.connection;
    try {
      await conn.execute('DROP SCHEMA IF EXISTS public CASCADE;');
      await db.close();
      // await conn.execute('CREATE SCHEMA public;');
      // await conn.execute('GRANT ALL ON SCHEMA public TO postgres;');
      // await conn.execute('GRANT ALL ON SCHEMA public TO public;');
    } catch (e) {
      return Response.internalServerError(body: '{"err": "$e"}');
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
    final process = await Process.run('psql', args, environment: {'PGPASSWORD': db.dbPW});

    // final dumpFile = File('./database/dump/PostgreSQL-wrestling_scoreboard-dump.sql');
    // final dumpContent = await dumpFile.readAsLines();
    // dumpContent.removeWhere((element) => element.isEmpty);
    // dumpContent.removeWhere((element) => element.startsWith('--'));
    // final dumpStr = dumpContent.reduce((value, element) => value + element);
    // final sqls = dumpStr.split(';');
    // for (var sql in sqls) {
    //   try {
    //     await conn.execute('$sql;');
    //   } catch (_) {
    //     print('Executed SQL command: $sql');
    //     rethrow;
    //   }
    // }
    await db.open();
    if (process.exitCode == 0) {
      return Response.ok('{"status": "success"}');
    } else {
      return Response.internalServerError(body: '{"err": "${process.stderr}"}');
    }
  }
}
