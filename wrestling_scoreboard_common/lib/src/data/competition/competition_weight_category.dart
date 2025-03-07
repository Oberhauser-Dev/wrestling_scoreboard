import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';
import 'age_category.dart';

part 'competition_weight_category.freezed.dart';
part 'competition_weight_category.g.dart';

@freezed
abstract class CompetitionWeightCategory with _$CompetitionWeightCategory implements DataObject, Organizational {
  const CompetitionWeightCategory._();

  const factory CompetitionWeightCategory({
    int? id,
    String? orgSyncId,
    Organization? organization,
    required WeightClass weightClass,
    required AgeCategory ageCategory,
    required Competition competition,
  }) = _CompetitionWeightCategory;

  factory CompetitionWeightCategory.fromJson(Map<String, Object?> json) => _$CompetitionWeightCategoryFromJson(json);

  static Future<CompetitionWeightCategory> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final organizationId = e['organization_id'] as int?;
    final ageCategoryId = e['age_category'] as int;
    final competitionId = e['competition_id'] as int;
    final weightClassId = e['weight_class'] as int;
    return CompetitionWeightCategory(
      id: e['id'] as int?,
      orgSyncId: e['org_sync_id'] as String?,
      organization: organizationId == null ? null : await getSingle<Organization>(organizationId),
      ageCategory: await getSingle<AgeCategory>(ageCategoryId),
      competition: await getSingle<Competition>(competitionId),
      weightClass: await getSingle<WeightClass>(weightClassId),
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      if (orgSyncId != null) 'org_sync_id': orgSyncId,
      if (organization != null) 'organization_id': organization?.id!,
      'weight_class': weightClass.id!,
      'age_category': ageCategory.id!,
      'competition_id': competition.id!,
    };
  }

  @override
  String get tableName => 'competition_weight_category';

  @override
  CompetitionWeightCategory copyWithId(int? id) {
    return copyWith(id: id);
  }
}
