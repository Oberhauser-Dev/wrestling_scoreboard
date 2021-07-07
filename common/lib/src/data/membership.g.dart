// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Membership _$MembershipFromJson(Map<String, dynamic> json) {
  return Membership(
    no: json['no'] as String?,
    club: Club.fromJson(json['club'] as Map<String, dynamic>),
    person: Person.fromJson(json['person'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MembershipToJson(Membership instance) =>
    <String, dynamic>{
      'no': instance.no,
      'club': instance.club,
      'person': instance.person,
    };
