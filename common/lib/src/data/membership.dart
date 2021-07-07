import 'package:json_annotation/json_annotation.dart';

import 'club.dart';
import 'person.dart';

part 'membership.g.dart';

@JsonSerializable()
class Membership {
  String? no; // Vereinsnummer
  final Club club;
  final Person person;

  Membership({
    int? id,
    this.no,
    required this.club,
    required this.person,
  });

  factory Membership.fromJson(Map<String, dynamic> json) => _$MembershipFromJson(json);

  Map<String, dynamic> toJson() => _$MembershipToJson(this);
}
