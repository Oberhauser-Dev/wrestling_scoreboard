// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonImpl _$$PersonImplFromJson(Map<String, dynamic> json) => _$PersonImpl(
      id: json['id'] as int?,
      prename: json['prename'] as String,
      surname: json['surname'] as String,
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      birthDate: json['birthDate'] == null ? null : DateTime.parse(json['birthDate'] as String),
    );

Map<String, dynamic> _$$PersonImplToJson(_$PersonImpl instance) => <String, dynamic>{
      'id': instance.id,
      'prename': instance.prename,
      'surname': instance.surname,
      'gender': _$GenderEnumMap[instance.gender],
      'birthDate': instance.birthDate?.toIso8601String(),
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
};
