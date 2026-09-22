import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:wrestling_scoreboard_common/common.dart';

final _random = Random();

Future<http.Response> retryRequest({
  required Future<http.Response> Function() runAsync,
  int? attempts,
  Duration? timeout,
  Duration? retryBaseDelay,
}) async {
  return await retry(
    runAsync: () async {
      final result = await runAsync();
      if (result.statusCode == 429) {
        throw Exception('StatusCode ${result.statusCode}: ${result.reasonPhrase}.');
      }
      return result;
    },
    attempts: attempts,
    timeout: timeout,
    // Avoid retrying every request at the same time.
    retryBaseDelay: retryBaseDelay ?? Duration(milliseconds: _random.nextInt(1000)),
  );
}
