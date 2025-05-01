import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'league.freezed.dart';
part 'league.g.dart';

/// The league in which the team is bouting.
@freezed
abstract class League with _$League implements DataObject, Organizational {
  const League._();

  const factory League({
    int? id,
    String? orgSyncId,
    Organization? organization,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required Division division,

    /// The bout days are not necessarily the total days a league has, but ideally they should.
    /// More binding is the seasonPartition of each single Match.
    required int boutDays,
  }) = _League;

  factory League.fromJson(Map<String, Object?> json) => _$LeagueFromJson(json);

  static Future<League> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final division = await getSingle<Division>(e['division_id'] as int);
    final organizationId = e['organization_id'] as int?;
    return League(
      id: e['id'] as int?,
      orgSyncId: e['org_sync_id'] as String?,
      organization: organizationId == null ? null : await getSingle<Organization>(organizationId),
      name: e['name'] as String,
      startDate: e['start_date'] as DateTime,
      endDate: e['end_date'] as DateTime,
      division: division,
      boutDays: e['bout_days'] as int,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      if (orgSyncId != null) 'org_sync_id': orgSyncId,
      if (organization != null) 'organization_id': organization?.id!,
      'name': name,
      'start_date': startDate,
      'end_date': endDate,
      'division_id': division.id!,
      'bout_days': boutDays,
    };
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'league';

  String get transitiveName => '${division.fullname}, $name';

  String get fullname => '${division.name} $name';

  @override
  League copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Set<String> searchableAttributes = {'name'};
}
