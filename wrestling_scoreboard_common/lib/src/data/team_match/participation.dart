import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'participation.freezed.dart';
part 'participation.g.dart';

/// The participation of a person (member) on a team match or competition through the teams lineup.
/// A person can participate in multiple weight classes, if wanted. But they only have to weight once.
@freezed
abstract class TeamMatchParticipation with _$TeamMatchParticipation implements DataObject {
  const TeamMatchParticipation._();

  const factory TeamMatchParticipation({
    int? id,
    required Membership membership,
    required TeamLineup lineup,
    WeightClass? weightClass,
    double? weight,
  }) = _TeamMatchParticipation;

  factory TeamMatchParticipation.fromJson(Map<String, Object?> json) => _$TeamMatchParticipationFromJson(json);

  static TeamMatchParticipation? fromParticipationsAndMembershipAndWeightClass({
    required Iterable<TeamMatchParticipation> participations,
    required Membership? membership,
    required WeightClass? weightClass,
  }) {
    return participations
        .where((element) => element.membership == membership && element.weightClass == weightClass)
        .zeroOrOne;
  }

  static Future<TeamMatchParticipation> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final weightClassId = e['weight_class_id'] as int?;
    final lineup = await getSingle<TeamLineup>(e['lineup_id'] as int);
    final membership = await getSingle<Membership>(e['membership_id'] as int);
    final weightEncoded = e['weight'];
    double? weight;
    if (weightEncoded != null) {
      weight = double.parse(weightEncoded);
    }

    return TeamMatchParticipation(
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
  String get tableName => 'participation';

  @override
  TeamMatchParticipation copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Map<String, Type> searchableForeignAttributeMapping = {
    'membership_id': Membership,
  };
}
