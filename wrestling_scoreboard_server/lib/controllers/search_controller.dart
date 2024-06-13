import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

class SearchController {
  /// Reset all tables
  Future<Response> search(Request request) async {
    final queryParams = request.requestedUri.queryParameters;

    final likeParam = queryParams['like'];

    final Iterable<String> searchTypes;
    final querySearchType = queryParams['type'];
    if (querySearchType != null) {
      searchTypes = [querySearchType];
    } else {
      // All searchable types
      searchTypes = dataTypes.map((d) => getTableNameFromType(d));
    }

    final searchOrganizationId = int.tryParse(queryParams['org'] ?? '');

    try {
      final raw = request.isRaw;
      List<Map<String, dynamic>> manyJsonList = [];
      for (final searchType in searchTypes) {
        final entityController = EntityController.getControllerFromDataType(getTypeFromTableName(searchType));
        Map<String, dynamic>? manyJson;
        if (likeParam != null && (likeParam.length >= 3 || double.tryParse(likeParam) != null)) {
          manyJson = await entityController.getManyJsonLike(raw, likeParam, organizationId: searchOrganizationId);
        } else if (querySearchType != null) {
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
