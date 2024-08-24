import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

class SearchController {
  /// Search all tables
  Future<Response> search(Request request) async {
    final queryParams = request.requestedUri.queryParameters;

    final likeParam = queryParams['like'];
    final querySearchType = queryParams['type'];
    final searchOrganizationId = int.tryParse(queryParams['org'] ?? '');
    final useProvider = bool.parse(queryParams['use_provider'] ?? 'false');
    final isValidLikeSearch = likeParam != null && (likeParam.length >= 3 || double.tryParse(likeParam) != null);
    final searchAllTypes = querySearchType == null;

    if (useProvider && (!isValidLikeSearch || searchAllTypes || searchOrganizationId == null)) {
      return Response.badRequest(
          body:
              'Searching the API provider without specifying a type, the organization and a search string is not supported!');
    }

    final Iterable<String> searchTypes;
    if (!searchAllTypes) {
      searchTypes = [querySearchType];
    } else {
      // All searchable types
      searchTypes = dataTypes.map((d) => getTableNameFromType(d));
    }

    try {
      final raw = request.isRaw;
      List<Map<String, dynamic>> manyJsonList = [];
      for (final tableName in searchTypes) {
        final searchType = getTypeFromTableName(tableName);
        final entityController = ShelfController.getControllerFromDataType(searchType);
        Map<String, dynamic>? manyJson;
        if (isValidLikeSearch) {
          manyJson = await entityController.getManyJsonLike(raw, likeParam, organizationId: searchOrganizationId);
          if (!searchAllTypes && useProvider && searchOrganizationId != null) {
            final orgSearchRes = await OrganizationController().search(
              request,
              searchOrganizationId,
              searchStr: likeParam,
              searchType: searchType,
            );
            manyJson = manyToJson(orgSearchRes, searchType, CRUD.read, isRaw: false);
          }
        } else if (!searchAllTypes) {
          manyJson = await entityController.getManyJson(
              isRaw: raw,
              conditions: searchOrganizationId != null ? ['organization_id = @org'] : null,
              substitutionValues: searchOrganizationId != null ? {'org': searchOrganizationId} : null);
        } else {
          return Response.badRequest(
              body: 'You must either search by a type via "type", '
                  'by a search string with at least 3 characters "like", or both.');
        }
        if (manyJson != null) {
          manyJsonList.add(manyJson);
        }
      }
      return Response.ok(raw ? rawJsonEncode(manyJsonList) : jsonEncode(manyJsonList));
    } catch (err, stackTrace) {
      return Response.internalServerError(body: '{"err": "$err", "stackTrace": $stackTrace}');
    }
  }
}
