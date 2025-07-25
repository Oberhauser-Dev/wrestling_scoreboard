import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/athlete_bout_state_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_action_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_bout_controller.dart';
import 'package:wrestling_scoreboard_server/server.dart' as server;
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

import 'common.dart';

void main() {
  MockableDateTime.isMocked = true;
  MockableDateTime.mockedDateTime = DateTime.utc(2024, 01, 02);
  MockableRandom.isMocked = true;

  test('TeamMatch', () async {
    final db = PostgresDb();
    await db.open();
    await db.reset();

    final instance = await server.init();
    final apiUrl = 'http://${instance.address.address}:${instance.port}/api';
    final authHeaders = await getAuthHeaders(apiUrl);

    final teamMatchDataTypes = [
      // TeamMatchBout,
      TeamLineupParticipation,
      LeagueWeightClass,
      DivisionWeightClass,
      WeightClass,
      TeamMatch,
      TeamLineup,
      TeamClubAffiliation,
      LeagueTeamParticipation,
      Team,
      // BoutAction,
      // Bout,
      // AthleteBoutState,
      Membership,
      Person,
      League,
      Division,
      Club,
      AgeCategory,
      Organization,
      BoutResultRule,
      BoutConfig,
    ];
    for (final dataType in teamMatchDataTypes.reversed) {
      final Iterable<DataObject> objs = getMockedDataObjects(dataType);
      for (var obj in objs) {
        final body = jsonEncode(singleToJson(obj, dataType, CRUD.create));
        final tableUrl = '$apiUrl/${obj.tableName}';
        final uri = Uri.parse(tableUrl);
        final postRes = await http.post(uri, headers: authHeaders, body: body);
        expect(postRes.statusCode, 200, reason: postRes.body);
      }
    }

    final TeamMatch teamMatch = mockedData.menRPWMatch;
    final teamMatchGenerateUri = Uri.parse(
      '$apiUrl/${TeamMatch.cTableName}/${teamMatch.id}/${Bout.cTableName}s/generate',
    );
    http.Response generateRes = await http.post(teamMatchGenerateUri, headers: authHeaders);
    expect(generateRes.statusCode, 200, reason: generateRes.body);

    List<TeamMatchBout> teamMatchBouts = await TeamMatchBoutController().getByTeamMatch(
      teamMatch.id!,
      obfuscate: false,
    );
    expect(teamMatchBouts.length, 1);
    expect((await BoutController().getMany(obfuscate: false)).length, 1);
    expect((await AthleteBoutStateController().getMany(obfuscate: false)).length, 2);

    // Create some bout actions, to see if they are retained.
    // Existing bouts should keep their actions, if they have the same participants.
    await BoutActionController().createSingle(
      BoutAction(
        actionType: BoutActionType.points,
        bout: teamMatchBouts.first.bout,
        duration: Duration.zero,
        role: BoutRole.red,
      ),
    );
    await BoutActionController().createSingle(
      BoutAction(
        actionType: BoutActionType.points,
        bout: teamMatchBouts.first.bout,
        duration: Duration.zero,
        role: BoutRole.blue,
      ),
    );
    expect((await BoutActionController().getMany(obfuscate: false)).length, 2);

    // Generate a second time and check if see the same results
    generateRes = await http.post(teamMatchGenerateUri, headers: authHeaders);
    expect(generateRes.statusCode, 200, reason: generateRes.body);

    teamMatchBouts = await TeamMatchBoutController().getByTeamMatch(teamMatch.id!, obfuscate: false);
    expect(teamMatchBouts.length, 1);
    expect((await BoutController().getMany(obfuscate: false)).length, 1);
    expect((await AthleteBoutStateController().getMany(obfuscate: false)).length, 2);
    // Bouts with the same participants and weight class keep their actions
    expect((await BoutActionController().getMany(obfuscate: false)).length, 2);

    await instance.close();
    await db.close();
  });
}
