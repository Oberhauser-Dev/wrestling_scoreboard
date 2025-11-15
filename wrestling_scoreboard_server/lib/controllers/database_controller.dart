import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/services/mail.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

final _logger = Logger('DatabaseController');

class DatabaseController {
  /// Reset all tables
  Future<Response> reset(Request request, User? user) async {
    try {
      await PostgresDb().reset();
      return Response.ok('{"status": "success"}');
    } catch (err, stackTrace) {
      _logger.severe('Resetting the database FAILED', err, stackTrace);
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
      await PostgresDb().restoreFromString(message);
      await PostgresDb().migrate();
      return Response.ok('{"status": "success"}');
    } catch (err, stackTrace) {
      _logger.severe('Restoring the database FAILED', err, stackTrace);
      return Response.internalServerError(body: '{"err": "$err"}');
    }
  }

  /// Restore the default database dump
  Future<Response> restorePrepopulated(Request request, User? user) async {
    try {
      await PostgresDb().restorePrepopulated();
      return Response.ok('{"status": "success"}');
    } catch (err, stackTrace) {
      _logger.severe('Restoring the prepopulated database FAILED', err, stackTrace);
      return Response.internalServerError(body: '{"err": "$err"}');
    }
  }

  @Deprecated('Use getRemoteConfig instead. Can be removed as soon as minimum client version is above 0.3.9')
  Future<Response> getMigration(Request request) async {
    try {
      final migration = await PostgresDb().getMigration();
      return Response.ok(jsonEncode(migration));
    } catch (err, stackTrace) {
      _logger.severe('Getting migration of the database FAILED', err, stackTrace);
      return Response.internalServerError(body: '{"err": "$err"}');
    }
  }

  /// Get information about the server requirements
  Future<Response> getRemoteConfig(Request request) async {
    try {
      final migration = await PostgresDb().getMigration();
      final remoteConfig = RemoteConfig(migration: migration, hasEmailVerification: supportEmail);
      return Response.ok(jsonEncode(remoteConfig));
    } catch (err, stackTrace) {
      _logger.severe('Getting remote config of the database FAILED', err, stackTrace);
      return Response.internalServerError(body: '{"err": "$err"}');
    }
  }
}
