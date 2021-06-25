import 'dart:convert';

import 'package:server/mocks/mocks.dart';
import 'package:shelf/shelf.dart';

Future<Response> clubRequest(Request request, String id) async {
  return Response.ok(jsonEncode(getClubs().singleWhere((element) => element.id == id)));
}

Future<Response> clubsRequest(Request request) async {
  return Response.ok(jsonEncode(getClubs()));
}
