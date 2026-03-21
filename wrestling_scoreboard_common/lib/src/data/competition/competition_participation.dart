import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition_participation.freezed.dart';
part 'competition_participation.g.dart';

// TODO: rename to CompetitionContestant
/// The competition_participation of a person (member) on a team match or competition through the teams lineup.
/// A person can participate in multiple weight classes, if wanted. But they only have to weight once.
@freezed
abstract class CompetitionParticipation with _$CompetitionParticipation implements DataObject {
  const CompetitionParticipation._();

  const factory CompetitionParticipation({
    int? id,
    required Membership membership,
    required CompetitionLineup lineup,
    CompetitionWeightCategory? weightCategory,
    double? weight,
    @Default([]) List<int> poolGroups,
    @Default([]) List<int> poolDrawNumbers,
    ContestantStatus? contestantStatus,
  }) = _CompetitionParticipation;

  factory CompetitionParticipation.fromJson(Map<String, Object?> json) => _$CompetitionParticipationFromJson(json);

  static CompetitionParticipation? fromParticipationsAndMembershipAndWeightCategory({
    required Iterable<CompetitionParticipation> participations,
    required Membership? membership,
    required CompetitionWeightCategory? weightCategory,
  }) {
    return participations
        .where((element) => element.membership == membership && element.weightCategory == weightCategory)
        .zeroOrOne;
  }

  static Future<CompetitionParticipation> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final weightCategoryId = e['weight_category_id'] as int?;
    final lineup = await getSingle<CompetitionLineup>(e['competition_lineup_id'] as int);
    final membership = await getSingle<Membership>(e['membership_id'] as int);
    final weightEncoded = e['weight'];
    double? weight;
    if (weightEncoded != null) {
      weight = double.parse(weightEncoded);
    }
    final contestantStatus = e['contestant_status'] as String?;

    return CompetitionParticipation(
      id: e['id'] as int?,
      weightCategory: weightCategoryId == null ? null : await getSingle<CompetitionWeightCategory>(weightCategoryId),
      lineup: lineup,
      membership: membership,
      weight: weight,
      poolGroups: (e['pool_groups'] as List<int?>).nonNulls.toList(),
      poolDrawNumbers: (e['pool_draw_numbers'] as List<int?>).nonNulls.toList(),
      contestantStatus: contestantStatus == null ? null : ContestantStatus.values.byName(contestantStatus),
    );
  }

  String get name => '${membership.person.fullName} | ${lineup.club.name}';

  int? displayPoolDrawNumber(CompetitionSystemPhase phase) {
    final tmpDrawNumber = drawNumber(phase);
    return tmpDrawNumber != null ? (tmpDrawNumber + 1) : null;
  }

  /// Returns the existing pool id of the most recent phase.
  String displayPoolId({required List<CompetitionSystemPhase> phases, required int phasePos}) {
    for (; phasePos >= 0; phasePos--) {
      if (poolGroups.length <= phasePos) {
        continue;
      }
      final drawNumber = displayPoolDrawNumber(phases[phasePos]);
      if (drawNumber == null) continue;
      return '${poolGroups[phasePos].toLetter()}$drawNumber';
    }
    return '-';
  }

  // (PoolDrawNr, PoolGroup) => DisplayPoolId => drawNumber
  // (0, 0) => A1 => 0
  // (0, 1) => B1 => 1
  // (0, 2) => C1 => 2
  // (1, 0) => A2 => 3
  // (1, 1) => B2 => 4
  // (1, 2) => C2 => 5
  int? drawNumber(CompetitionSystemPhase phase) =>
      poolDrawNumbers.length <= phase.pos ||
          poolGroups.length <= phase.pos ||
          weightCategory?.competitionSystemAffiliation == null
      ? null
      : (poolGroups[phase.pos] + (poolDrawNumbers[phase.pos] * phase.poolGroupCount));

  int? displayDrawNumber(CompetitionSystemPhase phase) {
    final drawN = drawNumber(phase);
    return drawN == null ? null : (drawN + 1);
  }

  bool get isRanked =>
      contestantStatus == null ||
      contestantStatus == ContestantStatus.eliminated ||
      contestantStatus == ContestantStatus.injured;

  bool get isExcluded =>
      contestantStatus == ContestantStatus.eliminated ||
      contestantStatus == ContestantStatus.disqualified ||
      contestantStatus == ContestantStatus.injured;

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'weight_category_id': weightCategory?.id!,
      'competition_lineup_id': lineup.id!,
      'membership_id': membership.id!,
      'weight': weight,
      'pool_groups': poolGroups,
      'pool_draw_numbers': poolDrawNumbers,
      'contestant_status': contestantStatus?.name,
    };
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'competition_participation';

  @override
  CompetitionParticipation copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Map<String, Type> searchableForeignAttributeMapping = {'membership_id': Membership};
}
