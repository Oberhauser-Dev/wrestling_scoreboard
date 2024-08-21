// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:dotenv/dotenv.dart' show DotEnv;
import 'package:logging/logging.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart' as shelf_static;
import 'package:wrestling_scoreboard_server/controllers/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/routes/api_route.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

import 'middleware/cors.dart';

final env = DotEnv();

Pubspec? pubspec;

Future<Pubspec> _parsePubspec() async {
  if (pubspec == null) {
    final file = File('pubspec.yaml');
    if (await file.exists()) {
      pubspec = Pubspec.parse(await file.readAsString());
    } else {
      throw FileSystemException('No file found', file.absolute.path);
    }
  }
  return pubspec!;
}

Future init() async {
  env.load(); // Load dotenv variables
  await _parsePubspec();

  // Init logger
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    print('[${record.time}] ${record.level.name}: ${record.message}');
    if (record.error != null) {
      print('Error: ${record.error}');
      if (record.stackTrace != null) {
        print('StackTrace: ${record.stackTrace}');
      }
    }
  });

  // If the "PORT" environment variable is set, listen to it. Otherwise, 8080.
  // https://cloud.google.com/run/docs/reference/container-contract#port
  final port = int.parse(env['PORT'] ?? '8080');

  // Must open the database before initializing any routes.
  await PostgresDb().open();

  // Router instance to handler requests.
  final router = shelf_router.Router()
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
    })
    ..mount('/about', (Request request) async {
      final pubspec = await _parsePubspec();
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
    env['HOST'] ?? InternetAddress.anyIPv4, // Allows external connections
    port,
  );

  final serverUrl = 'http://${server.address.host}:${server.port}';
  print('Serving at $serverUrl');
  print('Serving API at $serverUrl/api');
  print('Serving Websocket at $serverUrl/ws');
}
