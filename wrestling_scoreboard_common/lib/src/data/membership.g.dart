// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MembershipImpl _$$MembershipImplFromJson(Map<String, dynamic> json) => _$MembershipImpl(
      id: json['id'] as int?,
      no: json['no'] as String?,
      club: Club.fromJson(json['club'] as Map<String, dynamic>),
      person: Person.fromJson(json['person'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MembershipImplToJson(_$MembershipImpl instance) => <String, dynamic>{
      'id': instance.id,
      'no': instance.no,
      'club': instance.club.toJson(),
      'person': instance.person.toJson(),
    };
