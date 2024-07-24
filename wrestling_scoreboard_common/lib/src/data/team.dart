import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'team.freezed.dart';
part 'team.g.dart';

/// The team of a club.
@freezed
class Team with _$Team implements DataObject {
  const Team._();

  const factory Team({
    int? id,
    String? orgSyncId,
    Organization? organization,
    required String name,
    required Club club,
    String? description,
  }) = _Team;

  factory Team.fromJson(Map<String, Object?> json) => _$TeamFromJson(json);

  static Future<Team> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final club = await getSingle<Club>(e['club_id'] as int);
    final organizationId = e['organization_id'] as int?;
    return Team(
      id: e['id'] as int?,
      orgSyncId: e['org_sync_id'] as String?,
      organization: organizationId == null ? null : await getSingle<Organization>(organizationId),
      name: e['name'] as String,
      club: club,
      description: e['description'] as String?,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      if (orgSyncId != null) 'org_sync_id': orgSyncId,
      if (organization != null) 'organization_id': organization?.id!,
      'name': name,
      'description': description,
      'club_id': club.id!,
    };
  }

  @override
  String get tableName => 'team';

  @override
  Team copyWithId(int? id) {
    return copyWith(id: id);
  }
}
