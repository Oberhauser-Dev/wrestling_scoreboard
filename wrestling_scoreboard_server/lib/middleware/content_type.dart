import 'package:shelf/shelf.dart';

final contentTypeJsonHeader = {'content-type': 'application/json'};

Response _responseHandler(Response response) => response.change(headers: contentTypeJsonHeader);

final contentTypeJsonConfig = createMiddleware(responseHandler: _responseHandler);
