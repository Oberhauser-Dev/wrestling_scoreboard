import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enums/person_role.dart';
import '../data_object.dart';
import '../person.dart';
import 'tournament.dart';

part 'tournament_person.freezed.dart';
part 'tournament_person.g.dart';

/// An action and its value that is fulfilled by the participant during a bout, e.g. points or caution
@freezed
class TournamentPerson with _$TournamentPerson implements DataObject {
  const TournamentPerson._();

  const factory TournamentPerson({
    int? id,
    required Tournament tournament,
    required Person person,
    required PersonRole role,
  }) = _TournamentPerson;

  factory TournamentPerson.fromJson(Map<String, Object?> json) => _$TournamentPersonFromJson(json);

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

  @override
  String get tableName => 'tournament_person';

  @override
  TournamentPerson copyWithId(int? id) {
    return copyWith(id: id);
  }
}
