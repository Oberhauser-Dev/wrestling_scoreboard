import 'dart:convert';

import 'package:common/common.dart';
import 'package:postgres/postgres.dart';
import 'package:server/controllers/league_controller.dart';
import 'package:server/controllers/participant_state_controller.dart';
import 'package:server/controllers/participation_controller.dart';
import 'package:server/controllers/team_match_fight_controller.dart';
import 'package:server/controllers/websocket_handler.dart';
import 'package:shelf/shelf.dart';

import 'entity_controller.dart';
import 'fight_controller.dart';

class TeamMatchController extends EntityController<TeamMatch> {
  static final TeamMatchController _singleton = TeamMatchController._internal();

  factory TeamMatchController() {
    return _singleton;
  }

  TeamMatchController._internal() : super(tableName: 'team_match');

  static const _fightsQuery = '''
        SELECT f.* 
        FROM fight as f 
        JOIN team_match_fight AS tmf ON tmf.fight_id = f.id
        WHERE tmf.team_match_id = @id
        ORDER BY tmf.pos;''';

  Future<Response> requestFights(Request request, String id) async {
    return EntityController.handleRequestManyOfControllerFromQuery(FightController(),
        isRaw: isRaw(request), sqlQuery: _fightsQuery, substitutionValues: {'id': id});
  }

  Future<List<Fight>> getFights(String id) {
    return FightController().getManyFromQuery(_fightsQuery, substitutionValues: {'id': id});
  }

  Future<Response> generateFights(Request request, String id) async {
    final isReset = (request.url.queryParameters['reset'] ?? '').parseBool();
    final teamMatch = (await getSingle(int.parse(id)))!;
    final oldFights = (await getFights(id)); // TODO Check if works...
    final weightClasses = (await LeagueController().getWeightClasses(teamMatch.league.id.toString())); // TODO Check if works...
    if (isReset) {
      await Future.forEach(oldFights, (Fight e) async {
        if (e.id != null) await deleteSingle(e.id!);
      });
    }
    final homeParticipations = await ParticipationController()
        .getMany(conditions: ['lineup_id = @id'], substitutionValues: {'id': teamMatch.home.id});
    final guestParticipations = await ParticipationController()
        .getMany(conditions: ['lineup_id = @id'], substitutionValues: {'id': teamMatch.guest.id});
    
    final fights = await teamMatch.generateFights([homeParticipations, guestParticipations], weightClasses);
    
    broadcast(
        jsonEncode(manyToJson(fights, Fight, CRUD.update, filterType: TeamMatch, filterId: teamMatch.id)));
    await Future.forEach(fights.asMap().entries, (MapEntry<int, Fight> entry) async {
      final e = entry.value;
      final hasRed = e.r != null;
      final hasBlue = e.b != null;
      // Get fight of teamMatch that has the same participants and the same weightClass
      final res = await FightController().getManyRawFromQuery('''
        SELECT f.id
        FROM fight AS f
        JOIN team_match_fight AS tmf ON f.id = tmf.fight_id
        ${hasRed ? 'JOIN participant_state AS ps_red ON ps_red.id = f.red_id' : ''}
        ${hasBlue ? 'JOIN participant_state AS ps_blue ON ps_blue.id = f.blue_id' : ''}
        WHERE f.weight_class_id = ${e.weightClass.id}
        AND tmf.team_match_id = ${teamMatch.id}
        AND ${hasRed ? 'ps_red.participation_id = ${e.r!.participation.id}' : 'f.red_id IS NULL'}
        AND ${hasBlue ? 'ps_blue.participation_id = ${e.b!.participation.id}' : 'f.blue_id IS NULL'};
        ''');
      if (res.isEmpty) {
        // Create ParticipantState to be stored in the team match fight
        if (e.r != null) {
          e.r!.id = await ParticipantStateController().createSingle(e.r!);
        }
        if (e.b != null) {
          e.b!.id = await ParticipantStateController().createSingle(e.b!);
        }
        e.id = await FightController().createSingle(e);
        await TeamMatchFightController().createSingle(TeamMatchFight(teamMatch: teamMatch, fight: e, pos: entry.key));
      }
    });
    return Response.ok('{"status": "success"}');
  }

  @override
  Map<String, PostgreSQLDataType?> getPostgresDataTypes() {
    return {'comment': PostgreSQLDataType.text};
  }
}
