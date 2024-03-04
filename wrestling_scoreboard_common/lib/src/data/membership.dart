import 'package:freezed_annotation/freezed_annotation.dart';

import 'club.dart';
import 'data_object.dart';
import 'person.dart';

part 'membership.freezed.dart';
part 'membership.g.dart';

/// The membership of a person in a club.
@freezed
class Membership with _$Membership implements DataObject {
  const Membership._();

  const factory Membership({
    int? id,
    String? no, // Vereinsnummer
    required Club club,
    required Person person,
  }) = _Membership;

  factory Membership.fromJson(Map<String, Object?> json) => _$MembershipFromJson(json);

  static Future<Membership> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final person = await getSingle<Person>(e['person_id'] as int);
    final club = await getSingle<Club>(e['club_id'] as int);
    return Membership(
      id: e['id'] as int?,
      no: e['no'] as String?,
      person: person,
      club: club,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'person_id': person.id,
      'club_id': club.id,
      'no': no,
    };
  }

  String get info {
    return '${no ?? '-'},\t ${person.fullName},\t${person.age}';
  }

  @override
  String get tableName => 'membership';

  @override
  Membership copyWithId(int? id) {
    return copyWith(id: id);
  }
}
