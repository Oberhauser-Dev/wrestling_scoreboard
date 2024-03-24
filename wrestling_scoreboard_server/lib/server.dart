// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:dotenv/dotenv.dart' show DotEnv;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart' as shelf_static;
import 'package:wrestling_scoreboard_server/controllers/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/routes/api_route.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

import 'middleware/cors.dart';

final env = DotEnv();

Future init() async {
  env.load(); // Load dotenv variables

  // If the "PORT" environment variable is set, listen to it. Otherwise, 8080.
  // https://cloud.google.com/run/docs/reference/container-contract#port
  final port = int.parse(env['PORT'] ?? '8080');

  // See https://pub.dev/documentation/shelf/latest/shelf/Cascade-class.html
  final cascade = Cascade()
      // First, serve files from the 'public' directory
      .add(_staticHandler)
      // If a corresponding file is not found, send requests to a `Router`
      .add(_router);

  // See https://pub.dev/documentation/shelf/latest/shelf/Pipeline-class.html
  final pipeline = Pipeline()
      // See https://pub.dev/documentation/shelf/latest/shelf/logRequests.html
      .addMiddleware(corsConfig)
      .addMiddleware(logRequests())
      .addHandler(cascade.handler);

  // See https://pub.dev/documentation/shelf/latest/shelf_io/serve.html
  final server = await shelf_io.serve(
    pipeline,
    env['HOST'] ?? InternetAddress.anyIPv4, // Allows external connections
    port,
  );

  await PostgresDb().open();

  final serverUrl = 'http://${server.address.host}:${server.port}';
  print('Serving at $serverUrl');
  print('Serving API at $serverUrl/api');
  print('Serving Websocket at $serverUrl/ws');
}

// Serve files from the file system.
final _staticHandler = shelf_static.createStaticHandler('public', defaultDocument: 'index.html');

// Router instance to handler requests.
final _router = shelf_router.Router()
  ..mount('/api', ApiRoute().pipeline)
  ..mount('/ws', (Request request) {
    try {
      return websocketHandler(request);
    } on HijackException catch (error, _) {
      // A HijackException should bypass the response-writing logic entirely.
      print('Warning: HijackException thrown on WebsocketHandler.\n$error');
      // TODO hide stack trace or handle better
      // Exception is handled here: https://pub.dev/documentation/shelf/latest/shelf_io/handleRequest.html
      rethrow;
    } catch (error, _) {
      print('Error thrown by handler.\n$error');
      return Response.internalServerError();
    }
  });
