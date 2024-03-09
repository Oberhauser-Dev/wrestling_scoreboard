import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'division.freezed.dart';

part 'division.g.dart';

/// The league in which the team is bouting.
@freezed
class Division with _$Division implements DataObject {
  const Division._();

  const factory Division({
    int? id,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required BoutConfig boutConfig,
    required int seasonPartitions,
    Division? parent,
    required Organization organization,
  }) = _Division;

  factory Division.fromJson(Map<String, Object?> json) => _$DivisionFromJson(json);

  static Future<Division> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final boutConfig = await getSingle<BoutConfig>(e['bout_config_id'] as int);
    final parentId = e['parent_id'] as int?;
    final parent = parentId == null ? null : await getSingle<Division>(parentId);
    return Division(
      id: e['id'] as int?,
      name: e['name'] as String,
      startDate: e['start_date'] as DateTime,
      endDate: e['end_date'] as DateTime,
      seasonPartitions: e['season_partitions'] as int,
      boutConfig: boutConfig,
      parent: parent,
      organization: await getSingle<Organization>(e['organization_id'] as int),
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'start_date': startDate,
      'end_date': endDate,
      'bout_config_id': boutConfig.id,
      'season_partitions': seasonPartitions,
      'parent_id': parent?.id,
      'organization_id': organization.id,
    };
  }

  @override
  String get tableName => 'division';

  String get fullname => '${parent != null ? (parent!.fullname) : organization.name}, $name';

  @override
  Division copyWithId(int? id) {
    return copyWith(id: id);
  }
}
