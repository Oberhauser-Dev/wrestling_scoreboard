import 'package:json_annotation/json_annotation.dart';

import 'club.dart';
import 'data_object.dart';
import 'person.dart';

part 'membership.g.dart';

/// The membership of a person in a club.
@JsonSerializable()
class Membership extends DataObject {
  String? no; // Vereinsnummer
  final Club club;
  final Person person;

  Membership({
    int? id,
    this.no,
    required this.club,
    required this.person,
  }) : super(id);

  factory Membership.fromJson(Map<String, dynamic> json) => _$MembershipFromJson(json);

  Map<String, dynamic> toJson() => _$MembershipToJson(this);
}
