import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';

class MembershipController extends OrganizationalController<Membership> {
  static final MembershipController _singleton = MembershipController._internal();

  factory MembershipController() {
    return _singleton;
  }

  MembershipController._internal() : super(tableName: 'membership');

  @override
  Set<String> getSearchableAttributes() => {'no'};
}
