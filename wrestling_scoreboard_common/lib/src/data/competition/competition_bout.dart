import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition_bout.freezed.dart';
part 'competition_bout.g.dart';

@freezed
abstract class CompetitionBout with _$CompetitionBout implements DataObject, Orderable {
  const CompetitionBout._();

  const factory CompetitionBout({
    int? id,
    required Competition competition,
    required Bout bout,
    required int pos,
    int? mat,
    int? round,

    /// The rank the bout is fought for. Rank is described as x * 2 + 1 (+1)
    /// 0: 1+2
    /// 1: 3+4
    /// 2: 5+6 ...
    int? rank,
    @Default(RoundType.elimination) RoundType roundType,
    CompetitionWeightCategory? weightCategory,
  }) = _CompetitionBout;

  factory CompetitionBout.fromJson(Map<String, Object?> json) => _$CompetitionBoutFromJson(json);

  static Future<CompetitionBout> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final competition = await getSingle<Competition>(e['competition_id'] as int);
    final bout = await getSingle<Bout>(e['bout_id'] as int);
    final weightCategoryId = e['weight_category_id'] as int?;

    return CompetitionBout(
      id: e['id'] as int?,
      competition: competition,
      bout: bout,
      weightCategory: weightCategoryId == null ? null : await getSingle<CompetitionWeightCategory>(weightCategoryId),
      pos: e['pos'] as int,
      mat: e['mat'] as int?,
      round: e['round'] as int?,
      rank: e['rank'] as int?,
      roundType: RoundType.values.byName(e['round_type']),
    );
  }

  bool equalDuringBout(CompetitionBout o) => bout.equalDuringBout(o.bout) && weightCategory == o.weightCategory;

  String? get displayRanks => rank == null ? null : '${rank! * 2 + 1}+${rank! * 2 + 2}';

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'pos': pos,
      'mat': mat,
      'round': round,
      'round_type': roundType.name,
      'rank': rank,
      'competition_id': competition.id!,
      'bout_id': bout.id!,
      'weight_category_id': weightCategory?.id,
    };
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'competition_bout';

  int? get displayRound => round != null ? (round! + 1) : null;

  int? get displayMat => mat != null ? (mat! + 1) : null;

  @override
  CompetitionBout copyWithId(int? id) {
    return copyWith(id: id);
  }
}
