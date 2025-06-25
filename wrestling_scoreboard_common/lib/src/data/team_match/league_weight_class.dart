import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'league_weight_class.freezed.dart';
part 'league_weight_class.g.dart';

@freezed
abstract class LeagueWeightClass with _$LeagueWeightClass implements DataObject, Organizational, Orderable {
  const LeagueWeightClass._();

  /// The [seasonPartition] is started counting at 0.
  const factory LeagueWeightClass({
    int? id,
    String? orgSyncId,
    Organization? organization,
    required int pos,
    required League league,
    required WeightClass weightClass,
    int? seasonPartition,
  }) = _LeagueWeightClass;

  factory LeagueWeightClass.fromJson(Map<String, Object?> json) => _$LeagueWeightClassFromJson(json);

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      if (orgSyncId != null) 'org_sync_id': orgSyncId,
      if (organization != null) 'organization_id': organization?.id!,
      'pos': pos,
      'league_id': league.id!,
      'weight_class_id': weightClass.id!,
      'season_partition': seasonPartition,
    };
  }

  static Future<LeagueWeightClass> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final organizationId = e['organization_id'] as int?;
    return LeagueWeightClass(
      id: e['id'] as int?,
      orgSyncId: e['org_sync_id'] as String?,
      organization: organizationId == null ? null : await getSingle<Organization>(organizationId),
      league: (await getSingle<League>(e['league_id'] as int)),
      weightClass: (await getSingle<WeightClass>(e['weight_class_id'] as int)),
      pos: e['pos'] as int,
      seasonPartition: e['season_partition'] as int?,
    );
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'league_weight_class';

  @override
  LeagueWeightClass copyWithId(int? id) {
    return copyWith(id: id);
  }
}
