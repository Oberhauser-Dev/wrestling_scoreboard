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
    DateTime today = MockableDateTime.now();

    if (birthDate != null) {
      int yearDiff = today.year - birthDate!.year;
      int monthDiff = today.month - birthDate!.month;
      int dayDiff = today.day - birthDate!.day;

      return monthDiff >= 0 && dayDiff >= 0 ? yearDiff : yearDiff - 1;
    }
    return null;
  }

  String get fullName {
    return '$prename $surname';
  }
}
