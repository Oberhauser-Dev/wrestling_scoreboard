import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/exceptions.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/routes/data_object_relations.dart';
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
  /// It is executed **before** the entity is updated or created.
  Future<T> updateOrCreateSingleOfOrg(
    T dataObject, {
    Future<T> Function(T? previous)? onUpdateOrCreate,
    Future<void> Function(T? previous, T current)? onUpdatedOrCreated,
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
        obfuscate: false,
      );
      if (onUpdateOrCreate != null) {
        dataObject = await onUpdateOrCreate(previous);
      }
      final current = await updateOnDiffSingle(dataObject, previous: previous);
      if (onUpdatedOrCreated != null) {
        onUpdatedOrCreated(previous, current);
      }
      return current;
    } on InvalidParameterException catch (_) {
      if (onUpdateOrCreate != null) {
        dataObject = await onUpdateOrCreate(null);
      }
      final current = await createSingleReturn(dataObject);
      if (onUpdatedOrCreated != null) {
        onUpdatedOrCreated(null, current);
      }
      return current;
    }
  }

  /// [onUpdateOrCreate] is executed before the entity is created or updated.
  /// [onDeleted] is executed after the entity has been deleted.
  Future<List<T>> updateOrCreateManyOfOrg(
    List<T> dataObjects, {
    Type? filterType,
    int? filterId,
    Future<T> Function(T? previous, T current)? onUpdateOrCreate,
    Future<void> Function(T? previous, T current)? onUpdatedOrCreated,
    Future<void> Function(T previous)? onDelete,
    Future<void> Function(T previous)? onDeleted,
  }) async {
    final conditions = ['${directDataObjectRelations[T]![filterType]!.$1} = @fid'];
    final substitutionValues = {'fid': filterId};
    final previous = await getMany(
      conditions: conditions,
      substitutionValues: substitutionValues,
      obfuscate: false,
    );
    final currentOrgSyncIds = dataObjects.map((c) => c.orgSyncId);
    // Delete not included entities
    final deletingPrevDataObjects = previous.where((Organizational p) => !currentOrgSyncIds.contains(p.orgSyncId));
    final updatingDataObjects = previous.where((Organizational p) => currentOrgSyncIds.contains(p.orgSyncId));
    final creatingDataObjects = dataObjects.where(
      (Organizational p) => !previous.map((e) => e.orgSyncId).contains(p.orgSyncId),
    );

    _logger.fine(
      'updateOrCreateManyOfOrg: Update list of data objects <$T>: (updating: ${updatingDataObjects.length}, creating: ${creatingDataObjects.length}, deleting: ${deletingPrevDataObjects.length})',
    );
    await Future.wait(
      deletingPrevDataObjects.map((prev) async {
        if (onDelete != null) {
          await onDelete(prev);
        }
        if (await deleteSingle(prev.id!) && onDeleted != null) {
          await onDeleted(prev);
        }
      }),
    );

    // Execute one after one (synchronously) as it may fails when creating the same source twice in the onUpdateOrCreate method.
    dataObjects = await forEachFuture(
      dataObjects,
      (element) => updateOrCreateSingleOfOrg(
        element,
        onUpdateOrCreate: onUpdateOrCreate != null ? (previous) => onUpdateOrCreate(previous, element) : null,
        onUpdatedOrCreated: onUpdatedOrCreated,
      ),
    );
    if (creatingDataObjects.isNotEmpty || deletingPrevDataObjects.isNotEmpty) {
      broadcastUpdateMany<T>(
        (obfuscate) async {
          if (obfuscate) {
            return await getMany(conditions: conditions, substitutionValues: substitutionValues, obfuscate: true);
          } else {
            return dataObjects;
          }
        },
        filterType: filterType,
        filterId: filterId,
      );
    }
    return dataObjects;
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
