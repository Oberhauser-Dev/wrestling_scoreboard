import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition_system_phase.freezed.dart';
part 'competition_system_phase.g.dart';

@freezed
abstract class CompetitionSystemPhase with _$CompetitionSystemPhase implements DataObject, PosOrderable {
  const CompetitionSystemPhase._();

  const factory CompetitionSystemPhase({
    int? id,
    required CompetitionSystemAffiliation competitionSystemAffiliation,
    required CompetitionSystem competitionSystem,
    @Default(1) int poolGroupCount,
    @Default(false) bool isCrossOver,

    /// The maximum rank the bouts can be fought for. Rank is described as x * 2 + 1 (+1).
    /// This must be greater smaller than or equal to [maxContestants] / 2.
    /// 0: 1+2
    /// 1: 3+4
    /// 2: 5+6 ...
    ///
    /// x * 2 contestants will be ranked or get into the next round.
    int? maxRank,
    required int pos,
  }) = _CompetitionSystemPhase;

  factory CompetitionSystemPhase.fromJson(Map<String, Object?> json) => _$CompetitionSystemPhaseFromJson(json);

  static Future<CompetitionSystemPhase> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final competitionSystemAffiliation = await getSingle<CompetitionSystemAffiliation>(
      e['competition_system_affiliation_id'] as int,
    );
    final competitionSystem = e['competition_system'] as String;

    return CompetitionSystemPhase(
      id: e['id'] as int?,
      competitionSystemAffiliation: competitionSystemAffiliation,
      competitionSystem: CompetitionSystem.values.byName(competitionSystem),
      poolGroupCount: e['pool_group_count'] as int,
      isCrossOver: (e['cross_over'] as bool?) ?? false,
      maxRank: (e['max_rank'] as int?) ?? 3,
      pos: e['pos'] as int,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'competition_system_affiliation_id': competitionSystemAffiliation.id!,
      'competition_system': competitionSystem.name,
      'pool_group_count': poolGroupCount,
      'cross_over': isCrossOver,
      'max_rank': maxRank,
      'pos': pos,
    };
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'competition_system_phase';

  @override
  CompetitionSystemPhase copyWithId(int? id) {
    return copyWith(id: id);
  }
}
