import 'dart:convert';

import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/exceptions.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/services/mail.dart';

SecuredUser parseAndCheckSecuredUser(String message) {
  var user = parseSingleJson<SecuredUser>(jsonDecode(message));
  if (!User.isValidUsername(user.username)) {
    throw InvalidParameterException('Username not valid: ${user.username}');
  }
  if (user.email != null && !User.isValidEmail(user.email!)) {
    throw InvalidParameterException('Email address not valid: ${user.email}');
  }
  user = user.copyWith(
    // Only allow lowercase usernames to be registered, to avoid confusion with other accounts.
    username: user.username.toLowerCase(),
    email: user.email?.toLowerCase(),
  );
  if (supportEmail && user.email == null) {
    throw InvalidParameterException('User $user must provide an email');
  }
  return user;
}

User parseAndCheckUser(String message) {
  var user = parseSingleJson<User>(jsonDecode(message));
  if (!User.isValidUsername(user.username)) {
    throw InvalidParameterException('Username not valid: ${user.username}');
  }
  if (user.email != null && !User.isValidEmail(user.email!)) {
    throw InvalidParameterException('Email address not valid: ${user.email}');
  }
  user = user.copyWith(
    // Only allow lowercase usernames to be registered, to avoid confusion with other accounts.
    username: user.username.toLowerCase(),
    email: user.email?.toLowerCase(),
  );
  if (supportEmail && user.email == null) {
    throw InvalidParameterException('User $user must provide an email');
  }
  return user;
}

class SecuredUserController extends ShelfController<SecuredUser> {
  static final SecuredUserController _singleton = SecuredUserController._internal();

  factory SecuredUserController() {
    return _singleton;
  }

  SecuredUserController._internal() : super();

  /// User creation endpoint for admins
  Future<Response> postRequestSingleUser(Request request, User? _) async {
    final message = await request.readAsString();
    final user = parseAndCheckUser(message);
    final id = await createSingle(user.toSecuredUser());
    broadcastUpdateMany<SecuredUser>((obfuscate) async => await SecuredUserController().getMany(obfuscate: obfuscate));
    return Response.ok(jsonEncode(id));
  }

  /// SecuredUser Update endpoint for admins, disallow setting password
  @override
  Future<Response> postRequestSingle(Request request, User? user) async {
    final message = await request.readAsString();
    SecuredUser securedUser = parseAndCheckSecuredUser(message);
    final existingSecuredUser = await getSingle(securedUser.id!, obfuscate: false);
    final needsEmailVerification = supportEmail && securedUser.email != existingSecuredUser.email;
    await updateSingle(securedUser);
    if (needsEmailVerification) {
      securedUser = await generateVerificationCode(securedUser);
      await updateSingle(securedUser);
      await sendVerificationEmail(securedUser);
    }
    broadcastUpdateSingle<SecuredUser>((obfuscate) async => securedUser);
    return Response.ok(jsonEncode(securedUser.id));
  }

  @override
  Future<int> createSingle(SecuredUser dataObject) async {
    dataObject = dataObject.copyWith(createdAt: DateTime.now());
    if (supportEmail) {
      dataObject = await generateVerificationCode(dataObject);
      final id = await super.createSingle(dataObject);
      await sendWelcomeEmail(dataObject);
      return id;
    } else {
      return super.createSingle(dataObject);
    }
  }

  /// Used to update the user for oneself
  Future<SecuredUser> updateSingleReturn(SecuredUser dataObject) async {
    final existingSecuredUser = await getSingle(dataObject.id!, obfuscate: false);

    final needsEmailVerification = supportEmail && dataObject.email != existingSecuredUser.email;

    dataObject = existingSecuredUser.copyWith(
      username: dataObject.username,
      email: dataObject.email,
      person: dataObject.person,
      passwordHash: dataObject.passwordHash ?? existingSecuredUser.passwordHash,
      salt: dataObject.salt ?? existingSecuredUser.salt,
      isEmailVerified: needsEmailVerification ? false : existingSecuredUser.isEmailVerified,
      // privilege: Do not allow raising privileges for oneself.
      // createdAt: Do not allow to set the createdAt property.
      // emailVerificationCode: Do not allow to set the emailVerificationCode property.
      // emailVerificationCodeExpirationDate: Do not allow to change.
    );
    await updateSingle(dataObject);
    if (needsEmailVerification) {
      dataObject = await generateVerificationCode(dataObject);
      await updateSingle(dataObject);
      await sendVerificationEmail(dataObject);
    }
    return dataObject;
  }

  Future<SecuredUser?> getSingleByUsername(String username) async {
    final many = await getMany(
      conditions: ['username = @username'],
      substitutionValues: {'username': username},
      obfuscate: false,
    );
    return many.zeroOrOne;
  }

  Future<SecuredUser?> getSingleByEmail(String email) async {
    final many = await getMany(conditions: ['email = @email'], substitutionValues: {'email': email}, obfuscate: false);
    return many.zeroOrOne;
  }

  final _random = MockableRandom.secure();

  Future<SecuredUser> generateVerificationCode(SecuredUser securedUser) async {
    // 7 is the biggest value in RFC 4648 base32
    final verificationCode = encodeBase32(_random.nextInt(decodeBase32('777777'))).padLeft(6, '0');
    securedUser = securedUser.copyWith(
      isEmailVerified: false,
      emailVerificationCode: verificationCode,
      emailVerificationCodeExpirationDate: MockableDateTime.now().add(Duration(minutes: 30)),
    );
    return securedUser;
  }

  Future<void> sendWelcomeEmail(SecuredUser securedUser) async {
    await sendMail(
      recipient: securedUser.email!,
      subject: 'Welcome to Wrestling Scoreboard',
      body: '''
<p>Dear <strong>${securedUser.username}</strong>,</p>
<p>Welcome aboard! We're excited to have you using <strong>Wrestling Scoreboard</strong>.</p>
<p>Please confirm your email address in your application.
 <br>Go to your Profile and click "Verify Email".
 <br>Enter the verification code below:
</p>
<p style="text-align: center; margin: 30px 0;"><code>${securedUser.emailVerificationCode}</code></p>
''',
    );
  }

  Future<void> sendVerificationEmail(SecuredUser securedUser) async {
    await sendMail(
      recipient: securedUser.email!,
      subject: 'Email verification code for Wrestling Scoreboard',
      body: '''
<p>Dear <strong>${securedUser.username}</strong>,</p>
<p>We received a request to generate a verification for your <strong>Wrestling Scoreboard</strong> account.</p>
<p>Please login with your username and verification code:</p>
<p style="text-align: center; margin: 30px 0;"><code>${securedUser.emailVerificationCode}</code></p>
<p>You are advised to use a password and change it, if necessary.</p>
''',
    );
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      // 'privilege': null,
      'password_hash': psql.Type.byteArray,
      'email_verification_code_expiration_date': psql.Type.timestampTz,
    };
  }

  @override
  UserPrivilege get controllerPrivilege => UserPrivilege.admin;
}
