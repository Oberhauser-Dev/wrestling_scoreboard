import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/gender.dart';
import '../util.dart';
import 'data_object.dart';

part 'person.freezed.dart';
part 'person.g.dart';

/// The persons information.
@freezed
class Person with _$Person implements DataObject {
  const Person._();

  const factory Person({
    int? id,
    required String prename,
    required String surname,
    Gender? gender,
    DateTime? birthDate,
  }) = _Person;

  factory Person.fromJson(Map<String, Object?> json) => _$PersonFromJson(json);

  static Future<Person> fromRaw(Map<String, dynamic> e) async {
    final gender = e['gender'] as String?;
    return Person(
      id: e['id'] as int?,
      prename: e['prename'] as String,
      surname: e['surname'] as String,
      gender: gender == null ? null : GenderParser.valueOf(gender),
      birthDate: e['birth_date'] as DateTime?,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'prename': prename,
      'surname': surname,
      'gender': gender?.name,
      'birth_date': birthDate,
    };
  }

  int? get age {
    final today = MockableDateTime.now();

    if (birthDate != null) {
      final yearDiff = today.year - birthDate!.year;
      final monthDiff = today.month - birthDate!.month;
      final dayDiff = today.day - birthDate!.day;

      return monthDiff >= 0 && dayDiff >= 0 ? yearDiff : yearDiff - 1;
    }
    return null;
  }

  String get fullName {
    return '$prename $surname';
  }

  @override
  String get tableName => 'person';
}
