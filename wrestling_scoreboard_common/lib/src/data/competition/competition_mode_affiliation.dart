import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition_mode_affiliation.freezed.dart';
part 'competition_mode_affiliation.g.dart';

@freezed
abstract class CompetitionModeAffiliation with _$CompetitionModeAffiliation implements DataObject {
  const CompetitionModeAffiliation._();

  const factory CompetitionModeAffiliation({
    int? id,
    required Competition competition,
    required CompetitionMode competitionMode,
    int? maxContestants,
  }) = _CompetitionModeAffiliation;

  factory CompetitionModeAffiliation.fromJson(Map<String, Object?> json) => _$CompetitionModeAffiliationFromJson(json);

  static Future<CompetitionModeAffiliation> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final competition = await getSingle<Competition>(e['competition_id'] as int);
    final competitionMode = e['competition_mode'] as String;

    return CompetitionModeAffiliation(
      id: e['id'] as int?,
      competition: competition,
      competitionMode: CompetitionMode.values.byName(competitionMode),
      maxContestants: e['max_contestants'] as int,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'competition_id': competition.id!,
      'competition_mode_id': competitionMode.name,
      'max_contestants': maxContestants,
    };
  }

  @override
  String get tableName => 'competition_mode_affiliation';

  @override
  CompetitionModeAffiliation copyWithId(int? id) {
    return copyWith(id: id);
  }
}
