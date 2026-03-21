import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition_weight_category.freezed.dart';
part 'competition_weight_category.g.dart';

@freezed
abstract class CompetitionWeightCategory with _$CompetitionWeightCategory implements DataObject, PosOrderable {
  const CompetitionWeightCategory._();

  const factory CompetitionWeightCategory({
    int? id,
    required WeightClass weightClass,
    required CompetitionAgeCategory competitionAgeCategory,
    required Competition competition,
    CompetitionSystemAffiliation? competitionSystemAffiliation,

    /// Round by which is currently paired
    /// - []: No round was and no phase was paired.
    /// - [0]: One (first) round in the first phase was paired.
    /// - [3, 1]: 4th round in the first phase, and second round in the second phase was paired.
    @Default([]) List<int> pairedRoundByPhase,
    @Default(0) int pos,
    @Default([]) List<int> skippedCycles,
  }) = _CompetitionWeightCategory;

  factory CompetitionWeightCategory.fromJson(Map<String, Object?> json) => _$CompetitionWeightCategoryFromJson(json);

  static Future<CompetitionWeightCategory> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final competitionAgeCategoryId = e['competition_age_category_id'] as int;
    final competitionId = e['competition_id'] as int;
    final competitionSystemAffiliationId = e['competition_system_affiliation_id'] as int?;
    final weightClassId = e['weight_class_id'] as int;
    return CompetitionWeightCategory(
      id: e['id'] as int?,
      competitionAgeCategory: await getSingle<CompetitionAgeCategory>(competitionAgeCategoryId),
      competition: await getSingle<Competition>(competitionId),
      weightClass: await getSingle<WeightClass>(weightClassId),
      pairedRoundByPhase: (e['paired_round_by_phase'] as List<int?>).nonNulls.toList(),
      competitionSystemAffiliation: competitionSystemAffiliationId == null
          ? null
          : await getSingle<CompetitionSystemAffiliation>(competitionSystemAffiliationId),
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
      'paired_round_by_phase': pairedRoundByPhase,
      'competition_system_affiliation_id': competitionSystemAffiliation?.id!,
      'pos': pos,
      'skipped_cycles': skippedCycles,
    };
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'competition_weight_category';

  String get name => '${competitionAgeCategory.ageCategory.name} | ${weightClass.name}';

  int? get displayPairedRound => pairedRoundByPhase.isNotEmpty ? (pairedRoundByPhase.last + 1) : null;

  @override
  CompetitionWeightCategory copyWithId(int? id) {
    return copyWith(id: id);
  }

  /// Helper to build your results based on the [poolGroups] via [poolGroupBuilder]
  /// or the [participation]s [ranking], [poolRanking] and [metric] via [poolGroupParticipantBuilder].
  static void rankingBuilder({
    required Iterable<CompetitionParticipation> weightCategoryParticipants,
    required Iterable<MapEntry<CompetitionBout, Iterable<BoutAction>>> weightCategoryBoutsWithActions,
    void Function(int poolGroup)? poolGroupBuilder,
    required void Function(CompetitionParticipation participation, List<Rank?> ranks) poolGroupParticipantBuilder,
    required List<CompetitionSystemPhase> phases,
    required int groupPoolsByPhase,
  }) {
    final rankings = sortedRanking(
      weightCategoryParticipants: weightCategoryParticipants,
      weightCategoryBoutsWithActions: weightCategoryBoutsWithActions,
      phases: phases,
      rankByPhasePos: groupPoolsByPhase,
    );

    final groupByPools = rankings.entries.groupListsBy(
      (entry) => entry.key.poolGroups.elementAtOrNull(groupPoolsByPhase),
    );
    for (int pool = 0; pool < phases[groupPoolsByPhase].poolGroupCount; pool++) {
      final contestants = groupByPools[pool];
      if (poolGroupBuilder != null && contestants != null) poolGroupBuilder(pool);
      contestants?.forEach((contestant) {
        poolGroupParticipantBuilder(contestant.key, contestant.value);
      });
    }
  }

  static LinkedHashMap<CompetitionParticipation, List<Rank?>> sortedRanking({
    required Iterable<CompetitionParticipation> weightCategoryParticipants,
    required Iterable<MapEntry<CompetitionBout, Iterable<BoutAction>>> weightCategoryBoutsWithActions,
    required List<CompetitionSystemPhase> phases,
    int? rankByPhasePos,
  }) {
    final rankings = ranking(
      weightCategoryParticipants: weightCategoryParticipants,
      weightCategoryBoutsWithActions: weightCategoryBoutsWithActions,
      phases: phases,
    );
    final sortedEntries = rankings.entries.sorted((a, b) {
      if (rankByPhasePos != null) {
        return _compareRankByPhase(a: a, b: b, phase: phases[rankByPhasePos]);
      }
      for (final phase in phases.reversed) {
        final cmp = _compareRankByPhase(a: a, b: b, phase: phase);
        if (cmp != 0) return cmp;
      }
      return 0;
    });
    return LinkedHashMap.fromEntries(sortedEntries);
  }

  static int _compareRankByPhase({
    required MapEntry<CompetitionParticipation, List<Rank?>> a,
    required MapEntry<CompetitionParticipation, List<Rank?>> b,
    required CompetitionSystemPhase phase,
  }) {
    final aRank = a.value.elementAtOrNull(phase.pos)?.rank;
    final bRank = b.value.elementAtOrNull(phase.pos)?.rank;
    if (aRank == bRank) return 0;
    return (aRank ?? double.infinity).compareTo(bRank ?? double.infinity);
  }

  static Map<CompetitionParticipation, List<Rank?>> ranking({
    required Iterable<CompetitionParticipation> weightCategoryParticipants,
    required Iterable<MapEntry<CompetitionBout, Iterable<BoutAction>>> weightCategoryBoutsWithActions,
    required List<CompetitionSystemPhase> phases,
  }) {
    final Map<CompetitionParticipation, List<Rank?>> ranking = {};
    final cBoutsByPhase = weightCategoryBoutsWithActions.groupListsBy((entry) => entry.key.phasePos);
    for (final phase in phases) {
      final cBouts = cBoutsByPhase[phase.pos];
      if (cBouts == null) break;

      for (int poolGroup = 0; poolGroup < phase.poolGroupCount; poolGroup++) {
        final participationsOfPoolGroup = weightCategoryParticipants
            .where((p) => (p.poolGroups.length - 1) >= phase.pos && p.poolGroups[phase.pos] == poolGroup)
            .toList();

        final poolRanking = CompetitionWeightCategory.calculatePoolRanking(
          participationsOfPoolGroup,
          Map.fromEntries(cBouts),
          phase.competitionSystem,
        );

        poolRanking.forEach((contestant, rank) {
          ranking.putIfAbsent(contestant, () => []);
          ranking[contestant]!.add(
            _calculateParticipantRankingPosition(participationOfPoolGroup: contestant, ranking: poolRanking),
          );
        });
      }
    }
    return ranking;
  }

  static Rank? _calculateParticipantRankingPosition({
    required CompetitionParticipation participationOfPoolGroup,
    required LinkedHashMap<CompetitionParticipation, RankingMetric> ranking,
  }) {
    final entries = ranking.entries.toList();
    final rankingIndex = entries.indexWhere((element) => element.key == participationOfPoolGroup);
    return rankingIndex == -1 ? null : Rank(rank: rankingIndex + 1, metric: entries[rankingIndex].value);
  }

  // TODO: Also consider semi-finals
  static LinkedHashMap<CompetitionParticipation, RankingMetric> calculateRankingByFinals(
    Iterable<CompetitionParticipation> participations,
    Map<CompetitionBout, Iterable<BoutAction>> pastCompetitionBouts,
  ) {
    final LinkedHashMap<CompetitionParticipation, RankingMetric> ranking = LinkedHashMap();
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
      ranking[winner] = _getPointsOfParticipant(winner, pastCompetitionBouts);
      unrankedParticipations.remove(winner);

      final looser = participations.where((p) => p.membership == compBout.bout.looser?.membership).single;
      ranking[looser] = _getPointsOfParticipant(looser, pastCompetitionBouts);
      unrankedParticipations.remove(looser);

      rank++;
    }

    // Rank all remaining participants by points
    ranking.addAll(calculateRankingByPoints(unrankedParticipations, pastCompetitionBouts));
    return ranking;
  }

  /// Calculate the ranking in a pool as tuple of (participant, rankingMetric)
  static LinkedHashMap<CompetitionParticipation, RankingMetric> calculatePoolRanking(
    Iterable<CompetitionParticipation> participations,
    Map<CompetitionBout, Iterable<BoutAction>> pastCompetitionBouts,
    CompetitionSystem? competitionSystem,
  ) {
    participations = participations.where((element) => element.isRanked);
    switch (competitionSystem) {
      case null:
        return LinkedHashMap();
      case CompetitionSystem.bestOfThree:
        return calculateRankingByPoints(participations, pastCompetitionBouts);
      case CompetitionSystem.finals:
      case CompetitionSystem.singleElimination:
        return calculateRankingByFinals(participations, pastCompetitionBouts);
      case CompetitionSystem.doubleElimination:
      case CompetitionSystem.nordic:
        return calculateRankingByPoints(participations, pastCompetitionBouts);
      case CompetitionSystem.nordicDoubleElimination:
        final qualificationGroups = participations.groupListsBy((element) => !element.isExcluded);
        final LinkedHashMap<CompetitionParticipation, RankingMetric> poolRanking = LinkedHashMap();
        if (qualificationGroups[true] != null) {
          // Add the ones who are not excluded, e.g. when the ranking only applies between the last 3.
          poolRanking.addAll(calculateRankingByPoints(qualificationGroups[true]!, pastCompetitionBouts));
        }
        if (qualificationGroups[false] != null) {
          // Add the ones who are excluded
          poolRanking.addAll(calculateRankingByPoints(qualificationGroups[false]!, pastCompetitionBouts));
        }
        return poolRanking;
    }
  }

  /// Get a list of contestants by round, which did win or lose.
  /// Usually used for finals.
  /// Only returns contestants, which were not eliminated.
  /// Also appends contestants last, which did not appear in the presented bouts.
  static List<List<CompetitionParticipation>> calculateRankingByRoundWinsAndLosses(
    Iterable<CompetitionParticipation> participations,
    Iterable<MapEntry<CompetitionBout, Iterable<BoutAction>>> pastCompetitionBouts,
  ) {
    final notYetLoserParticipants = participations
        .where((element) => element.contestantStatus == null || element.contestantStatus == ContestantStatus.eliminated)
        .toSet();
    final possibleWinnerParticipants = <CompetitionParticipation>{};
    final filteredBouts = pastCompetitionBouts.where((e) => e.key.round != null);
    int round = 0;
    final resultByRoundAndLosses = <List<CompetitionParticipation>>[];
    Iterable<MapEntry<CompetitionBout, Iterable<BoutAction>>> roundBouts;
    while ((roundBouts = filteredBouts.where((e) => e.key.round == round)).isNotEmpty) {
      final roundLosers = <CompetitionParticipation>[];
      for (final roundBout in roundBouts) {
        final bout = roundBout.key.bout;
        if (bout.result != null) {
          final loser = bout.looser;
          final loserParticipant = notYetLoserParticipants.singleWhereOrNull(
            (p) => p.membership.id == loser?.membership.id,
          );
          final winner = bout.winner;
          final winnerParticipant = notYetLoserParticipants.singleWhereOrNull(
            (p) => p.membership.id == winner?.membership.id,
          );
          if (winnerParticipant != null) possibleWinnerParticipants.add(winnerParticipant);
          if (loserParticipant != null) {
            notYetLoserParticipants.remove(loserParticipant);
            roundLosers.add(loserParticipant);
          }
        }
      }
      if (roundLosers.isNotEmpty) resultByRoundAndLosses.add(roundLosers);

      round++;
    }

    // Add participants which haven't lost any rounds, but also had at least one win:
    final winnerContestants = notYetLoserParticipants.intersection(possibleWinnerParticipants);
    resultByRoundAndLosses.add(winnerContestants.toList());
    final resultByRoundAndWins = resultByRoundAndLosses.reversed.toList();

    // Add contestants which did not participate in any bout.
    final notInvolvedInAnyBout = notYetLoserParticipants.toSet()..removeAll(winnerContestants);
    resultByRoundAndWins.add(notInvolvedInAnyBout.toList());
    return resultByRoundAndWins;
  }

  static LinkedHashMap<CompetitionParticipation, RankingMetric> calculateRankingByPoints(
    Iterable<CompetitionParticipation> participations,
    Map<CompetitionBout, Iterable<BoutAction>> pastCompetitionBouts,
  ) {
    final List<MapEntry<CompetitionParticipation, RankingMetric>> ranking = [];
    participations = participations.where((element) => element.isRanked);
    for (final participant in participations) {
      ranking.add(MapEntry(participant, _getPointsOfParticipant(participant, pastCompetitionBouts)));
    }
    ranking.sort((a, b) {
      final int cmp = b.value.classificationPoints.compareTo(a.value.classificationPoints);
      if (cmp != 0) return cmp;
      return b.value.technicalPoints.compareTo(a.value.technicalPoints);
    });
    return LinkedHashMap.fromEntries(ranking);
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

    return RankingMetric(classificationPoints: classificationPoints, technicalPoints: technicalPoints, wins: wins);
  }
}

@freezed
abstract class RankingMetric with _$RankingMetric {
  const factory RankingMetric({required int classificationPoints, required int technicalPoints, required int wins}) =
      _RankingMetric;
}

@freezed
abstract class Rank with _$Rank {
  const factory Rank({
    /// Rank starts at 1
    required int rank,
    required RankingMetric metric,
  }) = _Rank;
}
