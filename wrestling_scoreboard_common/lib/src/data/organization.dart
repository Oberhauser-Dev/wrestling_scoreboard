import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'organization.freezed.dart';
part 'organization.g.dart';

/// The league in which the team is bouting.
@freezed
class Organization with _$Organization implements DataObject {
  const Organization._();

  const factory Organization({
    int? id,
    required String name,
    String? abbreviation,
    Organization? parent,
  }) = _Organization;

  factory Organization.fromJson(Map<String, Object?> json) => _$OrganizationFromJson(json);

  static Future<Organization> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final parentId = e['parent_id'] as int?;
    final parent = parentId == null ? null : await getSingle<Organization>(parentId);
    return Organization(
      id: e['id'] as int?,
      name: e['name'] as String,
      abbreviation: e['abbreviation'] as String?,
      parent: parent,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'abbreviation': abbreviation,
      'parent_id': parent?.id,
    };
  }

  @override
  String get tableName => 'organization';

  String get fullname => '$name ($abbreviation)';

  @override
  Organization copyWithId(int? id) {
    return copyWith(id: id);
  }
}
