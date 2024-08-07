import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/membership_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

import 'entity_controller.dart';

class PersonController extends EntityController<Person> {
  static final PersonController _singleton = PersonController._internal();

  factory PersonController() {
    return _singleton;
  }

  PersonController._internal() : super(tableName: 'person');

  Future<Response> requestMemberships(Request request, String id) async {
    return EntityController.handleRequestManyOfController(MembershipController(),
        isRaw: request.isRaw, conditions: ['person_id = @id'], substitutionValues: {'id': id});
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      'gender': null,
    };
  }

  @override
  Set<String> getSearchableAttributes() => {
        'prename',
        'surname',
        // 'gender', // Cannot currently search non-string values
        'nationality',
        // 'birth_date', // Cannot currently search non-string values
      };
}
