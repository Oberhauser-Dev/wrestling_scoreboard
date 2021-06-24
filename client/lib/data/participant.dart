import 'club.dart';
import 'gender.dart';
import 'person.dart';

class Participant extends Person {
  String? id; // Vereinsnummer
  final Club? club;

  Participant(
      {this.id, this.club, required String prename, required String surname, Gender? gender, DateTime? birthDate})
      : super(prename: prename, surname: surname, birthDate: birthDate, gender: gender);
}
