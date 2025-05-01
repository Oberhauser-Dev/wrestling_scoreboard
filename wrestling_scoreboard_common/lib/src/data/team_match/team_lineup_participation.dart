import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'team_lineup_participation.freezed.dart';
part 'team_lineup_participation.g.dart';

/// The participation of a person (member) on a team match or competition through the teams lineup.
/// A person can participate in multiple weight classes, if wanted. But they only have to weight once.
@freezed
abstract class TeamLineupParticipation with _$TeamLineupParticipation implements DataObject {
  const TeamLineupParticipation._();

  const factory TeamLineupParticipation({
    int? id,
    required Membership membership,
    required TeamLineup lineup,
    WeightClass? weightClass,
    double? weight,
  }) = _TeamLineupParticipation;

  factory TeamLineupParticipation.fromJson(Map<String, Object?> json) => _$TeamLineupParticipationFromJson(json);

  static TeamLineupParticipation? fromParticipationsAndMembershipAndWeightClass({
    required Iterable<TeamLineupParticipation> participations,
    required Membership? membership,
    required WeightClass? weightClass,
  }) {
    return participations
        .where((element) => element.membership == membership && element.weightClass == weightClass)
        .zeroOrOne;
  }

  static Future<TeamLineupParticipation> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final weightClassId = e['weight_class_id'] as int?;
    final lineup = await getSingle<TeamLineup>(e['lineup_id'] as int);
    final membership = await getSingle<Membership>(e['membership_id'] as int);
    final weightEncoded = e['weight'];
    double? weight;
    if (weightEncoded != null) {
      weight = double.parse(weightEncoded);
    }

    return TeamLineupParticipation(
      id: e['id'] as int?,
      weightClass: weightClassId == null ? null : await getSingle<WeightClass>(weightClassId),
      lineup: lineup,
      membership: membership,
      weight: weight,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'weight_class_id': weightClass?.id!,
      'lineup_id': lineup.id!,
      'membership_id': membership.id!,
      'weight': weight?.toString(),
    };
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'team_lineup_participation';

  @override
  TeamLineupParticipation copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Map<String, Type> searchableForeignAttributeMapping = {
    'membership_id': Membership,
  };
}
