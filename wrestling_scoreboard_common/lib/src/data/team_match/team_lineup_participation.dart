import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'team_lineup_participation.freezed.dart';
part 'team_lineup_participation.g.dart';

/// The participation of a person (member) on a team match through the teams lineup.
/// A person can participate in multiple weight classes, if wanted. But they only have to weight once.
/// Each weight class can additionally have one substitute ([isSubstitute]), which is not paired in bouts.
@freezed
abstract class TeamLineupParticipation with _$TeamLineupParticipation implements DataObject {
  const TeamLineupParticipation._();

  const factory TeamLineupParticipation({
    int? id,
    required Membership membership,
    required TeamLineup lineup,
    WeightClass? weightClass,
    double? weight,
    @Default(false) bool isSubstitute,

    /// Free-text eligibility markers as written on the weigh-in list or the bout protocol,
    /// e.g. `J`, `N6` (DRB) or `NW S20` (ÖRSV). The format depends on the organization and may contain multiple markers.
    /// Prefilled by the rules of the organization, see [Organization.suggestEligibilityStatusText].
    /// If `null`, there are no markers or they have not been set yet.
    String? eligibilityStatusText,
  }) = _TeamLineupParticipation;

  factory TeamLineupParticipation.fromJson(Map<String, Object?> json) => _$TeamLineupParticipationFromJson(json);

  static TeamLineupParticipation? fromParticipationsAndWeightClass({
    required Iterable<TeamLineupParticipation> participations,
    required WeightClass? weightClass,
    bool isSubstitute = false,
  }) {
    return participations
        .where((element) => element.weightClass == weightClass && element.isSubstitute == isSubstitute)
        .zeroOrOne;
  }

  /// The participation of the [membership], preferring the one of the [weightClass].
  static TeamLineupParticipation? fromParticipationsAndMembership({
    required Iterable<TeamLineupParticipation> participations,
    required Membership membership,
    WeightClass? weightClass,
  }) {
    final memberParticipations = participations.where((element) => element.membership == membership);
    return memberParticipations.where((element) => element.weightClass == weightClass).firstOrNull ??
        memberParticipations.firstOrNull;
  }

  /// The [eligibilityStatusText], or the suggestion by the rules of the [organization] if not set yet.
  String? resolveEligibilityStatusText(Organization? organization, {required DateTime date}) =>
      eligibilityStatusText ?? organization?.suggestEligibilityStatusText(membership.person, date: date);

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
      isSubstitute: e['is_substitute'] as bool? ?? false,
      eligibilityStatusText: e['eligibility_status_text'] as String?,
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
      'is_substitute': isSubstitute,
      'eligibility_status_text': eligibilityStatusText,
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

  static Map<String, Type> searchableForeignAttributeMapping = {'membership_id': Membership};
}
