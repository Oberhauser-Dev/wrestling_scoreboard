import 'package:shelf/shelf.dart';

Future<Response> clubRequest(Request request) async {
  return Response.ok('[Club1, Club2]'); // TODO fetch from mocks
}
