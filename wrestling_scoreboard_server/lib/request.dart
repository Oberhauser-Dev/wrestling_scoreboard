import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension RequestExt on Request {
  bool get isRaw {
    return (url.queryParameters['isRaw'] ?? '').parseBool();
  }
}
