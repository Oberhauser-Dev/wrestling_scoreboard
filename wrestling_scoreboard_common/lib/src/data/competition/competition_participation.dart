import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition_participation.freezed.dart';
part 'competition_participation.g.dart';

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
    int? pool,
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
    final weightCategoryId = e['competition_weight_category_id'] as int?;
    final lineup = await getSingle<CompetitionLineup>(e['competition_lineup_id'] as int);
    final membership = await getSingle<Membership>(e['membership_id'] as int);
    final weightEncoded = e['weight'];
    double? weight;
    if (weightEncoded != null) {
      weight = double.parse(weightEncoded);
    }

    return CompetitionParticipation(
      id: e['id'] as int?,
      weightCategory: weightCategoryId == null ? null : await getSingle<CompetitionWeightCategory>(weightCategoryId),
      lineup: lineup,
      membership: membership,
      weight: weight,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'competition_weight_category_id': weightCategory?.id!,
      'competition_lineup_id': lineup.id!,
      'membership_id': membership.id!,
      'weight': weight?.toString(),
    };
  }

  @override
  String get tableName => 'competition_participation';

  @override
  CompetitionParticipation copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Map<String, Type> searchableForeignAttributeMapping = {
    'membership_id': Membership,
  };
}
