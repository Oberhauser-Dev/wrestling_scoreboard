import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition_age_category.freezed.dart';
part 'competition_age_category.g.dart';

@freezed
abstract class CompetitionAgeCategory with _$CompetitionAgeCategory implements DataObject, PosOrderable {
  const CompetitionAgeCategory._();

  const factory CompetitionAgeCategory({
    int? id,
    required Competition competition,
    required AgeCategory ageCategory,
    @Default(0) int pos,
    @Default([]) List<int> skippedCycles,
  }) = _CompetitionAgeCategory;

  factory CompetitionAgeCategory.fromJson(Map<String, Object?> json) => _$CompetitionAgeCategoryFromJson(json);

  static Future<CompetitionAgeCategory> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final competitionId = e['competition_id'] as int;
    final ageCategoryId = e['age_category_id'] as int;
    return CompetitionAgeCategory(
      id: e['id'] as int?,
      competition: await getSingle<Competition>(competitionId),
      ageCategory: await getSingle<AgeCategory>(ageCategoryId),
      pos: e['pos'] as int,
      skippedCycles: (e['skipped_cycles'] as List<int?>).nonNulls.toList(),
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'competition_id': competition.id,
      'age_category_id': ageCategory.id,
      'pos': pos,
      'skipped_cycles': skippedCycles,
    };
  }

  @override
  String get tableName => cTableName;
  static const cTableName = 'competition_age_category';

  @override
  CompetitionAgeCategory copyWithId(int? id) {
    return copyWith(id: id);
  }
}
