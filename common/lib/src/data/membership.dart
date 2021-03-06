import 'package:json_annotation/json_annotation.dart';

import 'club.dart';
import 'data_object.dart';
import 'person.dart';

part 'membership.g.dart';

/// The membership of a person in a club.
@JsonSerializable()
class Membership extends DataObject {
  final String? no; // Vereinsnummer
  Club club;
  Person person;

  Membership({
    int? id,
    this.no,
    required this.club,
    required this.person,
  }) : super(id);

  factory Membership.fromJson(Map<String, dynamic> json) => _$MembershipFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MembershipToJson(this);

  static Future<Membership> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final person = await getSingle<Person>(e['person_id'] as int);
    final club = await getSingle<Club>(e['club_id'] as int);
    return Membership(
      id: e['id'] as int?,
      no: e['no'] as String?,
      person: person!,
      club: club!,
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
}
