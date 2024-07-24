import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition.freezed.dart';
part 'competition.g.dart';

/// For team matches only.
@freezed
class Competition extends WrestlingEvent with _$Competition {
  const Competition._();

  const factory Competition({
    int? id,
    String? orgSyncId,
    Organization? organization,
    required String name,
    required BoutConfig boutConfig,
    String? location,
    required DateTime date,
    String? no,
    int? visitorsCount,
    String? comment,
  }) = _Competition;

  factory Competition.fromJson(Map<String, Object?> json) => _$CompetitionFromJson(json);

  static Future<Competition> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final boutConfig = await getSingle<BoutConfig>(e['bout_config_id'] as int);
    final organizationId = e['organization_id'] as int?;
    // TODO: fetch lineups, referees, weightClasses, etc.
    return Competition(
      id: e['id'] as int?,
      orgSyncId: e['org_sync_id'] as String?,
      organization: organizationId == null ? null : await getSingle<Organization>(organizationId),
      name: e['name'],
      location: e['location'] as String?,
      date: e['date'] as DateTime,
      visitorsCount: e['visitors_count'] as int?,
      comment: e['comment'] as String?,
      boutConfig: boutConfig,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return super.toRaw()
      ..addAll({
        'name': name,
        'bout_config_id': boutConfig.id!,
      });
  }

  @override
  Future<List<Bout>> generateBouts(List<List<Participation>> teamParticipations, List<WeightClass> weightClasses) {
    // TODO: implement generateBouts
    throw UnimplementedError();
  }

  @override
  String get tableName => 'competition';

  @override
  Competition copyWithId(int? id) {
    return copyWith(id: id);
  }
}
