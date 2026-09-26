import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'team_lineup_membership.freezed.dart';
part 'team_lineup_membership.g.dart';

/// A membership having a role (e.g. leader, coach) in a team lineup.
@freezed
abstract class TeamLineupMembership with _$TeamLineupMembership implements DataObject {
  const TeamLineupMembership._();

  const factory TeamLineupMembership({
    int? id,
    required TeamLineup lineup,
    required Membership membership,
    required LineupRole role,
  }) = _TeamLineupMembership;

  factory TeamLineupMembership.fromJson(Map<String, Object?> json) => _$TeamLineupMembershipFromJson(json);

  static Future<TeamLineupMembership> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async =>
      TeamLineupMembership(
        id: e['id'] as int?,
        lineup: await getSingle<TeamLineup>(e['lineup_id'] as int),
        membership: await getSingle<Membership>(e['membership_id'] as int),
        role: LineupRole.values.byName(e['lineup_role']),
      );

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'lineup_id': lineup.id!,
      'membership_id': membership.id!,
      'lineup_role': role.name,
    };
  }

  @override
  String get tableName => cTableName;
  static const cTableName = 'team_lineup_membership';

  @override
  TeamLineupMembership copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Map<String, Type> searchableForeignAttributeMapping = {'membership_id': Membership};
}

extension TeamLineupMembershipIterable on Iterable<TeamLineupMembership> {
  /// The first entry of the given [role], e.g. the leader or the coach of a lineup.
  TeamLineupMembership? firstOfRole(LineupRole role) => where((e) => e.role == role).firstOrNull;
}
