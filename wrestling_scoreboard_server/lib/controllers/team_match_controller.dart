import 'dart:convert';

import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_action_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/membership_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/participant_state_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/person_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/request.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

import 'bout_controller.dart';
import 'entity_controller.dart';

class TeamMatchController extends OrganizationalController<TeamMatch> with ImportController {
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

  Future<Response> requestBouts(Request request, User? user, String id) async {
    final bool obfuscate = user?.obfuscate ?? true;

    return BoutController().handleRequestManyFromQuery(
      isRaw: request.isRaw,
      sqlQuery: _boutsQuery,
      substitutionValues: {'id': id},
      obfuscate: obfuscate,
    );
  }

  Future<Response> requestTeamMatchBouts(Request request, User? user, String id) async {
    return TeamMatchBoutController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['team_match_id = @id'],
      substitutionValues: {'id': id},
      orderBy: ['pos'],
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<List<Bout>> getBouts(String id, {required bool obfuscate}) {
    return BoutController().getManyFromQuery(_boutsQuery, substitutionValues: {'id': id}, obfuscate: obfuscate);
  }

  /// isReset: delete all previous Bouts and TeamMatchBouts, else reuse the states
  Future<Response> generateBouts(Request request, User? user, String id) async {
    final bool obfuscate = user?.obfuscate ?? true;
    final isReset = (request.url.queryParameters['isReset'] ?? '').parseBool();
    final teamMatch = (await getSingle(int.parse(id), obfuscate: false));
    final oldBouts = (await getBouts(id, obfuscate: obfuscate));
    final weightClasses = teamMatch.league?.division.id == null
        ? <WeightClass>[]
        : (await DivisionController().getWeightClasses(teamMatch.league!.division.id.toString(),
            seasonPartition: teamMatch.seasonPartition, obfuscate: false));
    final homeParticipations = await ParticipationController()
        .getMany(conditions: ['lineup_id = @id'], substitutionValues: {'id': teamMatch.home.id}, obfuscate: false);
    final guestParticipations = await ParticipationController()
        .getMany(conditions: ['lineup_id = @id'], substitutionValues: {'id': teamMatch.guest.id}, obfuscate: false);

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
        WHERE f.weight_class_id = ${bout.weightClass!.id}
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
        await TeamMatchBoutController().createSingle(TeamMatchBout(teamMatch: teamMatch, bout: bout, pos: entry.key));
        bouts[entry.key] = bout;
      } else {
        bout = bout.copyWithId(res.first['id']);
        bouts[entry.key] = await Bout.fromRaw(
            res.first, <T extends DataObject>(id) => EntityController.getSingleFromDataType<T>(id, obfuscate: false));
        final conn = PostgresDb().connection;
        await conn.execute('UPDATE team_match_bout SET pos = ${entry.key} WHERE bout_id = ${bout.id};');
      }
    });
    if (isReset) {
      await Future.forEach(oldBouts, (Bout bout) async {
        if (bout.id != null) {
          await TeamMatchBoutController().deleteMany(conditions: ['bout_id=@id'], substitutionValues: {'id': bout.id});
          await BoutController().deleteSingle(bout.id!);
        }
      });
    } else {
      // Get old bouts, which aren't reused anymore and delete them.
      final unusedBouts = oldBouts.where((oldBout) => bouts.every((newBout) => newBout.id != oldBout.id));
      await Future.forEach(unusedBouts, (Bout bout) async {
        if (bout.id != null) {
          await TeamMatchBoutController().deleteMany(conditions: ['bout_id=@id'], substitutionValues: {'id': bout.id});
          await BoutController().deleteSingle(bout.id!);
        }
      });
    }

    // TODO: handle obfuscate.
    broadcast((obfuscate) async =>
        jsonEncode(manyToJson(bouts, Bout, CRUD.update, isRaw: false, filterType: TeamMatch, filterId: teamMatch.id)));

    return Response.ok('{"status": "success"}');
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'comment': psql.Type.text};
  }

  @override
  Future<Response> import(Request request, User? user, String entityId) async {
    try {
      final bool obfuscate = user?.obfuscate ?? true;
      final teamMatch = await TeamMatchController().getSingle(int.parse(entityId), obfuscate: false);

      final organizationId = teamMatch.organization?.id;
      if (organizationId == null) {
        throw Exception('No organization found for league $entityId.');
      }

      final apiProvider = await OrganizationController().initApiProvider(request, organizationId);
      if (apiProvider == null) {
        throw Exception('No API provider selected for the organization $organizationId.');
      }
      // apiProvider.isMock = true;

      final boutMap = await apiProvider.importBouts(event: teamMatch);

      // Handle bouts one after one, (NO Future.wait) as it may conflicts creating the same membership as once.
      var index = 0;
      for (final boutEntry in boutMap.entries) {
        var bout = boutEntry.key;

        final teamMatchBout = TeamMatchBout(
          pos: index,
          teamMatch: teamMatch,
          bout: bout,
          organization: teamMatch.organization,
          orgSyncId: bout.orgSyncId,
        );
        await TeamMatchBoutController().getOrCreateSingleOfOrg(teamMatchBout, obfuscate: obfuscate, onCreate: () async {
          bout = await BoutController().getOrCreateSingleOfOrg(
            bout,
            obfuscate: obfuscate,
            onCreate: () async {
              return bout.copyWith(
                r: await _saveDeepParticipantState(bout.r, obfuscate: obfuscate),
                b: await _saveDeepParticipantState(bout.b, obfuscate: obfuscate),
              );
            },
          );

          // Add missing id to bout of boutActions
          final Iterable<BoutAction> boutActions = boutEntry.value.map((action) => action.copyWith(bout: bout));
          await BoutActionController().createMany(boutActions.toList());
          return teamMatchBout.copyWith(bout: bout);
        });
        index++;
      }
      updateLastImportUtcDateTime(entityId);
      return Response.ok('{"status": "success"}');
    } on HttpException catch (err, stackTrace) {
      return Response.badRequest(body: '{"err": "$err", "stackTrace": "$stackTrace"}');
    } catch (err, stackTrace) {
      return Response.internalServerError(body: '{"err": "$err", "stackTrace": "$stackTrace"}');
    }
  }

  Future<ParticipantState?> _saveDeepParticipantState(ParticipantState? participantState,
      {required bool obfuscate}) async {
    if (participantState != null) {
      final person = await PersonController()
          .getOrCreateSingleOfOrg(participantState.participation.membership.person, obfuscate: obfuscate);

      final membership = await MembershipController().getOrCreateSingleOfOrg(
          participantState.participation.membership.copyWith(person: person),
          obfuscate: obfuscate);

      final participation = await ParticipationController()
          .createSingleReturn(participantState.participation.copyWith(membership: membership));

      return await ParticipantStateController()
          .createSingleReturn(participantState.copyWith(participation: participation));
    }
    return null;
  }
}
