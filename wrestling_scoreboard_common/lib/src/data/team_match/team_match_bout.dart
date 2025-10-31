import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'team_match_bout.freezed.dart';
part 'team_match_bout.g.dart';

@freezed
abstract class TeamMatchBout with _$TeamMatchBout implements DataObject, Organizational, PosOrderable {
  const TeamMatchBout._();

  const factory TeamMatchBout({
    int? id,
    String? orgSyncId,
    Organization? organization,
    required int pos,
    required TeamMatch teamMatch,
    required Bout bout,
    WeightClass? weightClass,
  }) = _TeamMatchBout;

  factory TeamMatchBout.fromJson(Map<String, Object?> json) => _$TeamMatchBoutFromJson(json);

  static Future<TeamMatchBout> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final teamMatch = await getSingle<TeamMatch>(e['team_match_id'] as int);
    final bout = await getSingle<Bout>(e['bout_id'] as int);
    final organizationId = e['organization_id'] as int?;
    final weightClassId = e['weight_class_id'] as int?;

    return TeamMatchBout(
      id: e['id'] as int?,
      orgSyncId: e['org_sync_id'] as String?,
      organization: organizationId == null ? null : await getSingle<Organization>(organizationId),
      teamMatch: teamMatch,
      bout: bout,
      weightClass: weightClassId == null ? null : await getSingle<WeightClass>(weightClassId),
      pos: e['pos'] as int,
    );
  }

  static List<TeamMatchBout> sortChronologically(List<TeamMatchBout> teamMatchBouts) {
    final groups = teamMatchBouts.groupListsBy((tmb) => tmb.weightClass != null);

    final tmbWithWeightClass = groups[true];
    var result = [...?groups[false]];
    if (tmbWithWeightClass != null) {
      // Sort team match bouts based on order of weight class
      final weightClasses = tmbWithWeightClass.map((tmb) => tmb.weightClass!).toList();
      final Map<WeightClass, TeamMatchBout> mapping = {
        for (int i = 0; i < weightClasses.length; i++) weightClasses[i]: tmbWithWeightClass[i],
      };

      final sortedWeightClasses = TeamMatch.sortWeightClassesChronologically(weightClasses);

      result = [for (final weightClass in sortedWeightClasses) mapping[weightClass]!, ...result];
    }
    return result;
  }

  bool equalDuringBout(TeamMatchBout o) => bout.equalDuringBout(o.bout) && weightClass == o.weightClass;

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      if (orgSyncId != null) 'org_sync_id': orgSyncId,
      if (organization != null) 'organization_id': organization?.id!,
      'pos': pos,
      'team_match_id': teamMatch.id!,
      'bout_id': bout.id!,
      'weight_class_id': weightClass?.id!,
    };
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'team_match_bout';

  @override
  TeamMatchBout copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Set<String> searchableAttributes = {};

  static Map<String, Type> searchableForeignAttributeMapping = {'bout_id': Bout};
}
