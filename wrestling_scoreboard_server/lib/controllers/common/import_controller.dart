import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';

final _logger = Logger('ImportController');

mixin ImportController<T extends DataObject> implements ShelfController<T> {
  Map<int, DateTime> lastImportUtcDateTime = {};
  bool importInProgress = false;

  Future<Response> requestLastImportUtcDateTime(Request request, User? user, String entityId) async {
    return Response.ok(lastImportUtcDateTime[int.parse(entityId)]?.toIso8601String());
  }

  void updateLastImportUtcDateTime(int id) {
    lastImportUtcDateTime[id] = DateTime.now().toUtc();
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
    if (importInProgress) {
      return Response.badRequest(
        body: 'There already is another import for $T in progress. Please wait until finished!',
      );
    }
    importInProgress = true;
    try {
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
      await import(entity: entity, apiProvider: apiProvider, includeSubjacent: includeSubjacent);
      return Response.ok('{"status": "success"}');
    } on HttpException catch (err, stackTrace) {
      return Response.badRequest(body: '{"err": "$err", "stackTrace": "$stackTrace"}');
    } catch (err, stackTrace) {
      _logger.severe('postImport for type "$T" and entityId "$entityId" FAILED', err, stackTrace);
      return Response.internalServerError(body: '{"err": "$err", "stackTrace": "$stackTrace"}');
    } finally {
      importInProgress = false;
    }
  }

  Future<void> import({required WrestlingApi apiProvider, required T entity, bool includeSubjacent = false});
}
