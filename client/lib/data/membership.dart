import 'package:common/common.dart';

import 'club.dart';

class ClientMembership extends Membership {
  ClientMembership({
    int? id,
    String? no,
    required ClientClub club,
    required Person person,
  }) : super(id: id, no: no, club: club, person: person);

  ClientMembership.from(Membership obj)
      : this(
          id: obj.id,
          no: obj.no,
          club: ClientClub.from(obj.club),
          person: obj.person,
        );

  factory ClientMembership.fromJson(Map<String, dynamic> json) => ClientMembership.from(Membership.fromJson(json));
}
