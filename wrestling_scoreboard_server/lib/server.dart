// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart' as shelf_static;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/middleware/cors.dart';
import 'package:wrestling_scoreboard_server/middleware/logging.dart';
import 'package:wrestling_scoreboard_server/routes/api_route.dart';
import 'package:wrestling_scoreboard_server/services/environment.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';
import 'package:wrestling_scoreboard_server/services/pubspec.dart';

Future<HttpServer> init() async {
  // Init logger
  Logger.root.level = env.logLevel ?? Level.INFO;
  Logger.root.onRecord.listen((record) => print(record.formatted));

  // If the "PORT" environment variable is set, listen to it. Otherwise, 8080.
  // https://cloud.google.com/run/docs/reference/container-contract#port
  final port = env.port ?? 8080;

  // Must open the database before initializing any routes.
  final db = PostgresDb();
  await db.open();
  await db.migrate();

  final webSocketLog = Logger('Websocket');

  // Router instance to handler requests.
  final router =
      shelf_router.Router()
        ..mount('/api', ApiRoute().pipeline)
        ..mount('/ws', (Request request) {
          try {
            return websocketHandler(request);
          } on HijackException catch (error, _) {
            // A HijackException should bypass the response-writing logic entirely.
            webSocketLog.warning(
              'Warning: HijackException thrown on WebsocketHandler.',
              error,
              // stackTrace: We do not log the stackTrace as it does not give any more value
            );
            // TODO hide stack trace or handle better
            // Exception is handled here: https://pub.dev/documentation/shelf/latest/shelf_io/handleRequest.html
            rethrow;
          } catch (error, stackTrace) {
            webSocketLog.severe('Error thrown by Websocket Handler handler.', error, stackTrace);
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

  final serverLog = Logger('Server');

  // See https://pub.dev/documentation/shelf/latest/shelf/Pipeline-class.html
  final pipeline = Pipeline().addMiddleware(corsConfig).addMiddleware(loggingConfig).addHandler(cascade.handler);

  // See https://pub.dev/documentation/shelf/latest/shelf_io/serve.html
  final server = await shelf_io.serve(
    pipeline,
    env.host ?? InternetAddress.anyIPv4, // Allows external connections
    port,
  );

  final serverUrl = 'http://${server.address.host}:${server.port}';
  serverLog.info('\n\n############## Server started at ${DateTime.now().toIso8601String()} ###########\n');
  serverLog.info('Serving at $serverUrl');
  serverLog.info('Serving API at $serverUrl/api');
  serverLog.info('Serving Websocket at $serverUrl/ws');

  return server;
}
