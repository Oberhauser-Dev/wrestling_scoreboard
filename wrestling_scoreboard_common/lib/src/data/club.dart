import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'club.freezed.dart';
part 'club.g.dart';

/// The sports club.
@freezed
abstract class Club with _$Club implements DataObject, Organizational {
  const Club._();

  const factory Club({
    int? id,
    String? orgSyncId,
    required Organization organization,
    required String name,
    String? no, // Club-ID
  }) = _Club;

  factory Club.fromJson(Map<String, Object?> json) => _$ClubFromJson(json);

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      if (orgSyncId != null) 'org_sync_id': orgSyncId,
      'organization_id': organization.id!,
      'no': no,
      'name': name,
    };
  }

  static Future<Club> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async => Club(
        id: e['id'] as int?,
        orgSyncId: e['org_sync_id'] as String?,
        organization: (await getSingle<Organization>(e['organization_id'] as int)),
        no: e['no'] as String?,
        name: e['name'] as String,
      );

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'club';

  @override
  Club copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Set<String> searchableAttributes = {'no', 'name'};
}
