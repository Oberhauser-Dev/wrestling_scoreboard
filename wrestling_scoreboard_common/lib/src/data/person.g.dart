// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonImpl _$$PersonImplFromJson(Map<String, dynamic> json) => _$PersonImpl(
      id: (json['id'] as num?)?.toInt(),
      orgSyncId: json['orgSyncId'] as String?,
      organization:
          json['organization'] == null ? null : Organization.fromJson(json['organization'] as Map<String, dynamic>),
      prename: json['prename'] as String,
      surname: json['surname'] as String,
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      birthDate: json['birthDate'] == null ? null : DateTime.parse(json['birthDate'] as String),
      nationality: _$JsonConverterFromJson<String, Country>(json['nationality'], const CountryJsonConverter().fromJson),
    );

Map<String, dynamic> _$$PersonImplToJson(_$PersonImpl instance) => <String, dynamic>{
      'id': instance.id,
      'orgSyncId': instance.orgSyncId,
      'organization': instance.organization?.toJson(),
      'prename': instance.prename,
      'surname': instance.surname,
      'gender': _$GenderEnumMap[instance.gender],
      'birthDate': instance.birthDate?.toIso8601String(),
      'nationality': _$JsonConverterToJson<String, Country>(instance.nationality, const CountryJsonConverter().toJson),
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
