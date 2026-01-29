import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_common/src/mocked_data.dart';
import 'package:wrestling_scoreboard_server/controllers/athlete_bout_state_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_action_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_weight_category_controller.dart';
import 'package:wrestling_scoreboard_server/server.dart' as server;
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

import 'common.dart';

void main() {
  MockableDateTime.isMocked = true;
  MockableDateTime.mockedDateTime = DateTime.utc(2024, 01, 02);
  MockableRandom.isMocked = true;

  final mockedData = MockedData();
  final competitionDataTypes = [
    CompetitionParticipation,
    // CompetitionBout,
    CompetitionWeightCategory,
    CompetitionAgeCategory,
    WeightClass,
    CompetitionLineup,
    // BoutAction,
    // Bout,
    // AthleteBoutState,
    Membership,
    CompetitionPerson,
    Person,
    CompetitionSystemAffiliation,
    Competition,
    Club,
    AgeCategory,
    Organization,
    BoutResultRule,
    BoutConfig,
  ];

  Future<void> loadMockedData() async {
    for (final dataType in competitionDataTypes.reversed) {
      final List<DataObject> objs = mockedData.getByType(dataType);
      final controller = ShelfController.getControllerFromDataType(dataType);
      await controller!.createMany(objs);
    }
  }

  group('Competition', () {
    late PostgresDb db;
    setUp(() async {
      db = PostgresDb();
      await db.open();
    });

    tearDown(() async {
      await db.close();
    });

    group('Mocked', () {
      late HttpServer serverInstance;
      late String apiUrl;
      late Map<String, String> authHeaders;

      setUp(() async {
        await db.reset();
        serverInstance = await server.init();
        await loadMockedData();
        apiUrl = 'http://${serverInstance.address.address}:${serverInstance.port}/api';
        authHeaders = await getAuthHeaders(apiUrl);
      });

      tearDown(() async {
        await serverInstance.close();
      });

      test('Create entities via API', () async {
        final databaseExportForController = await db.export();
        await db.reset();

        for (final dataType in competitionDataTypes.reversed) {
          final Iterable<DataObject> objs = mockedData.getByType(dataType);
          for (var obj in objs) {
            final body = jsonEncode(singleToJson(obj, dataType, CRUD.create));
            final tableUrl = '$apiUrl/${obj.tableName}';
            final uri = Uri.parse(tableUrl);
            final postRes = await http.post(uri, headers: authHeaders, body: body);
            expect(postRes.statusCode, 200, reason: postRes.body);
          }
        }
        final databaseExportForApi = await db.export();

        expect(DatabaseExt.sanitizeSql(databaseExportForApi), DatabaseExt.sanitizeSql(databaseExportForController));
      });

      test('Generate bouts', () async {
        CompetitionWeightCategory competitionWeightCategory = mockedData.competitionWeightCategory;
        final competitionWeightCategoryGenerateUri = Uri.parse(
          '$apiUrl/${CompetitionWeightCategory.cTableName}/${competitionWeightCategory.id}/${Bout.cTableName}s/generate',
        );
        http.Response generateRes = await http.post(competitionWeightCategoryGenerateUri, headers: authHeaders);
        expect(generateRes.statusCode, 200, reason: generateRes.body);

        competitionWeightCategory = await CompetitionWeightCategoryController().getSingle(
          competitionWeightCategory.id!,
          obfuscate: false,
        );
        expect(competitionWeightCategory.competitionSystem, CompetitionSystem.doubleElimination);
        expect(competitionWeightCategory.poolGroupCount, 2);
        List<CompetitionBout> competitionBouts = await CompetitionBoutController().getByWeightCategory(
          competitionWeightCategory.id!,
          obfuscate: false,
        );
        expect(competitionBouts.length, 3);
        expect(competitionBouts.every((element) => element.round == 0), true);
        expect((await BoutController().getMany(obfuscate: false)).length, 3);
        expect((await AthleteBoutStateController().getMany(obfuscate: false)).length, 6);

        // Create some bout actions, to see if they are getting deleted
        await BoutActionController().createSingle(
          BoutAction(
            actionType: BoutActionType.points,
            bout: competitionBouts.first.bout,
            duration: Duration.zero,
            role: BoutRole.red,
          ),
        );
        await BoutActionController().createSingle(
          BoutAction(
            actionType: BoutActionType.points,
            bout: competitionBouts.first.bout,
            duration: Duration.zero,
            role: BoutRole.blue,
          ),
        );
        expect((await BoutActionController().getMany(obfuscate: false)).length, 2);

        // Generate a second time and check if see the same results
        generateRes = await http.post(competitionWeightCategoryGenerateUri, headers: authHeaders);
        expect(generateRes.statusCode, 200, reason: generateRes.body);

        competitionBouts = await CompetitionBoutController().getByWeightCategory(
          competitionWeightCategory.id!,
          obfuscate: false,
        );
        expect(competitionBouts.length, 3);
        expect((await BoutController().getMany(obfuscate: false)).length, 3);
        expect((await AthleteBoutStateController().getMany(obfuscate: false)).length, 6);
        expect((await BoutActionController().getMany(obfuscate: false)).length, 0);
      });
    });
  });
}
