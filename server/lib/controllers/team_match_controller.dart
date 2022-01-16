import 'dart:convert';

import 'package:common/common.dart';
import 'package:postgres/postgres.dart';
import 'package:server/controllers/league_controller.dart';
import 'package:server/controllers/participant_state_controller.dart';
import 'package:server/controllers/participation_controller.dart';
import 'package:server/controllers/person_controller.dart';
import 'package:server/controllers/team_match_fight_controller.dart';
import 'package:server/controllers/websocket_handler.dart';
import 'package:server/controllers/weight_class_controller.dart';
import 'package:shelf/shelf.dart';

import 'entity_controller.dart';
import 'fight_controller.dart';
import 'lineup_controller.dart';

class ServerTeamMatch extends TeamMatch {
  ServerTeamMatch({
    int? id,
    required Lineup home,
    required Lineup guest,
    required List<WeightClass> weightClasses,
    required List<Person> referees,
    String? no,
    String? location,
    DateTime? date,
    int? visitorsCount,
    String? comment,
  }) : super(
          id: id,
          home: home,
          guest: guest,
          referees: referees,
          no: no,
          location: location,
          date: date,
          weightClasses: weightClasses,
          visitorsCount: visitorsCount,
          comment: comment,
        );

  @override
  Future<void> generateFights() async {
    List<Fight> fights = [];
    final homeParticipations =
        await ParticipationController().getMany(conditions: ['lineup_id = @id'], substitutionValues: {'id': home.id});
    final guestParticipations =
        await ParticipationController().getMany(conditions: ['lineup_id = @id'], substitutionValues: {'id': guest.id});
    for (final weightClass in weightClasses) {
      final homePartList = homeParticipations.where((el) => el.weightClass == weightClass);
      if (homePartList.length > 1) {
        throw Exception(
            'Home team has two or more participants in the same weight class ${weightClass.name}: ${homePartList.map((e) => e.membership.person.fullName).join(', ')}');
      }
      final guestPartList = guestParticipations.where((el) => (el.weightClass == weightClass));
      if (guestPartList.length > 1) {
        throw Exception(
            'Guest team has two or more participants in the same weight class ${weightClass.name}: ${guestPartList.map((e) => e.membership.person.fullName).join(', ')}');
      }
      final red = homePartList.isNotEmpty ? homePartList.single : null;
      final blue = guestPartList.isNotEmpty ? guestPartList.single : null;

      var fight = Fight(
        r: red == null ? null : ParticipantState(participation: red),
        b: blue == null ? null : ParticipantState(participation: blue),
        weightClass: weightClass,
      );
      fights.add(fight);
    }
    this.fights = fights;
    broadcast(jsonEncode(manyToJson(fights, Fight, CRUD.update, filterType: TeamMatch, filterId: id)));
  }
}

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
    if (isReset) {
      await Future.forEach(oldFights, (Fight e) async {
        if (e.id != null) await deleteSingle(e.id!);
      });
    }
    await teamMatch.generateFights();
    await Future.forEach(teamMatch.fights.asMap().entries, (MapEntry<int, Fight> entry) async {
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
  Future<TeamMatch> parseToClass(Map<String, dynamic> e) async {
    final home = await LineupController().getSingle(e['home_id'] as int);
    final guest = await LineupController().getSingle(e['guest_id'] as int);
    final referee = await PersonController().getSingle(e['referee_id'] as int);
    final weightClasses = home != null && home.team.league != null
        ? await LeagueController().getWeightClasses(home.team.league!.id.toString())
        : await WeightClassController().getMany();
    // TODO may add weightclasses of both teams leagues

    return ServerTeamMatch(
      id: e[primaryKeyName] as int?,
      no: e['no'] as String?,
      home: home!,
      guest: guest!,
      weightClasses: weightClasses,
      referees: [referee!],
      // TODO need extra table for multiple referees.
      location: e['location'] as String?,
      date: e['date'] as DateTime?,
      visitorsCount: e['visitors_count'] as int?,
      comment: e['comment'] as String?,
    );
  }

  @override
  PostgresMap parseFromClass(TeamMatch e) {
    return PostgresMap({
      if (e.id != null) primaryKeyName: e.id,
      'no': e.no,
      'home_id': e.home.id,
      'guest_id': e.guest.id,
      'referee_id': e.referees.first.id,
      'location': e.location,
      'date': e.date,
      'visitors_count': e.visitorsCount,
      'comment': e.comment,
    }, {
      'comment': PostgreSQLDataType.text
    });
  }
}
