import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition_system_affiliation.freezed.dart';
part 'competition_system_affiliation.g.dart';

@freezed
abstract class CompetitionSystemAffiliation with _$CompetitionSystemAffiliation implements DataObject {
  const CompetitionSystemAffiliation._();

  const factory CompetitionSystemAffiliation({
    int? id,
    required Competition competition,
    required CompetitionSystem competitionSystem,
    int? maxContestants,
  }) = _CompetitionSystemAffiliation;

  factory CompetitionSystemAffiliation.fromJson(Map<String, Object?> json) => _$CompetitionSystemAffiliationFromJson(json);

  static Future<CompetitionSystemAffiliation> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final competition = await getSingle<Competition>(e['competition_id'] as int);
    final competitionSystem = e['competition_system'] as String;

    return CompetitionSystemAffiliation(
      id: e['id'] as int?,
      competition: competition,
      competitionSystem: CompetitionSystem.values.byName(competitionSystem),
      maxContestants: e['max_contestants'] as int?,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'competition_id': competition.id!,
      'competition_system': competitionSystem.name,
      'max_contestants': maxContestants,
    };
  }

  @override

  @override
  String get tableName => cTableName;
  static const cTableName = 'competition_system_affiliation';

  @override
  CompetitionSystemAffiliation copyWithId(int? id) {
    return copyWith(id: id);
  }
}
