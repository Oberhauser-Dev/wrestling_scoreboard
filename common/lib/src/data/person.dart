import 'package:common/src/data/data_object.dart';
import 'package:json_annotation/json_annotation.dart';

import '../util.dart';
import 'gender.dart';

part 'person.g.dart';

@JsonSerializable()
class Person extends DataObject {
  final String prename;
  final String surname;
  final Gender? gender;
  final DateTime? birthDate;

  Person({int? id, required this.prename, required this.surname, this.gender, this.birthDate}) : super(id);

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);

  get age {
    DateTime today = MockableDateTime.now();

    if (birthDate != null) {
      int yearDiff = today.year - birthDate!.year;
      int monthDiff = today.month - birthDate!.month;
      int dayDiff = today.day - birthDate!.day;

      return monthDiff >= 0 && dayDiff >= 0 ? yearDiff : yearDiff - 1;
    }
    return null;
  }

  get fullName {
    return '$prename $surname';
  }
}
