import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'division_weight_class.freezed.dart';
part 'division_weight_class.g.dart';

@freezed
abstract class DivisionWeightClass with _$DivisionWeightClass implements DataObject, Organizational {
  const DivisionWeightClass._();

  /// The [seasonPartition] is started counting at 0.
  const factory DivisionWeightClass({
    int? id,
    String? orgSyncId,
    Organization? organization,
    required int pos,
    required Division division,
    required WeightClass weightClass,
    int? seasonPartition,
  }) = _DivisionWeightClass;

  factory DivisionWeightClass.fromJson(Map<String, Object?> json) => _$DivisionWeightClassFromJson(json);

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      if (orgSyncId != null) 'org_sync_id': orgSyncId,
      if (organization != null) 'organization_id': organization?.id!,
      'pos': pos,
      'division_id': division.id!,
      'weight_class_id': weightClass.id!,
      'season_partition': seasonPartition,
    };
  }

  static Future<DivisionWeightClass> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final organizationId = e['organization_id'] as int?;
    return DivisionWeightClass(
      id: e['id'] as int?,
      orgSyncId: e['org_sync_id'] as String?,
      organization: organizationId == null ? null : await getSingle<Organization>(organizationId),
      division: (await getSingle<Division>(e['division_id'] as int)),
      weightClass: (await getSingle<WeightClass>(e['weight_class_id'] as int)),
      pos: e['pos'] as int,
      seasonPartition: e['season_partition'] as int?,
    );
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'division_weight_class';

  @override
  DivisionWeightClass copyWithId(int? id) {
    return copyWith(id: id);
  }
}
