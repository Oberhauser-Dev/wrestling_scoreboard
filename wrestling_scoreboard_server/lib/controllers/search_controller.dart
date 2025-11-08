import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

final _logger = Logger('SearchController');

class SearchController {
  /// Search all tables
  Future<Response> search(Request request, User? user) async {
    final bool obfuscate = user?.obfuscate ?? true;

    final queryParams = request.requestedUri.queryParameters;

    final likeParam = queryParams['like'];
    final querySearchTypeStr = queryParams['type'];
    final searchOrganizationId = int.tryParse(queryParams['org'] ?? '');
    final useProvider = bool.parse(queryParams['use_provider'] ?? 'false');
    final isValidLikeSearch = likeParam != null && (likeParam.length >= 3 || double.tryParse(likeParam) != null);
    final searchAllTypes = querySearchTypeStr == null;

    if (useProvider && (!isValidLikeSearch || searchAllTypes || searchOrganizationId == null)) {
      return Response.badRequest(
        body:
            'Searching the API provider without specifying a type, the organization and a search string is not supported!',
      );
    }

    final Set<Type> searchTypes;
    if (!searchAllTypes) {
      final querySearchType = getTypeFromTableName(querySearchTypeStr);
      final searchableAttr = searchableDataTypes[querySearchType];
      searchTypes = {if (searchableAttr != null) querySearchType};
    } else {
      // All searchable types, but avoid expensive searches
      searchTypes =
          searchableDataTypes.keys.toSet()
            ..remove(Bout)
            ..remove(CompetitionBout)
            ..remove(Membership)
            ..remove(TeamMatch)
            ..remove(TeamLineup)
            ..remove(TeamMatchBout);

      if (searchOrganizationId != null) {
        // Remove non-organizational classes, but to do it dynamically we have to know, which Type does not not inherit (Organizational).
        // So we do it manually
        searchTypes
          ..remove(Organization)
          ..remove(WeightClass);
      }
    }

    try {
      final raw = request.isRaw;
      final List<Map<String, dynamic>> manyJsonList = [];
      for (final searchType in searchTypes) {
        final entityController = ShelfController.getControllerFromDataType(searchType);
        Map<String, dynamic>? manyJson;
        if (isValidLikeSearch) {
          manyJson = await entityController?.getManyJsonLike(
            raw,
            likeParam,
            organizationId: searchOrganizationId,
            obfuscate: obfuscate,
          );
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
          manyJson = await entityController?.getManyJson(
            isRaw: raw,
            conditions: searchOrganizationId != null ? ['organization_id = @org'] : null,
            substitutionValues: searchOrganizationId != null ? {'org': searchOrganizationId} : null,
            obfuscate: obfuscate,
          );
        } else {
          return Response.badRequest(
            body:
                'You must either search by a type via "type", '
                'by a search string with at least 3 characters "like", or both.',
          );
        }
        if (manyJson != null) {
          manyJsonList.add(manyJson);
        }
      }
      return Response.ok(raw ? rawJsonEncode(manyJsonList) : jsonEncode(manyJsonList));
    } catch (err, stackTrace) {
      _logger.severe(
        'Search FAILED ('
        'likeParam: "$likeParam", '
        'querySearchTypeStr: $querySearchTypeStr, '
        'searchOrganizationId: $searchOrganizationId, '
        'useProvider: $useProvider'
        ')',
        err,
        stackTrace,
      );
      return Response.internalServerError(body: '{"err": "$err", "stackTrace": $stackTrace}');
    }
  }
}
