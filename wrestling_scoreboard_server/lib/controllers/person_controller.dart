import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/membership_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

class PersonController extends OrganizationalController<Person> {
  static final PersonController _singleton = PersonController._internal();

  factory PersonController() {
    return _singleton;
  }

  PersonController._internal() : super(tableName: 'person');

  @override
  Map<String, dynamic> obfuscate(Map<String, dynamic> raw) {
    final id = raw['id'];
    raw['prename'] = 'Pre: $id';
    raw['surname'] = 'Sur: $id';
    raw['birth_date'] = null;
    raw['nationality'] = null;
    raw['gender'] = null;
    return raw;
  }

  Future<Response> requestMemberships(Request request, User? user, String id) async {
    return MembershipController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['person_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      'gender': null,
    };
  }
}
