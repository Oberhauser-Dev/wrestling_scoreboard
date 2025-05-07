import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'organization.freezed.dart';
part 'organization.g.dart';

/// The league in which the team is bouting.
@freezed
abstract class Organization with _$Organization implements DataObject {
  const Organization._();

  const factory Organization({
    int? id,
    required String name,
    String? abbreviation,
    Organization? parent,
    WrestlingApiProvider? apiProvider,
    WrestlingReportProvider? reportProvider,
  }) = _Organization;

  factory Organization.fromJson(Map<String, Object?> json) => _$OrganizationFromJson(json);

  static Future<Organization> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final parentId = e['parent_id'] as int?;
    final parent = parentId == null ? null : await getSingle<Organization>(parentId);
    final apiProviderStr = e['api_provider'] as String?;
    final reportProviderStr = e['report_provider'] as String?;
    return Organization(
      id: e['id'] as int?,
      name: e['name'] as String,
      abbreviation: e['abbreviation'] as String?,
      apiProvider: apiProviderStr == null ? null : WrestlingApiProvider.values.byName(apiProviderStr),
      reportProvider: reportProviderStr == null ? null : WrestlingReportProvider.values.byName(reportProviderStr),
      parent: parent,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'abbreviation': abbreviation,
      'parent_id': parent?.id!,
      'api_provider': apiProvider?.name,
      'report_provider': reportProvider?.name,
    };
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'organization';

  String get fullname => '$name ($abbreviation)';

  WrestlingApi? getApi(GetSingleOfOrg getSingle, {AuthService? authService}) =>
      apiProvider?.getApi(this, getSingleOfOrg: getSingle, authService: authService);

  WrestlingReporter? getReporter() => reportProvider?.getReporter(this);

  @override
  Organization copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Set<String> searchableAttributes = {'name', 'abbreviation'};
}
