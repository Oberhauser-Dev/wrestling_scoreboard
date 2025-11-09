import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/services/api.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

final _logger = Logger('ImportController');

mixin ImportController<T extends DataObject> implements ShelfController<T> {
  double? importProgress;

  Future<Response> requestLastImportUtcDateTime(Request request, User? user, String entityId) async {
    final res = await PostgresDb().connection.execute(
      "SELECT * FROM ${ApiMetadata.cTableName} WHERE entity_id = $entityId AND entity_type = '$tableName' LIMIT 1;",
    );
    final row = res.zeroOrOne;
    final apiMetaData = row == null ? null : await ApiMetadata.fromRaw(row.toColumnMap());
    return Response.ok(apiMetaData?.lastImport?.toIso8601String());
  }

  Future<Response> requestImportProgress(Request request, User? user, String entityId) async {
    return Response.ok(importProgress.toString());
  }

  Future<void> updateLastImportUtcDateTime(int id) async {
    final sqlQuery = '''
INSERT INTO ${ApiMetadata.cTableName} (entity_id, entity_type, last_import)
VALUES (@entityId, @entityType, @lastImport)
ON CONFLICT (entity_id, entity_type)
DO UPDATE SET last_import = EXCLUDED.last_import;
    ''';
    final substitutionValues = {
      'entityId': id,
      'entityType': tableName,
      'lastImport': psql.TypedValue(psql.Type.timestampTz, DateTime.now().toUtc()),
    };
    final stmt = await PostgresDb().connection.prepare(psql.Sql.named(sqlQuery));
    await stmt.bind(substitutionValues).toList();
  }

  Organization? getOrganization(T entity);

  Future<Response> postCheckCredentials(Request request, User? user, String entityIdStr) async {
    final bool obfuscate = user?.obfuscate ?? true;
    final entityId = int.parse(entityIdStr);
    final message = await request.readAsString();

    final entity = await getSingle(entityId, obfuscate: obfuscate);
    final organization = getOrganization(entity);
    if (organization == null) {
      throw Exception('No organization found for $T $entityId.');
    }
    final apiProvider = await OrganizationController().initApiProvider(message: message, organization: organization);
    if (apiProvider == null) {
      throw Exception('No API provider selected for the organization $organization.');
    }
    return Response.ok((await apiProvider.checkCredentials()).toString());
  }

  Future<Response> postImport(Request request, User? user, String entityIdStr) async {
    final bool obfuscate = user?.obfuscate ?? true;
    if (obfuscate) {
      return Response.forbidden('A user without read permissions should also not be able to process an import.');
    }
    final entityId = int.parse(entityIdStr);
    final queryParams = request.requestedUri.queryParameters;
    if (importProgress != null) {
      return Response.badRequest(
        body: 'There already is another import for $T in progress. Please wait until finished!',
      );
    }
    importProgress = 0;

    try {
      _logger.info('postImport for type "$T" and entityId "$entityId" STARTED');
      final message = await request.readAsString();

      // Only admins can call a subjacent import, to prevent overwriting critical entities.
      final includeSubjacent =
          bool.parse(queryParams['subjacent'] ?? 'false') &&
          (user?.privilege ?? UserPrivilege.none) >= UserPrivilege.admin;
      final entity = await getSingle(entityId, obfuscate: obfuscate);

      final organization = getOrganization(entity);
      if (organization == null) {
        throw Exception('No organization found for $T $entityId.');
      }

      final apiProvider = await OrganizationController().initApiProvider(message: message, organization: organization);
      if (apiProvider == null) {
        throw Exception('No API provider selected for the organization $organization.');
      }

      final totalSteps = 2;
      int step = 0;

      // Import parent entities first, as they are required by subjacent entities (e.g. TeamMatch requires Clubs)
      if (entity is! Organization) {
        final organizationProgress = OrganizationController().import(
          apiProvider: apiProvider,
          entity: organization,
          includeSubjacent: false,
        );
        await for (final progress in organizationProgress) {
          importProgress = (step + (progress / 2)) / totalSteps;
        }
        if (entity is Competition) {
          // No further parent to update
        } else if (entity is! League) {
          if (entity is TeamMatch) {
            if (entity.league != null) {
              final leagueProgress = LeagueController().import(
                apiProvider: apiProvider,
                entity: entity.league!,
                includeSubjacent: false,
              );
              await for (final progress in leagueProgress) {
                importProgress = (step + ((1 + progress) / 2)) / totalSteps;
              }
            }
          } else {
            throw HttpException('Cannot process parent API import for $T');
          }
        }
      }
      importProgress = (++step) / totalSteps;

      final progressStream = import(entity: entity, apiProvider: apiProvider, includeSubjacent: includeSubjacent);
      await for (final progress in progressStream) {
        importProgress = (step + progress) / totalSteps;
      }
      _logger.info('postImport for type "$T" and entityId "$entityId" was SUCCESSFUL');
      return Response.ok('{"status": "success"}');
    } on HttpException catch (err, stackTrace) {
      return Response.badRequest(body: '{"err": "$err", "stackTrace": "$stackTrace"}');
    } catch (err, stackTrace) {
      _logger.severe('postImport for type "$T" and entityId "$entityId" FAILED', err, stackTrace);
      return Response.internalServerError(body: '{"err": "$err", "stackTrace": "$stackTrace"}');
    } finally {
      importProgress = null;
    }
  }

  Stream<double> import({required WrestlingApi apiProvider, required T entity, bool includeSubjacent = false});
}
