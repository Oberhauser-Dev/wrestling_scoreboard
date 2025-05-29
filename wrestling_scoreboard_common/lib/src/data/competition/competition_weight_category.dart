import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition_weight_category.freezed.dart';
part 'competition_weight_category.g.dart';

@freezed
abstract class CompetitionWeightCategory with _$CompetitionWeightCategory implements DataObject {
  const CompetitionWeightCategory._();

  const factory CompetitionWeightCategory({
    int? id,
    required WeightClass weightClass,
    required AgeCategory ageCategory,
    required Competition competition,
    CompetitionSystem? competitionSystem,
    @Default(1) int poolGroupCount,
    int? pairedRound,
  }) = _CompetitionWeightCategory;

  factory CompetitionWeightCategory.fromJson(Map<String, Object?> json) => _$CompetitionWeightCategoryFromJson(json);

  static Future<CompetitionWeightCategory> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final ageCategoryId = e['age_category_id'] as int;
    final competitionId = e['competition_id'] as int;
    final weightClassId = e['weight_class_id'] as int;
    final competitionSystem = e['competition_system'] as String?;
    return CompetitionWeightCategory(
      id: e['id'] as int?,
      ageCategory: await getSingle<AgeCategory>(ageCategoryId),
      competition: await getSingle<Competition>(competitionId),
      weightClass: await getSingle<WeightClass>(weightClassId),
      pairedRound: e['paired_round'] as int?,
      competitionSystem: competitionSystem == null ? null : CompetitionSystem.values.byName(competitionSystem),
      poolGroupCount: e['pool_group_count'] as int,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'weight_class_id': weightClass.id!,
      'age_category_id': ageCategory.id!,
      'competition_id': competition.id!,
      'paired_round': pairedRound,
      'competition_system': competitionSystem?.name,
      'pool_group_count': poolGroupCount,
    };
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'competition_weight_category';

  String get name => '${ageCategory.name} | ${weightClass.name}';

  int? get displayPairedRound => pairedRound != null ? (pairedRound! + 1) : null;

  @override
  CompetitionWeightCategory copyWithId(int? id) {
    return copyWith(id: id);
  }
}
