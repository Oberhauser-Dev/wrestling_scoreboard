import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'team_match_person.freezed.dart';
part 'team_match_person.g.dart';

@freezed
abstract class TeamMatchPerson with _$TeamMatchPerson implements DataObject {
  const TeamMatchPerson._();

  const factory TeamMatchPerson({
    int? id,
    required TeamMatch teamMatch,
    required Person person,
    required PersonRole role,
  }) = _TeamMatchPerson;

  factory TeamMatchPerson.fromJson(Map<String, Object?> json) => _$TeamMatchPersonFromJson(json);

  static Future<TeamMatchPerson> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async =>
      TeamMatchPerson(
        id: e['id'] as int?,
        teamMatch: (await getSingle<TeamMatch>(e['team_match_id'] as int)),
        person: (await getSingle<Person>(e['person_id'] as int)),
        role: PersonRole.values.byName(e['person_role']),
      );

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'team_match_id': teamMatch.id!,
      'person_id': person.id!,
      'person_role': role.name,
    };
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'team_match_person';

  @override
  TeamMatchPerson copyWithId(int? id) {
    return copyWith(id: id);
  }
}
