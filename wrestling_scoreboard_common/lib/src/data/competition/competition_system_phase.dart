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

    /// The maximum contestants that will be ranked or get into the next round.
    /// This must be smaller than or equal to [CompetitionSystemAffiliation.maxContestants].
    /// 0: No one will be ranked.
    /// 1: 1 contestant will be ranked, but would need to fight against another unranked contestant.
    /// 2: 2 contestants will be ranked.
    /// 3: ...
    /// null: Everyone will be ranked.
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

  static String displayMaxRanks(int? maxRank) {
    return maxRank == null ? '1 - ∞' : (maxRank == 0 ? '–' : '1 - $maxRank');
  }

  /// The maximum rank a contestant must reach in a single bracket (of total two brackets) in order to get ranked in total.
  int? get maxRankPerBracket => maxRank == null ? null : (maxRank! / 2).ceil();

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'competition_system_phase';

  @override
  CompetitionSystemPhase copyWithId(int? id) {
    return copyWith(id: id);
  }
}
