import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_server/services/environment.dart';

final corsHeaders = {
  'Access-Control-Allow-Origin': env.corsAllowOrigin ?? '*',
  'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS, PUT',
  'Access-Control-Allow-Headers': '*',
};

Response? _options(Request request) => (request.method == 'OPTIONS') ? Response.ok(null, headers: corsHeaders) : null;

Response _cors(Response response) => response.change(headers: corsHeaders);

final corsConfig = createMiddleware(requestHandler: _options, responseHandler: _cors);
