import 'package:country/country.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'person.freezed.dart';
part 'person.g.dart';

class CountryJsonConverter extends JsonConverter<Country, String> {
  const CountryJsonConverter();

  @override
  Country fromJson(String json) => Countries.values.singleWhere((country) => country.alpha3 == json);

  @override
  String toJson(Country object) => object.alpha3;
}

/// The persons information.
@freezed
abstract class Person with _$Person implements DataObject, Organizational {
  const Person._();

  const factory Person({
    int? id,
    String? orgSyncId,
    Organization? organization,
    required String prename,
    required String surname,
    Gender? gender,
    DateTime? birthDate,
    @CountryJsonConverter() Country? nationality,
  }) = _Person;

  factory Person.fromJson(Map<String, Object?> json) => _$PersonFromJson(json);

  static Future<Person> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final gender = e['gender'] as String?;
    final nationality = e['nationality'] as String?;
    final organizationId = e['organization_id'] as int?;
    return Person(
      id: e['id'] as int?,
      orgSyncId: e['org_sync_id'] as String?,
      organization: organizationId == null ? null : await getSingle<Organization>(organizationId),
      prename: e['prename'] as String,
      surname: e['surname'] as String,
      gender: gender == null ? null : Gender.values.byName(gender),
      birthDate: e['birth_date'] as DateTime?,
      nationality: nationality == null ? null : CountryJsonConverter().fromJson(nationality),
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      if (orgSyncId != null) 'org_sync_id': orgSyncId,
      if (organization != null) 'organization_id': organization?.id!,
      'prename': prename,
      'surname': surname,
      'gender': gender?.name,
      'birth_date': birthDate,
      'nationality': nationality == null ? null : CountryJsonConverter().toJson(nationality!),
    };
  }

  int? get age {
    final today = MockableDateTime.now();

    if (birthDate != null) {
      final yearDiff = today.year - birthDate!.year;
      final monthDiff = today.month - birthDate!.month;
      final dayDiff = today.day - birthDate!.day;

      return monthDiff > 0 || (monthDiff == 0 && dayDiff >= 0) ? yearDiff : yearDiff - 1;
    }
    return null;
  }

  String get fullName {
    return '$prename $surname';
  }

  @override

  @override
  String get tableName => cTableName;
  static const cTableName = 'person';

  @override
  Person copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Set<String> searchableAttributes = {
    'prename',
    'surname',
    // 'gender', // Cannot currently search non-string values
    'nationality',
    // 'birth_date', // Cannot currently search non-string values
  };
}
