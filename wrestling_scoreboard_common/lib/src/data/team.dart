import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'team.freezed.dart';
part 'team.g.dart';

/// A team (can have multiple clubs in a players community).
@freezed
abstract class Team with _$Team implements DataObject, Organizational {
  const Team._();

  const factory Team({
    int? id,
    String? orgSyncId,
    Organization? organization,
    required String name,
    String? description,
  }) = _Team;

  factory Team.fromJson(Map<String, Object?> json) => _$TeamFromJson(json);

  static Future<Team> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final organizationId = e['organization_id'] as int?;
    return Team(
      id: e['id'] as int?,
      orgSyncId: e['org_sync_id'] as String?,
      organization: organizationId == null ? null : await getSingle<Organization>(organizationId),
      name: e['name'] as String,
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
    };
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'team';

  @override
  Team copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Set<String> searchableAttributes = {'name', 'description'};
}
