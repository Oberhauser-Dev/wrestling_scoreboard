// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart' as shelf_static;
import 'package:wrestling_scoreboard_server/controllers/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/routes/api_route.dart';
import 'package:wrestling_scoreboard_server/services/environment.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';
import 'package:wrestling_scoreboard_server/services/pubspec.dart';

import 'middleware/cors.dart';

Future<HttpServer> init() async {
  // Init logger
  Logger.root.level = env.logLevel ?? Level.INFO;
  Logger.root.onRecord.listen(
    (record) async {
      String text = '[${record.time}] ${record.level.name}: ${record.message}';
      if (record.error != null) {
        text += '\nError: ${record.error}';
        if (record.stackTrace != null) {
          text += 'StackTrace: ${record.stackTrace}';
        }
      }
      text = switch (record.level) {
        Level.FINEST => '\x1B[38;5;247m$text\x1B[0m',
        Level.FINER => '\x1B[38;5;248m$text\x1B[0m',
        Level.FINE => '\x1B[38;5;249m$text\x1B[0m',
        Level.CONFIG => '\x1B[34m$text\x1B[0m',
        Level.WARNING => '\x1B[33m$text\x1B[0m',
        Level.SEVERE || Level.SHOUT => '\x1B[31m$text\x1B[0m',
        _ => text,
      };
      print(text);
    },
  );

  // If the "PORT" environment variable is set, listen to it. Otherwise, 8080.
  // https://cloud.google.com/run/docs/reference/container-contract#port
  final port = env.port ?? 8080;

  // Must open the database before initializing any routes.
  final db = PostgresDb();
  await db.open();
  await db.migrate();

  final webSocketLog = Logger('Websocket');

  // Router instance to handler requests.
  final router = shelf_router.Router()
    ..mount('/api', ApiRoute().pipeline)
    ..mount('/ws', (Request request) {
      try {
        return websocketHandler(request);
      } on HijackException catch (error, _) {
        // A HijackException should bypass the response-writing logic entirely.
        webSocketLog.warning('Warning: HijackException thrown on WebsocketHandler.\n$error');
        // TODO hide stack trace or handle better
        // Exception is handled here: https://pub.dev/documentation/shelf/latest/shelf_io/handleRequest.html
        rethrow;
      } catch (error, _) {
        webSocketLog.severe('Error thrown by Websocket Handler handler.\n$error');
        return Response.internalServerError();
      }
    })
    ..mount('/about', (Request request) async {
      final pubspec = await parsePubspec();
      return Response.ok('''
    Name: ${pubspec.name}
    Description: ${pubspec.description}
    Version: ${pubspec.version}
    ''');
    });

  // Serve files from the file system.
  final staticHandler = shelf_static.createStaticHandler('public', defaultDocument: 'index.html');

  // See https://pub.dev/documentation/shelf/latest/shelf/Cascade-class.html
  final cascade = Cascade()
      // First, serve files from the 'public' directory
      .add(staticHandler)
      // If a corresponding file is not found, send requests to a `Router`
      .add(router.call);

  // See https://pub.dev/documentation/shelf/latest/shelf/Pipeline-class.html
  final pipeline = Pipeline()
      // See https://pub.dev/documentation/shelf/latest/shelf/logRequests.html
      .addMiddleware(corsConfig)
      .addMiddleware(logRequests())
      .addHandler(cascade.handler);

  // See https://pub.dev/documentation/shelf/latest/shelf_io/serve.html
  final server = await shelf_io.serve(
    pipeline,
    env.host ?? InternetAddress.anyIPv4, // Allows external connections
    port,
  );

  final serverLog = Logger('Server');

  final serverUrl = 'http://${server.address.host}:${server.port}';
  serverLog.info('\n\n############## Server started at ${DateTime.now().toIso8601String()} ###########\n');
  serverLog.info('Serving at $serverUrl');
  serverLog.info('Serving API at $serverUrl/api');
  serverLog.info('Serving Websocket at $serverUrl/ws');

  return server;
}
