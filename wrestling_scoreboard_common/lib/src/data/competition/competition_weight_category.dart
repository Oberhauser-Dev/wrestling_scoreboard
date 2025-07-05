import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition_weight_category.freezed.dart';
part 'competition_weight_category.g.dart';

@freezed
abstract class CompetitionWeightCategory with _$CompetitionWeightCategory implements DataObject, Orderable {
  const CompetitionWeightCategory._();

  const factory CompetitionWeightCategory({
    int? id,
    required WeightClass weightClass,
    required CompetitionAgeCategory competitionAgeCategory,
    required Competition competition,
    CompetitionSystem? competitionSystem,
    @Default(1) int poolGroupCount,
    int? pairedRound,
    @Default(0) int pos,
    @Default([]) List<int> skippedCycles,
  }) = _CompetitionWeightCategory;

  factory CompetitionWeightCategory.fromJson(Map<String, Object?> json) => _$CompetitionWeightCategoryFromJson(json);

  static Future<CompetitionWeightCategory> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final competitionAgeCategoryId = e['competition_age_category_id'] as int;
    final competitionId = e['competition_id'] as int;
    final weightClassId = e['weight_class_id'] as int;
    final competitionSystem = e['competition_system'] as String?;
    return CompetitionWeightCategory(
      id: e['id'] as int?,
      competitionAgeCategory: await getSingle<CompetitionAgeCategory>(competitionAgeCategoryId),
      competition: await getSingle<Competition>(competitionId),
      weightClass: await getSingle<WeightClass>(weightClassId),
      pairedRound: e['paired_round'] as int?,
      competitionSystem: competitionSystem == null ? null : CompetitionSystem.values.byName(competitionSystem),
      poolGroupCount: e['pool_group_count'] as int,
      pos: e['pos'] as int,
      skippedCycles: (e['skipped_cycles'] as List<int?>).nonNulls.toList(),
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'weight_class_id': weightClass.id!,
      'competition_age_category_id': competitionAgeCategory.id!,
      'competition_id': competition.id!,
      'paired_round': pairedRound,
      'competition_system': competitionSystem?.name,
      'pool_group_count': poolGroupCount,
      'pos': pos,
      'skipped_cycles': skippedCycles,
    };
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'competition_weight_category';

  String get name => '${competitionAgeCategory.ageCategory.name} | ${weightClass.name}';

  int? get displayPairedRound => pairedRound != null ? (pairedRound! + 1) : null;

  @override
  CompetitionWeightCategory copyWithId(int? id) {
    return copyWith(id: id);
  }

  /// Helper to build your results based on the [poolGroup] via [poolGroupBuilder]
  /// or the [participation]s [ranking], [poolRanking] and [rankingMetric] via [poolGroupParticipantBuilder].
  void rankingBuilder({
    required Iterable<CompetitionParticipation> weightCategoryParticipants,
    required Map<CompetitionBout, Iterable<BoutAction>> weightCategoryBoutsWithActions,
    void Function(int poolGroup)? poolGroupBuilder,
    required void Function(
      CompetitionParticipation participation,
      int? ranking,
      int? poolRanking,
      RankingMetric? rankingMetric,
    )
    poolGroupParticipantBuilder,
  }) {
    List<RankingMetric>? ranking;
    if (poolGroupCount > 1) {
      ranking = CompetitionWeightCategory.calculateRankingByFinals(
        weightCategoryParticipants,
        weightCategoryBoutsWithActions,
      );
    }

    for (int poolGroup = 0; poolGroup < poolGroupCount; poolGroup++) {
      if (poolGroupBuilder != null) poolGroupBuilder(poolGroup);

      final participationsOfPoolGroup =
          weightCategoryParticipants.where((element) => element.poolGroup == poolGroup).toList();
      participationsOfPoolGroup.sort((a, b) => (a.poolDrawNumber ?? -1).compareTo(b.poolDrawNumber ?? -1));

      // Map.where alternative
      final poolRanking = CompetitionWeightCategory.calculatePoolRanking(participationsOfPoolGroup, {
        for (final key in weightCategoryBoutsWithActions.keys)
          if (key.roundType == RoundType.elimination) key: weightCategoryBoutsWithActions[key]!,
      }, competitionSystem);
      if (poolGroupCount <= 1) {
        ranking = poolRanking;
      }

      for (final participationOfPoolGroup in participationsOfPoolGroup) {
        final rankingInfos = _calculateParticipantRankingPosition(
          participationOfPoolGroup: participationOfPoolGroup,
          ranking: ranking,
          poolRanking: poolRanking,
        );
        poolGroupParticipantBuilder(participationOfPoolGroup, rankingInfos.$1, rankingInfos.$2, rankingInfos.$3);
      }
    }
  }

  /// Return
  /// 1. position of weight category ranking,
  /// 2. position of pool ranking,
  /// 3. Ranking metrics for this participant,
  (int?, int?, RankingMetric?) _calculateParticipantRankingPosition({
    required CompetitionParticipation participationOfPoolGroup,
    required List<RankingMetric>? ranking,
    required List<RankingMetric> poolRanking,
  }) {
    final rankingIndex = ranking!.indexWhere((element) => element.participation == participationOfPoolGroup);
    final poolRankingIndex = poolRanking.indexWhere((element) => element.participation == participationOfPoolGroup);
    return (
      rankingIndex == -1 ? null : (rankingIndex + 1),
      poolRankingIndex == -1 ? null : (poolRankingIndex + 1),
      poolRankingIndex == -1 ? null : poolRanking[poolRankingIndex],
    );
  }

  // TODO: Also consider semi-finals
  static List<RankingMetric> calculateRankingByFinals(
    Iterable<CompetitionParticipation> participations,
    Map<CompetitionBout, Iterable<BoutAction>> pastCompetitionBouts,
  ) {
    final List<RankingMetric> ranking = [];
    participations = participations.where((p) => p.isRanked);
    final finalsBouts = pastCompetitionBouts.keys.where(
      (pcb) => pcb.roundType == RoundType.finals && pcb.bout.winnerRole != null,
    );
    if (finalsBouts.isEmpty) {
      // Return empty ranking, if finals did not yet took place.
      return ranking;
    }
    final unrankedParticipations = participations.toSet();

    int rank = 0;
    while (finalsBouts.where((pcb) => pcb.rank == rank).zeroOrOne != null) {
      final compBout = finalsBouts.firstWhere((pcb) => pcb.rank == rank);

      final winner = participations.where((p) => p.membership == compBout.bout.winner?.membership).single;
      ranking.add(_getPointsOfParticipant(winner, pastCompetitionBouts));
      unrankedParticipations.remove(winner);

      final looser = participations.where((p) => p.membership == compBout.bout.looser?.membership).single;
      ranking.add(_getPointsOfParticipant(looser, pastCompetitionBouts));
      unrankedParticipations.remove(looser);

      rank++;
    }

    // Rank all remaining participants by points
    ranking.addAll(calculateRankingByPoints(unrankedParticipations, pastCompetitionBouts));
    return ranking;
  }

  /// Calculate the ranking as tuple of (participant, classificationPoints, technicalPoints)
  static List<RankingMetric> calculatePoolRanking(
    Iterable<CompetitionParticipation> participations,
    Map<CompetitionBout, Iterable<BoutAction>> pastCompetitionBouts,
    CompetitionSystem? competitionSystem,
  ) {
    final List<RankingMetric> poolRanking = [];
    participations = participations.where((element) => element.isRanked);
    switch (competitionSystem) {
      case null:
        return [];
      case CompetitionSystem.singleElimination:
      case CompetitionSystem.doubleElimination:
      case CompetitionSystem.nordic:
        poolRanking.addAll(calculateRankingByPoints(participations, pastCompetitionBouts));
      case CompetitionSystem.nordicDoubleElimination:
        final qualificationGroups = participations.groupListsBy((element) => !element.isExcluded);
        if (qualificationGroups[true] != null) {
          // Add the ones who are not excluded, e.g. when the ranking only applies between the last 3.
          poolRanking.addAll(calculateRankingByPoints(qualificationGroups[true]!, pastCompetitionBouts));
        }
        if (qualificationGroups[false] != null) {
          // Add the ones who are excluded
          poolRanking.addAll(calculateRankingByPoints(qualificationGroups[false]!, pastCompetitionBouts));
        }
    }
    return poolRanking;
  }

  static List<RankingMetric> calculateRankingByPoints(
    Iterable<CompetitionParticipation> participations,
    Map<CompetitionBout, Iterable<BoutAction>> pastCompetitionBouts,
  ) {
    final List<RankingMetric> ranking = [];
    participations = participations.where((element) => element.isRanked);
    for (final participant in participations) {
      ranking.add(_getPointsOfParticipant(participant, pastCompetitionBouts));
      ranking.sort((a, b) {
        int cmp = b.classificationPoints.compareTo(a.classificationPoints);
        if (cmp != 0) return cmp;
        return b.technicalPoints.compareTo(a.technicalPoints);
      });
    }
    return ranking;
  }

  static RankingMetric _getPointsOfParticipant(
    CompetitionParticipation participant,
    Map<CompetitionBout, Iterable<BoutAction>> pastCompetitionBouts,
  ) {
    final participantBoutsRed = pastCompetitionBouts.keys.where(
      (bout) => bout.bout.r?.membership == participant.membership,
    );
    final participantBoutsBlue = pastCompetitionBouts.keys.where(
      (bout) => bout.bout.b?.membership == participant.membership,
    );

    final classificationPoints =
        participantBoutsRed.fold<int>(
          0,
          (previousValue, cb) => previousValue + (cb.bout.r?.classificationPoints ?? 0),
        ) +
        participantBoutsBlue.fold<int>(
          0,
          (previousValue, cb) => previousValue + (cb.bout.b?.classificationPoints ?? 0),
        );

    final technicalPoints =
        participantBoutsRed.fold<int>(
          0,
          (previousValue, cb) =>
              previousValue + AthleteBoutState.getTechnicalPoints(pastCompetitionBouts[cb]!, BoutRole.red),
        ) +
        participantBoutsBlue.fold<int>(
          0,
          (previousValue, cb) =>
              previousValue + AthleteBoutState.getTechnicalPoints(pastCompetitionBouts[cb]!, BoutRole.blue),
        );

    final wins =
        participantBoutsRed.where((cb) => cb.bout.winnerRole == BoutRole.red).length +
        participantBoutsRed.where((cb) => cb.bout.winnerRole == BoutRole.blue).length;

    return RankingMetric(
      participation: participant,
      classificationPoints: classificationPoints,
      technicalPoints: technicalPoints,
      wins: wins,
    );
  }
}

class RankingMetric {
  final CompetitionParticipation participation;
  final int classificationPoints;
  final int technicalPoints;
  final int wins;

  RankingMetric({
    required this.participation,
    required this.classificationPoints,
    required this.technicalPoints,
    required this.wins,
  });
}
