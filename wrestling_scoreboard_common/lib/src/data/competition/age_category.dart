import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'age_category.freezed.dart';
part 'age_category.g.dart';

@freezed
abstract class AgeCategory with _$AgeCategory implements DataObject, Organizational {
  const AgeCategory._();

  const factory AgeCategory({
    int? id,
    String? orgSyncId,
    Organization? organization,
    required String name,
    required int minAge,
    required int maxAge,
  }) = _AgeCategory;

  factory AgeCategory.fromJson(Map<String, Object?> json) => _$AgeCategoryFromJson(json);

  static Future<AgeCategory> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final organizationId = e['organization_id'] as int?;
    return AgeCategory(
      id: e['id'] as int?,
      orgSyncId: e['org_sync_id'] as String?,
      organization: organizationId == null ? null : await getSingle<Organization>(organizationId),
      name: e['name'],
      minAge: e['min_age'] as int,
      maxAge: e['max_age'] as int,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      if (orgSyncId != null) 'org_sync_id': orgSyncId,
      if (organization != null) 'organization_id': organization?.id!,
      'min_age': minAge,
      'max_age': minAge,
      'name': name,
    };
  }

  @override
  String get tableName => cTableName;
  static const cTableName = 'age_category';

  @override
  AgeCategory copyWithId(int? id) {
    return copyWith(id: id);
  }
}
