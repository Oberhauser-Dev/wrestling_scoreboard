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

  /// Calculate the ranking as tuple of (participant, classificationPoints, technicalPoints)
  static List<(CompetitionParticipation, int, int)> calculateRanking(
      Iterable<CompetitionParticipation> participations,
      Iterable<CompetitionBout> pastCompetitionBouts,
      ) {
    final List<(CompetitionParticipation, int, int)> ranking = [];
    for (final participant in participations) {
      final participantBoutsRed = pastCompetitionBouts.where(
            (bout) => bout.bout.r?.membership == participant.membership,
      );
      final participantBoutsBlue = pastCompetitionBouts.where(
            (bout) => bout.bout.b?.membership == participant.membership,
      );
      final classificationPoints =
          participantBoutsRed.fold<int>(
            0,
                (previousValue, element) => previousValue + (element.bout.r?.classificationPoints ?? 0),
          ) +
              participantBoutsBlue.fold<int>(
                0,
                    (previousValue, element) => previousValue + (element.bout.b?.classificationPoints ?? 0),
              );
      // TODO: get all bout actions to sum up the technical points
      final technicalPoints = 0;
      ranking.add((participant, classificationPoints, technicalPoints));
      ranking.sort((a, b) {
        int cmp = b.$2.compareTo(a.$2);
        if (cmp != 0) return cmp;
        return b.$3.compareTo(a.$3);
      });
    }
    return ranking;
  }
}
