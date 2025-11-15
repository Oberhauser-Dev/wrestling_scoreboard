import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/controllers/user_controller.dart';
import 'package:wrestling_scoreboard_server/services/environment.dart';
import 'package:wrestling_scoreboard_server/services/mail.dart';

class AuthController {
  late final String jwtSecret;

  AuthController() {
    final jwtSecret = env.jwtSecret;
    if (jwtSecret == null) {
      throw Exception('JWT_SECRET not specified!');
    }
    this.jwtSecret = jwtSecret;
  }

  Future<Response> requestVerificationCode(Request request) async {
    if (!supportEmail) {
      return Response.badRequest(body: 'Requesting a verification code is not supported on this server.');
    }
    final message = await request.readAsString();
    final verificationCodeRequest = VerificationCodeRequest.fromJson(jsonDecode(message));

    // Do sending without awaiting to not give an attacker the possibility to find out if the email is correct.
    (() async {
      SecuredUser? securedUser = await SecuredUserController().getSingleByUsername(verificationCodeRequest.username!);
      // Return silently, if email is incorrect the user should not get a feedback.
      if (securedUser == null) return;
      securedUser = await SecuredUserController().generateVerificationCode(securedUser);
      await SecuredUserController().updateSingle(securedUser);
      await SecuredUserController().sendVerificationEmail(securedUser);
    })();
    return Response.ok('{"status": "success"}');
  }

  Future<Response> signUp(Request request) async {
    final message = await request.readAsString();
    var user = parseAndCheckUser(message);
    user = user.copyWith(
      // Do not allow verify the email upfront.
      isEmailVerified: false,
      // Do not allow setting or raising privileges for oneself.
      privilege: UserPrivilege.none,
      // Do always set the current date time as createdAt property.
      createdAt: MockableDateTime.now(),
    );
    await SecuredUserController().createSingle(user.toSecuredUser());
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
    final securedUser = await SecuredUserController().updateSingleReturn(updatedSecuredUser);

    unicastUpdateSingle<SecuredUser>((obfuscate) async => securedUser, user: user);
    return Response.ok('{"status": "success"}');
  }

  Future<Response> deleteSingle(Request request, User? user) async {
    if (user == null) {
      return Response.badRequest(body: 'The user to be deleted does not exist');
    }
    if (user.privilege >= UserPrivilege.admin) {
      return Response.badRequest(
        body: '''As admin you cannot delete your own account.
This prevents accidentally excluding access to the system.
Ask another admin to remove you.''',
      );
    }
    await SecuredUserController().deleteSingle(user.id!);
    return Response.ok('{"status": "success"}');
  }

  Future<Response> requestUser(Request request, User? user) async {
    return Response.ok(jsonEncode(user));
  }

  Future<Response> signIn(Request request) async {
    final authorizationHeader = request.headers['authorization'];
    if (authorizationHeader == null) return Response.badRequest(body: 'No authorization header provided.');
    final authService = BasicAuthService.fromHeader(authorizationHeader);

    // Use the same response for username or password, so an attacker cannot differentiate which email is registered.
    final badUserOrPasswordResponse = Response.badRequest(body: 'Username or password incorrect.');
    final securedUser = await SecuredUserController().getSingleByUsername(authService.username);
    if (securedUser == null) return badUserOrPasswordResponse;

    if (!securedUser.checkPassword(authService.password)) {
      return badUserOrPasswordResponse;
    }
    final String token = _signToken(securedUser);
    return Response.ok(token);
  }

  Future<Response> signInVerification(Request request) async {
    final message = await request.readAsString();
    final userVerification = UserVerification.fromJson(jsonDecode(message));
    if (!supportEmail || userVerification.method != VerificationMethod.email) {
      return Response.badRequest(
        body: 'Verification method "${userVerification.method}" is not supported at the moment.',
      );
    }
    final securedUser = await SecuredUserController().getSingleByUsername(userVerification.username);
    if (securedUser != null &&
        // Also allow already verified emails to authenticate
        securedUser.emailVerificationCode != null &&
        securedUser.emailVerificationCode!.isNotEmpty &&
        securedUser.emailVerificationCode == userVerification.verificationCode &&
        securedUser.emailVerificationCodeExpirationDate != null &&
        securedUser.emailVerificationCodeExpirationDate!.isAfter(MockableDateTime.now())) {
      await SecuredUserController().updateSingle(
        securedUser.copyWith(
          isEmailVerified: true,
          emailVerificationCode: null,
          emailVerificationCodeExpirationDate: null,
        ),
      );
      final String token = _signToken(securedUser);
      return Response.ok(token);
    }
    // Do not state whether the user or the verification code is valid, to not give attackers a chance to detect valid usernames.
    return Response.badRequest(body: 'User or verification code not valid.');
  }

  String _signToken(SecuredUser user) {
    final int jwtExpiresInDays = env.jwtExpiresInDays ?? 90;
    final jwtIssuer = env.issuer ?? 'Wrestling Scoreboard (oberhauser.dev)';

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
