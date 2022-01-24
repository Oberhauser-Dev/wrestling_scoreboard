import 'package:json_annotation/json_annotation.dart';

import '../../enums/person_role.dart';
import '../data_object.dart';
import '../person.dart';
import 'tournament.dart';

part 'tournament_person.g.dart';

/// An action and its value that is fulfilled by the participant during a fight, e.g. points or caution
@JsonSerializable()
class TournamentPerson extends DataObject {
  PersonRole role;
  Tournament tournament;
  Person person;

  TournamentPerson({int? id, required this.tournament, required this.person, required this.role}) : super(id);

  factory TournamentPerson.fromJson(Map<String, dynamic> json) => _$TournamentPersonFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TournamentPersonToJson(this);

  static Future<TournamentPerson> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async =>
      TournamentPerson(
        id: e['id'] as int?,
        tournament: (await getSingle<Tournament>(e['tournament_id'] as int))!,
        person: (await getSingle<Person>(e['person_id'] as int))!,
        role: PersonRoleParser.valueOf(e['person_role']),
      );

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'tournament_id': tournament.id,
      'person_id': person.id,
      'person_role': role.name,
    };
  }
}
