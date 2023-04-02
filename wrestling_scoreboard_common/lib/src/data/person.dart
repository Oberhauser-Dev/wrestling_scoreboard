import 'package:json_annotation/json_annotation.dart';

import '../enums/gender.dart';
import '../util.dart';
import 'data_object.dart';

part 'person.g.dart';

/// The persons information.
@JsonSerializable()
class Person extends DataObject {
  final String prename;
  final String surname;
  final Gender? gender;
  final DateTime? birthDate;

  Person({int? id, required this.prename, required this.surname, this.gender, this.birthDate}) : super(id);

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PersonToJson(this);

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
}
