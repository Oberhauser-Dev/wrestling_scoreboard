import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/user_controller.dart';
import 'package:wrestling_scoreboard_server/services/environment.dart';

class AuthController {
  late final String jwtSecret;

  AuthController() {
    final jwtSecret = env.jwtSecret;
    if (jwtSecret == null) {
      throw Exception('JWT_SECRET not specified!');
    }
    this.jwtSecret = jwtSecret;
  }

  Future<Response> signUp(Request request) async {
    final message = await request.readAsString();
    var user = parseAndCheckUser(message);
    user = user.copyWith(
      // Do not allow setting or raising privileges for oneself.
      privilege: UserPrivilege.none,
      // Do always set the current date time as createdAt property
      createdAt: MockableDateTime.now(),
    );
    await SecuredUserController().createSingleUser(user);
    return Response.ok('{"status": "success"}');
  }

  Future<Response> updateSingle(Request request, User? user) async {
    final message = await request.readAsString();

    final updatedUser = parseAndCheckUser(message);
    if (user == null || updatedUser.id != user.id!) {
      return Response.badRequest(
        body: 'The updated user ${updatedUser.id} does not match the currently logged in user ${user?.id}',
      );
    }

    final updatedSecuredUser = updatedUser.toSecuredUser();

    SecuredUser securedUser = await SecuredUserController().getSingle(user.id!, obfuscate: false);
    securedUser = securedUser.copyWith(
      username: updatedSecuredUser.username,
      email: updatedSecuredUser.email,
      person: updatedSecuredUser.person,
      passwordHash: updatedSecuredUser.passwordHash ?? securedUser.passwordHash,
      salt: updatedSecuredUser.salt ?? securedUser.salt,
      // privilege: Do not allow raising privileges for oneself.
      // createdAt: Do not allow to set the createdAt property.
    );
    await SecuredUserController().updateSingle(securedUser);
    return Response.ok('{"status": "success"}');
  }

  Future<Response> requestUser(Request request, User? user) async {
    return Response.ok(jsonEncode(user));
  }

  Future<Response> signIn(Request request) async {
    final authorizationHeader = request.headers['authorization'];
    if (authorizationHeader == null) return Response.badRequest(body: 'No authorization header provided.');
    final authService = BasicAuthService.fromHeader(authorizationHeader);

    final user = await SecuredUserController().getSingleByUsername(authService.username);
    if (user == null) return Response.badRequest(body: 'No user found with username "${authService.username}".');

    if (!user.checkPassword(authService.password)) {
      return Response.badRequest(body: 'Password incorrect for username "${authService.username}".');
    }
    final String token = _signToken(user);
    return Response.ok(token);
  }

  String _signToken(SecuredUser user) {
    final int jwtExpiresInDays = env.jwtExpiresInDays ?? 90;
    final jwtIssuer = env.jwtIssuer ?? 'Wrestling Scoreboard (oberhauser.dev)';

    final jwt = JWT(
      // Payload
      {'id': user.id, 'username': user.username},
      subject: '${user.id}',
      issuer: jwtIssuer,
    );
    final token = jwt.sign(SecretKey(jwtSecret), expiresIn: Duration(days: jwtExpiresInDays));
    return token;
  }
}

extension AuthUserExtension on User {
  bool get obfuscate => privilege <= UserPrivilege.none;
}
