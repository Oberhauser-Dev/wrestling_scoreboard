import 'package:common/common.dart';

import 'entity_controller.dart';

class MembershipController extends EntityController<Membership> {
  static final MembershipController _singleton = MembershipController._internal();

  factory MembershipController() {
    return _singleton;
  }

  MembershipController._internal() : super(tableName: 'membership');
}
