import 'gender.dart';
import 'person.dart';
import 'team.dart';

class Participant extends Person {
  String? id; // Vereinsnummer
  final Team? team;

  Participant(
      {this.id, this.team, required String prename, required String surname, Gender? gender, DateTime? birthDate})
      : super(prename: prename, surname: surname, birthDate: birthDate, gender: gender);
}
