import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_server/controllers/common/exceptions.dart';

final errorPipelineConfig = createMiddleware(
  errorHandler: (error, st) {
    if (error is InvalidParameterException) return Response.badRequest(body: error.message);
    throw error;
  },
);
