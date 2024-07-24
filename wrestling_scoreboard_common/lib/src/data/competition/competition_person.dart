import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition_person.freezed.dart';
part 'competition_person.g.dart';

/// An action and its value that is fulfilled by the participant during a bout, e.g. points or caution
@freezed
class CompetitionPerson with _$CompetitionPerson implements DataObject {
  const CompetitionPerson._();

  const factory CompetitionPerson({
    int? id,
    required Competition competition,
    required Person person,
    required PersonRole role,
  }) = _CompetitionPerson;

  factory CompetitionPerson.fromJson(Map<String, Object?> json) => _$CompetitionPersonFromJson(json);

  static Future<CompetitionPerson> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async =>
      CompetitionPerson(
        id: e['id'] as int?,
        competition: (await getSingle<Competition>(e['competition_id'] as int)),
        person: (await getSingle<Person>(e['person_id'] as int)),
        role: PersonRole.values.byName(e['person_role']),
      );

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'competition_id': competition.id!,
      'person_id': person.id!,
      'person_role': role.name,
    };
  }

  @override
  String get tableName => 'competition_person';

  @override
  CompetitionPerson copyWithId(int? id) {
    return copyWith(id: id);
  }

  @override
  String? get orgSyncId => throw UnimplementedError();

  @override
  Organization? get organization => throw UnimplementedError();
}
