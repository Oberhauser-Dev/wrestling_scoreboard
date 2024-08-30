import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

abstract class OrganizationalController<T extends Organizational> extends ShelfController<T> {
  OrganizationalController({required super.tableName});

  late Future<psql.Statement> getSingleOfOrgRawStmt;

  @override
  void init() {
    getSingleOfOrgRawStmt = PostgresDb().connection.prepare(
        psql.Sql.named('SELECT * FROM $tableName WHERE organization_id = @orgId AND org_sync_id = @orgSyncId;'));
    super.init();
  }

  /// Get a single data object via a foreign id (sync id), given by an organization.
  Future<T> getSingleOfOrg(String orgSyncId, {required int orgId, required bool obfuscate}) async {
    final single = await getSingleOfOrgRaw(orgSyncId, orgId: orgId);
    return DataObject.fromRaw<T>(
        single, <T extends DataObject>(id) => EntityController.getSingleFromDataType<T>(id, obfuscate: obfuscate));
  }

  Future<Map<String, dynamic>> getSingleOfOrgRaw(String orgSyncId, {required int orgId}) async {
    if (orgSyncId != orgSyncId.trim()) {
      orgSyncId = orgSyncId.trim();
      print('$T with orgSyncId "$orgSyncId" was trimmed');
    }
    final resStream = (await getSingleOfOrgRawStmt).bind({'orgSyncId': orgSyncId, 'orgId': orgId});
    final many = await resStream.toColumnMap().toList();
    if (many.isEmpty) throw InvalidParameterException('$T with orgSyncId "$orgSyncId" not found');
    return many.first;
  }

  Future<T> getOrCreateSingleOfOrg(T dataObject, {required bool obfuscate}) async {
    if (dataObject.id != null) {
      throw Exception('Data object already has an id: $dataObject');
    }
    final organizational = (dataObject as Organizational);
    if (organizational.organization?.id == null || organizational.orgSyncId == null) {
      throw Exception('Organization id and sync id must not be null: $dataObject');
    }
    try {
      final single = await getSingleOfOrg(organizational.orgSyncId!,
          orgId: organizational.organization!.id!, obfuscate: obfuscate);
      return single;
    } on InvalidParameterException catch (_) {
      return createSingleReturn(dataObject);
    }
  }

  Future<List<T>> getOrCreateManyOfOrg(List<T> dataObjects, {required bool obfuscate}) async {
    return await Future.wait(dataObjects.map((element) => getOrCreateSingleOfOrg(element, obfuscate: obfuscate)));
  }

  static Future<T> getSingleFromDataTypeOfOrg<T extends Organizational>(String orgSyncId,
      {required int orgId, required bool obfuscate}) {
    return (ShelfController.getControllerFromDataType(T) as OrganizationalController<T>)
        .getSingleOfOrg(orgSyncId, orgId: orgId, obfuscate: obfuscate);
  }
}
