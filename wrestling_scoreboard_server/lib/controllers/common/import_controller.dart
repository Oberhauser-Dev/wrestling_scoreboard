import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';

mixin ImportController<T extends DataObject> implements ShelfController<T> {
  Map<int, DateTime> lastImportUtcDateTime = {};

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
    final entityId = int.parse(entityIdStr);
    final queryParams = request.requestedUri.queryParameters;
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
      await import(entity: entity, apiProvider: apiProvider, obfuscate: obfuscate, includeSubjacent: includeSubjacent);
      return Response.ok('{"status": "success"}');
    } on HttpException catch (err, stackTrace) {
      return Response.badRequest(body: '{"err": "$err", "stackTrace": "$stackTrace"}');
    } catch (err, stackTrace) {
      return Response.internalServerError(body: '{"err": "$err", "stackTrace": "$stackTrace"}');
    }
  }

  Future<void> import({
    required WrestlingApi apiProvider,
    required T entity,
    bool obfuscate = true,
    bool includeSubjacent = false,
  });
}
