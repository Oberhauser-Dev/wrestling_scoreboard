import 'package:server/server.dart';
import 'package:shelf/shelf.dart';

final corsHeaders = {
  'Access-Control-Allow-Origin': env['CORS_ALLOW_ORIGIN'] ?? '*',
  'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS, PUT',
  'Access-Control-Allow-Headers': '*',
};

Response? _options(Request request) => (request.method == 'OPTIONS') ? Response.ok(null, headers: corsHeaders) : null;

Response _cors(Response response) => response.change(headers: corsHeaders);

final corsConfig = createMiddleware(requestHandler: _options, responseHandler: _cors);
