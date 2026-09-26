import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition_lineup_membership.freezed.dart';
part 'competition_lineup_membership.g.dart';

/// A membership having a role (e.g. leader, coach) in a competition lineup.
@freezed
abstract class CompetitionLineupMembership with _$CompetitionLineupMembership implements DataObject {
  const CompetitionLineupMembership._();

  const factory CompetitionLineupMembership({
    int? id,
    required CompetitionLineup lineup,
    required Membership membership,
    required LineupRole role,
  }) = _CompetitionLineupMembership;

  factory CompetitionLineupMembership.fromJson(Map<String, Object?> json) =>
      _$CompetitionLineupMembershipFromJson(json);

  static Future<CompetitionLineupMembership> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async =>
      CompetitionLineupMembership(
        id: e['id'] as int?,
        lineup: await getSingle<CompetitionLineup>(e['competition_lineup_id'] as int),
        membership: await getSingle<Membership>(e['membership_id'] as int),
        role: LineupRole.values.byName(e['lineup_role']),
      );

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'competition_lineup_id': lineup.id!,
      'membership_id': membership.id!,
      'lineup_role': role.name,
    };
  }

  @override
  String get tableName => cTableName;
  static const cTableName = 'competition_lineup_membership';

  @override
  CompetitionLineupMembership copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Map<String, Type> searchableForeignAttributeMapping = {'membership_id': Membership};
}

extension CompetitionLineupMembershipIterable on Iterable<CompetitionLineupMembership> {
  /// The first entry of the given [role], e.g. the leader or the coach of a lineup.
  CompetitionLineupMembership? firstOfRole(LineupRole role) => where((e) => e.role == role).firstOrNull;
}
