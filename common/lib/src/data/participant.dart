import 'package:json_annotation/json_annotation.dart';

import 'club.dart';
import 'gender.dart';
import 'person.dart';

part 'participant.g.dart';
@JsonSerializable()
class Participant extends Person {
  String? id; // Vereinsnummer
  final Club? club;

  Participant(
      {this.id, this.club, required String prename, required String surname, Gender? gender, DateTime? birthDate})
      : super(prename: prename, surname: surname, birthDate: birthDate, gender: gender);

  factory Participant.fromJson(Map<String, dynamic> json) => _$ParticipantFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantToJson(this);
}
