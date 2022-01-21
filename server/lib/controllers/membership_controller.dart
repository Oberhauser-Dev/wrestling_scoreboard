import 'package:common/common.dart';
import 'package:server/controllers/person_controller.dart';

import 'club_controller.dart';
import 'entity_controller.dart';

class MembershipController extends EntityController<Membership> {
  static final MembershipController _singleton = MembershipController._internal();

  factory MembershipController() {
    return _singleton;
  }

  MembershipController._internal() : super(tableName: 'membership');

  @override
  Future<Membership> parseToClass(Map<String, dynamic> e) async {
    final person = await PersonController().getSingle(e['person_id'] as int);
    final club = await ClubController().getSingle(e['club_id'] as int);
    return Membership(
      id: e[primaryKeyName] as int?,
      no: e['no'] as String?,
      person: person!,
      club: club!,
    );
  }

  @override
  Map<String, dynamic> parseFromClass(Membership e) {
    return {
      if (e.id != null) primaryKeyName: e.id,
      'person_id': e.person.id,
      'club_id': e.club.id,
      'no': e.no,
    };
  }
}
