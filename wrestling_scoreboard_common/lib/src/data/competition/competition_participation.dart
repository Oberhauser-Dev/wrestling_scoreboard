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
    int? poolGroup,
    int? poolDrawNumber,
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
      poolGroup: e['pool_group'] as int?,
      poolDrawNumber: e['pool_draw_number'] as int?,
      contestantStatus: contestantStatus == null ? null : ContestantStatus.values.byName(contestantStatus),
    );
  }

  String get name => '${membership.person.fullName} | ${lineup.club.name}';

  int? get displayPoolDrawNumber => poolDrawNumber != null ? (poolDrawNumber! + 1) : null;

  String get displayPoolId => '${poolGroup?.toLetter() ?? ''}${displayPoolDrawNumber?.toString() ?? '-'}';

  // (PoolDrawNr, PoolGroup) => DisplayPoolId => drawNumber
  // (0, 0) => A1 => 0
  // (0, 1) => B1 => 1
  // (0, 2) => C1 => 2
  // (1, 0) => A2 => 3
  // (1, 1) => B2 => 4
  // (1, 2) => C2 => 5
  int? get drawNumber =>
      poolDrawNumber == null || weightCategory == null
          ? null
          : ((poolGroup ?? 0) + (poolDrawNumber! * weightCategory!.poolGroupCount));

  int? get displayDrawNumber {
    final drawN = drawNumber;
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
      'pool_group': poolGroup,
      'pool_draw_number': poolDrawNumber,
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
