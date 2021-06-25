import 'dart:convert';

import 'package:server/mocks/mocks.dart';
import 'package:shelf/shelf.dart';

Future<Response> teamRequest(Request request, String id) async {
  return Response.ok(jsonEncode(getTeams().singleWhere((element) => element.id == id)));
}

Future<Response> teamsRequest(Request request) async {
  return Response.ok(jsonEncode(getTeams()));
}
