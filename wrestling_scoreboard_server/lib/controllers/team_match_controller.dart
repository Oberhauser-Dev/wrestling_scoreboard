import 'dart:convert';

import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/league_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/participant_state_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

import 'entity_controller.dart';
import 'bout_controller.dart';

class TeamMatchController extends EntityController<TeamMatch> {
  static final TeamMatchController _singleton = TeamMatchController._internal();

  factory TeamMatchController() {
    return _singleton;
  }

  TeamMatchController._internal() : super(tableName: 'team_match');

  static const _boutsQuery = '''
        SELECT f.* 
        FROM bout as f 
        JOIN team_match_bout AS tmf ON tmf.bout_id = f.id
        WHERE tmf.team_match_id = @id
        ORDER BY tmf.pos;''';

  Future<Response> requestBouts(Request request, String id) async {
    return EntityController.handleRequestManyOfControllerFromQuery(BoutController(),
        isRaw: isRaw(request), sqlQuery: _boutsQuery, substitutionValues: {'id': id});
  }

  Future<List<Bout>> getBouts(String id) {
    return BoutController().getManyFromQuery(_boutsQuery, substitutionValues: {'id': id});
  }

  /// isReset: delete all previous Bouts and TeamMatchBouts, else reuse the states
  Future<Response> generateBouts(Request request, String id) async {
    final isReset = (request.url.queryParameters['isReset'] ?? '').parseBool();
    final teamMatch = (await getSingle(int.parse(id)))!;
    final oldBouts = (await getBouts(id));
    final weightClasses = teamMatch.league?.id == null
        ? <WeightClass>[]
        : (await LeagueController().getWeightClasses(teamMatch.league!.id.toString()));
    final homeParticipations = await ParticipationController()
        .getMany(conditions: ['lineup_id = @id'], substitutionValues: {'id': teamMatch.home.id});
    final guestParticipations = await ParticipationController()
        .getMany(conditions: ['lineup_id = @id'], substitutionValues: {'id': teamMatch.guest.id});

    final newBouts = await teamMatch.generateBouts([homeParticipations, guestParticipations], weightClasses);
    final bouts = List.of(newBouts);
    await Future.forEach(newBouts.asMap().entries, (MapEntry<int, Bout> entry) async {
      var bout = entry.value;
      final hasRed = bout.r != null;
      final hasBlue = bout.b != null;
      // Get bout of teamMatch that has the same participants and the same weightClass
      final res = await BoutController().getManyRawFromQuery('''
        SELECT f.*
        FROM bout AS f
        JOIN team_match_bout AS tmf ON f.id = tmf.bout_id
        ${hasRed ? 'JOIN participant_state AS ps_red ON ps_red.id = f.red_id' : ''}
        ${hasBlue ? 'JOIN participant_state AS ps_blue ON ps_blue.id = f.blue_id' : ''}
        WHERE f.weight_class_id = ${bout.weightClass.id}
        AND tmf.team_match_id = ${teamMatch.id}
        AND ${hasRed ? 'ps_red.participation_id = ${bout.r!.participation.id}' : 'f.red_id IS NULL'}
        AND ${hasBlue ? 'ps_blue.participation_id = ${bout.b!.participation.id}' : 'f.blue_id IS NULL'};
        ''');
      if (res.isEmpty) {
        // Create ParticipantState to be stored in the team match bout
        if (bout.r != null) {
          bout = bout.copyWith(r: bout.r!.copyWithId(await ParticipantStateController().createSingle(bout.r!)));
        }
        if (bout.b != null) {
          bout = bout.copyWith(b: bout.b!.copyWithId(await ParticipantStateController().createSingle(bout.b!)));
        }
        bout = bout.copyWithId(await BoutController().createSingle(bout));
        await TeamMatchBoutController()
            .createSingle(TeamMatchBout(teamMatch: teamMatch, bout: bout, pos: entry.key));
        bouts[entry.key] = bout;
      } else {
        bout = bout.copyWithId(res.first['id']);
        bouts[entry.key] = await Bout.fromRaw(res.first, EntityController.getSingleFromDataType);
        await PostgresDb()
            .connection
            .query('UPDATE team_match_bout SET pos = ${entry.key} WHERE bout_id = ${bout.id};');
      }
    });
    if (isReset) {
      await Future.forEach(oldBouts, (Bout bout) async {
        if (bout.id != null) {
          // TODO may also delete boutActions, participantState etc.
          await TeamMatchBoutController()
              .deleteMany(conditions: ['bout_id=@id'], substitutionValues: {'id': bout.id});
          await BoutController().deleteSingle(bout.id!);
        }
      });
    } else {
      // Get old bouts, which aren't reused anymore and delete them.
      final unusedBouts = oldBouts.where((oldBout) => bouts.every((newBout) => newBout.id != oldBout.id));
      await Future.forEach(unusedBouts, (Bout bout) async {
        if (bout.id != null) {
          // TODO may also delete boutActions, participantState etc.
          await TeamMatchBoutController()
              .deleteMany(conditions: ['bout_id=@id'], substitutionValues: {'id': bout.id});
          await BoutController().deleteSingle(bout.id!);
        }
      });
    }
    broadcast(jsonEncode(manyToJson(bouts, Bout, CRUD.update, isRaw: false, filterType: TeamMatch, filterId: teamMatch.id)));

    return Response.ok('{"status": "success"}');
  }

  @override
  Map<String, PostgreSQLDataType?> getPostgresDataTypes() {
    return {'comment': PostgreSQLDataType.text};
  }
}
