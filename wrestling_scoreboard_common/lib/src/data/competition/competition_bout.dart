import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition_bout.freezed.dart';
part 'competition_bout.g.dart';

@freezed
abstract class CompetitionBout with _$CompetitionBout implements DataObject {
  const CompetitionBout._();

  const factory CompetitionBout({
    int? id,
    required Competition competition,
    required Bout bout,
    required int pos,
    int? mat,
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
    );
  }

  bool equalDuringBout(CompetitionBout o) => bout.equalDuringBout(o.bout) && weightCategory == o.weightCategory;

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'pos': pos,
      'mat': mat,
      'competition_id': competition.id!,
      'bout_id': bout.id!,
      'weight_category_id': weightCategory?.id,
    };
  }

  @override
  String get tableName => 'competition_bout';

  @override
  CompetitionBout copyWithId(int? id) {
    return copyWith(id: id);
  }
}
