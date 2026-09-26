// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_lineup_membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompetitionLineupMembership _$CompetitionLineupMembershipFromJson(Map<String, dynamic> json) =>
    _CompetitionLineupMembership(
      id: (json['id'] as num?)?.toInt(),
      lineup: CompetitionLineup.fromJson(json['lineup'] as Map<String, dynamic>),
      membership: Membership.fromJson(json['membership'] as Map<String, dynamic>),
      role: $enumDecode(_$LineupRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$CompetitionLineupMembershipToJson(_CompetitionLineupMembership instance) => <String, dynamic>{
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
