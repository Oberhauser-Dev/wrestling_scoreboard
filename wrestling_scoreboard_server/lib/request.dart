import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension RequestExt on Request {
  bool get isRaw {
    return (url.queryParameters['isRaw'] ?? '').parseBool();
  }

  List<String> get filterTypes {
    return (jsonDecode(url.queryParameters['filterTypes'] ?? '[]') as List<dynamic>).cast<String>();
  }

  List<int> get filterIds {
    return (jsonDecode(url.queryParameters['filterIds'] ?? '[]') as List<dynamic>).cast<int>();
  }
}
