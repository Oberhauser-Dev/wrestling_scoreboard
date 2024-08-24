import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class SecuredUserController extends ShelfController<SecuredUser> {
  static final SecuredUserController _singleton = SecuredUserController._internal();

  factory SecuredUserController() {
    return _singleton;
  }

  SecuredUserController._internal() : super(tableName: 'secured_user');

  Future<SecuredUser?> getSingleByUsername(String username) async {
    final many = await getMany(conditions: ['username = @username'], substitutionValues: {'username': username});
    return many.singleOrNull;
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      'password_hash': psql.Type.byteArray,
    };
  }
}
