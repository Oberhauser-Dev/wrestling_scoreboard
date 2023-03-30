// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TournamentPerson _$TournamentPersonFromJson(Map<String, dynamic> json) {
  return TournamentPerson(
    id: json['id'] as int?,
    tournament: Tournament.fromJson(json['tournament'] as Map<String, dynamic>),
    person: Person.fromJson(json['person'] as Map<String, dynamic>),
    role: _$enumDecode(_$PersonRoleEnumMap, json['role']),
  );
}

Map<String, dynamic> _$TournamentPersonToJson(TournamentPerson instance) => <String, dynamic>{
      'id': instance.id,
      'role': _$PersonRoleEnumMap[instance.role],
      'tournament': instance.tournament.toJson(),
      'person': instance.person.toJson(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$PersonRoleEnumMap = {
  PersonRole.referee: 'referee',
  PersonRole.matChairman: 'matChairman',
  PersonRole.judge: 'judge',
  PersonRole.transcriptWriter: 'transcriptWriter',
  PersonRole.timeKeeper: 'timeKeeper',
  PersonRole.steward: 'steward',
};
