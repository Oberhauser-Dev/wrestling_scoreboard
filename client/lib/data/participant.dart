import 'package:common/common.dart';

import 'club.dart';

class ClientParticipant extends Participant {
  ClientParticipant({
    required String prename,
    required String surname,
    Gender? gender,
    DateTime? birthDate,
    String? id,
    ClientClub? club,
  }) : super(prename: prename, surname: surname, birthDate: birthDate, gender: gender, id: id, club: club);

  ClientParticipant.from(Participant obj)
      : this(
            prename: obj.prename,
            surname: obj.surname,
            birthDate: obj.birthDate,
            gender: obj.gender,
            id: obj.id,
            club: obj.club != null ? ClientClub.from(obj.club!) : null);

  factory ClientParticipant.fromJson(Map<String, dynamic> json) => ClientParticipant.from(Participant.fromJson(json));
}
