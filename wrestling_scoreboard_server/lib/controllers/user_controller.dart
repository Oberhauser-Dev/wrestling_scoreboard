import 'dart:convert';

import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/exceptions.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/websocket_handler.dart';

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
  return user;
}

class SecuredUserController extends ShelfController<SecuredUser> {
  static final SecuredUserController _singleton = SecuredUserController._internal();

  factory SecuredUserController() {
    return _singleton;
  }

  SecuredUserController._internal() : super();

  Future<Response> postSingleUser(Request request, User? user) async {
    final message = await request.readAsString();
    final user = parseAndCheckUser(message);
    final id = await createSingleUser(user);
    broadcastUpdateMany<SecuredUser>((obfuscate) async => await SecuredUserController().getMany(obfuscate: obfuscate));
    return Response.ok(jsonEncode(id));
  }

  Future<int> createSingleUser(User user) async {
    user = user.copyWith(createdAt: DateTime.now());
    return await SecuredUserController().createSingle(user.toSecuredUser());
  }

  Future<SecuredUser?> getSingleByUsername(String username) async {
    final many = await getMany(
      conditions: ['username = @username'],
      substitutionValues: {'username': username},
      obfuscate: false,
    );
    return many.zeroOrOne;
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      // 'privilege': null,
      'password_hash': psql.Type.byteArray,
    };
  }

  @override
  UserPrivilege get controllerPrivilege => UserPrivilege.admin;
}
