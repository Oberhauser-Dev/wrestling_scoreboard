import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/exceptions.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

mixin OrganizationalController<T extends Organizational> on ShelfController<T> {
  final _logger = Logger('OrganizationalController');

  late psql.Statement getSingleOfOrgRawStmt;

  @override
  Future<void> init() async {
    await super.init();
    getSingleOfOrgRawStmt = await PostgresDb().connection.prepare(
      psql.Sql.named('SELECT * FROM $tableName WHERE organization_id = @orgId AND org_sync_id = @orgSyncId;'),
    );
  }

  /// Get a single data object via a foreign id (sync id), given by an organization.
  Future<T> getSingleOfOrg(String orgSyncId, {required int orgId, required bool obfuscate}) async {
    final single = await getSingleOfOrgRaw(orgSyncId, orgId: orgId);
    return DataObjectParser.fromRaw<T>(
      single,
      <TSub extends DataObject>(id) => EntityController.getSingleFromDataType<TSub>(id, obfuscate: obfuscate),
    );
  }

  Future<Map<String, dynamic>> getSingleOfOrgRaw(String orgSyncId, {required int orgId}) async {
    if (orgSyncId != orgSyncId.trim()) {
      orgSyncId = orgSyncId.trim();
      _logger.warning('$T with orgSyncId "$orgSyncId" was trimmed');
    }
    final resStream = getSingleOfOrgRawStmt.bind({'orgSyncId': orgSyncId, 'orgId': orgId});
    final many = await resStream.toColumnMap().toList();
    if (many.isEmpty) throw InvalidParameterException('$T with orgSyncId "$orgSyncId" not found');
    return many.first;
  }

  /// [onUpdateOrCreate] takes a [T] as previous input value.
  Future<T> updateOrCreateSingleOfOrg(
    T dataObject, {
    required bool obfuscate,
    Future<T> Function(T? previous)? onUpdateOrCreate,
  }) async {
    if (dataObject.id != null) {
      throw Exception('Data object already has an id: $dataObject');
    }
    final organizational = (dataObject as Organizational);
    if (organizational.organization?.id == null || organizational.orgSyncId == null) {
      throw Exception('Organization id and sync id must not be null: $dataObject');
    }
    try {
      final previous = await getSingleOfOrg(
        organizational.orgSyncId!,
        orgId: organizational.organization!.id!,
        obfuscate: obfuscate,
      );
      if (onUpdateOrCreate != null) {
        dataObject = await onUpdateOrCreate(previous);
      }
      return updateOnDiffSingle(dataObject, previous: previous);
    } on InvalidParameterException catch (_) {
      if (onUpdateOrCreate != null) {
        dataObject = await onUpdateOrCreate(null);
      }
      return createSingleReturn(dataObject);
    }
  }

  Future<List<T>> updateOrCreateManyOfOrg(
    List<T> dataObjects, {
    required bool obfuscate,
    required List<String> conditions,
    Conjunction conjunction = Conjunction.and,
    required Map<String, dynamic> substitutionValues,
    Future<T> Function(T? previous, T current)? onUpdateOrCreate,
    Future<void> Function(T previous)? onDelete,
  }) async {
    final previous = await getMany(
      conditions: conditions,
      substitutionValues: substitutionValues,
      obfuscate: obfuscate,
    );
    final currentOrgSyncIds = dataObjects.map((c) => c.orgSyncId);
    // Delete not included entities
    await Future.wait(
      previous.where((Organizational p) => !currentOrgSyncIds.contains(p.orgSyncId)).map((prev) async {
        if (await deleteSingle(prev.id!) && onDelete != null) {
          await onDelete(prev);
        }
      }),
    );

    // Execute one after one (synchronously) as it may fails when creating the same source twice in the onUpdateOrCreate method.
    return await forEachFuture(
      dataObjects,
      (element) => updateOrCreateSingleOfOrg(
        element,
        obfuscate: obfuscate,
        onUpdateOrCreate: onUpdateOrCreate != null ? (previous) => onUpdateOrCreate(previous, element) : null,
      ),
    );
  }

  static Future<T> getSingleFromDataTypeOfOrg<T extends Organizational>(
    String orgSyncId, {
    required int orgId,
    required bool obfuscate,
  }) {
    return (ShelfController.getControllerFromDataType(T) as OrganizationalController<T>).getSingleOfOrg(
      orgSyncId,
      orgId: orgId,
      obfuscate: obfuscate,
    );
  }
}
