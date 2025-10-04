import 'dart:async';

import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:stack_trace/stack_trace.dart';

final _logger = Logger('RequestLogger');

// See https://pub.dev/documentation/shelf/latest/shelf/logRequests.html
// https://github.com/dart-lang/shelf/blob/f30d65034a868530a9aa9ada7c3067d22fa01185/pkgs/shelf/lib/src/middleware/logger.dart
Handler loggingConfig(Handler innerHandler) {
  return (request) {
    final startTime = DateTime.now();
    final watch = Stopwatch()..start();

    return Future.sync(() => innerHandler(request)).then(
      (response) async {
        final msg = _message(startTime, response.statusCode, request.requestedUri, request.method, watch.elapsed);

        if (response.statusCode >= 500) {
          _logger.severe(msg);
        } else if (response.statusCode >= 400) {
          _logger.fine(msg);
        } else {
          _logger.finer(msg);
        }

        return response;
      },
      onError: (Object error, StackTrace? stackTrace) {
        if (error is HijackException) throw error;

        final msg = _errorMessage(startTime, request.requestedUri, request.method, watch.elapsed);
        var chain = Chain.current();
        if (stackTrace != null) {
          chain = Chain.forTrace(stackTrace).foldFrames((frame) => frame.isCore || frame.package == 'shelf').terse;
        }
        _logger.severe(msg, error, chain);
        throw error;
      },
    );
  };
}

String _formatQuery(String query) {
  return query == '' ? '' : '?$query';
}

String _message(DateTime requestTime, int statusCode, Uri requestedUri, String method, Duration elapsedTime) {
  return '${requestTime.toIso8601String()} '
      '${elapsedTime.toString().padLeft(15)} '
      '${method.padRight(7)} [$statusCode] ' // 7 - longest standard HTTP method
      '${requestedUri.path}${_formatQuery(requestedUri.query)}';
}

String _errorMessage(DateTime requestTime, Uri requestedUri, String method, Duration elapsedTime) {
  return '$requestTime\t$elapsedTime\t$method\t${requestedUri.path}'
      '${_formatQuery(requestedUri.query)}';
}
