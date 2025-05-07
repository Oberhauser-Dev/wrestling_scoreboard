// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Membership _$MembershipFromJson(Map<String, dynamic> json) => _Membership(
  id: (json['id'] as num?)?.toInt(),
  orgSyncId: json['orgSyncId'] as String?,
  organization:
      json['organization'] == null ? null : Organization.fromJson(json['organization'] as Map<String, dynamic>),
  no: json['no'] as String?,
  club: Club.fromJson(json['club'] as Map<String, dynamic>),
  person: Person.fromJson(json['person'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MembershipToJson(_Membership instance) => <String, dynamic>{
  'id': instance.id,
  'orgSyncId': instance.orgSyncId,
  'organization': instance.organization?.toJson(),
  'no': instance.no,
  'club': instance.club.toJson(),
  'person': instance.person.toJson(),
};
