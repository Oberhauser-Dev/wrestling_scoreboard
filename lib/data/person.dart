import 'package:wrestling_scoreboard/util/date_time.dart';

import 'gender.dart';

class Person {
  final String prename;
  final String surname;
  final Gender? gender;
  final DateTime? birthDate;

  Person({required this.prename, required this.surname, this.gender, this.birthDate});

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
}
