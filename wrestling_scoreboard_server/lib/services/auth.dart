import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/user_controller.dart';
import 'package:wrestling_scoreboard_server/server.dart';

extension AuthRequest on Request {
  Future<Response> restricted({
    required UserPrivilege privilege,
    required Future<Response> Function(Request request, User? user) handler,
  }) async {
    final authorizationHeader = headers['authorization'];
    if (authorizationHeader == null) {
      if (privilege > UserPrivilege.none) {
        return Response.unauthorized('No authorization header provided.');
      } else {
        return handler(this, null);
      }
    }

    final authService = BearerAuthService.fromHeader(authorizationHeader);
    try {
      final user = await authService.getUser();
      if (user == null) {
        return Response.unauthorized('User not found from JWT token.');
      }
      if (user.privilege < privilege) {
        return Response.forbidden(
            'You don\'t have the permission for this request. Ask the administrator in order to give you access.');
      }
      return handler(this, user);
    } on JWTExpiredException {
      return Response.unauthorized('JWT token expired');
    } on JWTException catch (ex) {
      return Response.badRequest(body: 'JWTException was thrown : $ex');
    }
  }
}

final jwtSecret = env['JWT_SECRET'];

extension UserFromAuthService on BearerAuthService {
  Future<User?> getUser() async {
    if (jwtSecret == null) {
      throw Exception('JWT_SECRET not specified!');
    }
    final jwt = JWT.verify(token, SecretKey(jwtSecret!));
    final user = await SecuredUserController().getSingleByUsername(jwt.payload['username'] as String);
    return user?.toUser();
  }
}
