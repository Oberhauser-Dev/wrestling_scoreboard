// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_lineup_membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamLineupMembership _$TeamLineupMembershipFromJson(Map<String, dynamic> json) => _TeamLineupMembership(
  id: (json['id'] as num?)?.toInt(),
  lineup: TeamLineup.fromJson(json['lineup'] as Map<String, dynamic>),
  membership: Membership.fromJson(json['membership'] as Map<String, dynamic>),
  role: $enumDecode(_$LineupRoleEnumMap, json['role']),
);

Map<String, dynamic> _$TeamLineupMembershipToJson(_TeamLineupMembership instance) => <String, dynamic>{
  'id': instance.id,
  'lineup': instance.lineup.toJson(),
  'membership': instance.membership.toJson(),
  'role': _$LineupRoleEnumMap[instance.role]!,
};

const _$LineupRoleEnumMap = {
  LineupRole.leader: 'leader',
  LineupRole.coach: 'coach',
  LineupRole.substitute: 'substitute',
};
