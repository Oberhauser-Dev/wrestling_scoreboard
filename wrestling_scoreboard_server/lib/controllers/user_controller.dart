import 'dart:convert';

import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class SecuredUserController extends ShelfController<SecuredUser> {
  static final SecuredUserController _singleton = SecuredUserController._internal();

  factory SecuredUserController() {
    return _singleton;
  }

  SecuredUserController._internal() : super();

  Future<Response> postSingleUser(Request request, User? user) async {
    try {
      final message = await request.readAsString();
      final user = parseSingleJson<User>(jsonDecode(message));
      final id = await createSingleUser(user);
      return Response.ok(jsonEncode(id));
    } on InvalidParameterException catch (e) {
      return Response.badRequest(body: e.message);
    }
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
}
