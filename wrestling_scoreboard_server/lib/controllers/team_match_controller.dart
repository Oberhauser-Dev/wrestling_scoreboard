import 'dart:convert';

import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_action_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/membership_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/athlete_bout_state_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_lineup_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/person_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/request.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

import 'bout_controller.dart';
import 'entity_controller.dart';

class TeamMatchController extends OrganizationalController<TeamMatch> with ImportController<TeamMatch> {
  static final TeamMatchController _singleton = TeamMatchController._internal();

  factory TeamMatchController() {
    return _singleton;
  }

  TeamMatchController._internal() : super();

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

  /// isReset: delete all previous Bouts and TeamMatchBouts, else reuse the states
  Future<Response> generateBouts(Request request, User? user, String id) async {
    final bool obfuscate = user?.obfuscate ?? true;
    final isReset = (request.url.queryParameters['isReset'] ?? '').parseBool();
    final teamMatch = (await getSingle(int.parse(id), obfuscate: false));
    final oldTmBouts = (await TeamMatchBoutController().getByTeamMatch(user, teamMatch.id!));
    final leagueWeightClasses = teamMatch.league?.id == null
        ? <LeagueWeightClass>[]
        : (await LeagueController().getLeagueWeightClasses(teamMatch.league!.id.toString(),
            seasonPartition: teamMatch.seasonPartition, obfuscate: false));
    List<WeightClass> weightClasses = leagueWeightClasses.map((lwc) => lwc.weightClass).toList();
    if (weightClasses.isEmpty) {
      final divisionWeightClasses = teamMatch.league?.division.id == null
          ? <DivisionWeightClass>[]
          : (await DivisionController().getDivisionWeightClasses(teamMatch.league!.division.id.toString(),
              seasonPartition: teamMatch.seasonPartition, obfuscate: false));
      weightClasses = divisionWeightClasses.map((dwc) => dwc.weightClass).toList();
    }
    // Reorder weightClasses according to bout order:
    // Calculate the number of match sections.
    WeightClass? lastWeightClass;
    List<int> sectionLengths = [];
    for (final weightClass in weightClasses) {
      // A weight class is smaller than the one before, a new section starts
      if (lastWeightClass == null || weightClass.weight < lastWeightClass.weight) {
        // A new section starts
        sectionLengths.add(1);
      } else {
        // Add more weight classes to current section
        sectionLengths.last++;
      }
      lastWeightClass = weightClass;
    }
    final List<WeightClass> sortedWeightClasses = List.of(weightClasses);

    // For each section, calculate the new position of the weight classes:
    // 0    1     2    3    4    5    6	        7    8    9    10   11   12   13
    // 57F, 61G, 66F,  75G, 86F, 98G, 130F,     57G, 61F, 66G, 75F, 86G, 98F, 130G
    // 0    2     4    6    5    3    1         7    9    11   13   12   10   8
    //
    // 0    1     2    3    4    5    6         7    8     9    10   11   12   13
    // 57F, 130F, 61G, 98G, 66F, 86F, 75G,      57G, 130G, 61F, 98F, 66G, 86G, 75F
    int sectionPos = 0;
    for (final sectionLength in sectionLengths) {
      for (int originalPos = 0; originalPos < sectionLength; originalPos++) {
        final weightClass = weightClasses[sectionPos + originalPos];
        final newPos = originalPos < (sectionLength / 2) ? originalPos * 2 : (sectionLength - originalPos - 1) * 2 + 1;
        sortedWeightClasses[sectionPos + newPos] = weightClass;
      }
      sectionPos += sectionLength;
    }

    final homeParticipations = await TeamLineupParticipationController()
        .getMany(conditions: ['lineup_id = @id'], substitutionValues: {'id': teamMatch.home.id}, obfuscate: false);
    final guestParticipations = await TeamLineupParticipationController()
        .getMany(conditions: ['lineup_id = @id'], substitutionValues: {'id': teamMatch.guest.id}, obfuscate: false);

    final newBouts = await teamMatch.generateBouts([homeParticipations, guestParticipations], sortedWeightClasses);
    final tmBouts = List.of(newBouts);
    await Future.forEach(newBouts.asMap().entries, (MapEntry<int, TeamMatchBout> entry) async {
      var tmb = entry.value;
      final hasRed = tmb.bout.r != null;
      final hasBlue = tmb.bout.b != null;
      // Get bout of teamMatch that has the same participants and the same weightClass
      final res = await BoutController().getManyRawFromQuery('''
        SELECT tmf.*
        FROM team_match_bout AS tmf
        JOIN bout ON bout.id = tmf.bout_id
        ${hasRed ? 'JOIN participant_state AS ps_red ON ps_red.id = bout.red_id' : ''}
        ${hasBlue ? 'JOIN participant_state AS ps_blue ON ps_blue.id = bout.blue_id' : ''}
        WHERE bout.weight_class_id = ${tmb.weightClass!.id}
        AND tmf.team_match_id = ${teamMatch.id}
        AND ${hasRed ? 'ps_red.membership_id = ${tmb.bout.r!.membership.id}' : 'bout.red_id IS NULL'}
        AND ${hasBlue ? 'ps_blue.membership_id = ${tmb.bout.b!.membership.id}' : 'bout.blue_id IS NULL'};
        ''');
      if (res.isEmpty) {
        // Create ParticipantState to be stored in the team match bout
        Bout bout = tmb.bout;
        if (bout.r != null) {
          bout = bout.copyWith(r: bout.r!.copyWithId(await AthleteBoutStateController().createSingle(bout.r!)));
        }
        if (bout.b != null) {
          bout = bout.copyWith(b: bout.b!.copyWithId(await AthleteBoutStateController().createSingle(bout.b!)));
        }
        bout = bout.copyWithId(await BoutController().createSingle(bout));
        tmb = await TeamMatchBoutController().createSingleReturn(tmb.copyWith(bout: bout));
        tmBouts[entry.key] = tmb;
      } else {
        tmb = tmb.copyWithId(res.first['id']);
        tmBouts[entry.key] = await TeamMatchBout.fromRaw(
            res.first, <T extends DataObject>(id) => EntityController.getSingleFromDataType<T>(id, obfuscate: false));
        final conn = PostgresDb().connection;
        await conn.execute('UPDATE team_match_bout SET pos = ${tmb.pos} WHERE id = ${tmb.id};');
      }
    });
    if (isReset) {
      await Future.forEach(oldTmBouts, (TeamMatchBout tmBout) async {
        if (tmBout.id != null) {
          await TeamMatchBoutController().deleteSingle(tmBout.id!);
          await BoutController().deleteSingle(tmBout.bout.id!);
        }
      });
    } else {
      // Get old bouts, which aren't reused anymore and delete them.
      final unusedBouts = oldTmBouts.where((oldBout) => tmBouts.every((newBout) => newBout.id != oldBout.id));
      await Future.forEach(unusedBouts, (TeamMatchBout tmb) async {
        if (tmb.id != null) {
          await TeamMatchBoutController().deleteSingle(tmb.id!);
          await BoutController().deleteSingle(tmb.bout.id!);
        }
      });
    }

    // TODO: handle obfuscate.
    broadcast((obfuscate) async => jsonEncode(
        manyToJson(tmBouts, Bout, CRUD.update, isRaw: false, filterType: TeamMatch, filterId: teamMatch.id)));

    return Response.ok('{"status": "success"}');
  }

  Future<List<TeamMatch>> getByReferee(User? user, int id) async {
    return await getMany(
      conditions: ['referee_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<List<TeamMatch>> getByTranscriptWriter(User? user, int id) async {
    return await getMany(
      conditions: ['transcript_writer_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<List<TeamMatch>> getByTimeKeeper(User? user, int id) async {
    return await getMany(
      conditions: ['time_keeper_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<List<TeamMatch>> getByMatChairman(User? user, int id) async {
    return await getMany(
      conditions: ['mat_chairman_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<List<TeamMatch>> getByJudge(User? user, int id) async {
    return await getMany(
      conditions: ['judge_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'comment': psql.Type.text};
  }

  @override
  Future<void> import({
    required WrestlingApi apiProvider,
    required TeamMatch entity,
    bool obfuscate = true,
    bool includeSubjacent = false,
  }) async {
    final tmbMap = await apiProvider.importTeamMatchBouts(teamMatch: entity);
    List<TeamMatchBout> teamMatchBouts = tmbMap.keys.toList();

    teamMatchBouts = await TeamMatchBoutController().updateOrCreateManyOfOrg(
      teamMatchBouts,
      obfuscate: obfuscate,
      conditions: ['team_match_id = @id'],
      substitutionValues: {'id': entity.id},
      onUpdateOrCreate: (previous, current) async {
        var bout = current.bout;
        final actions = tmbMap[current]!;

        bout = await BoutController().updateOrCreateSingleOfOrg(
          bout,
          obfuscate: obfuscate,
          onUpdateOrCreate: (previousBout) async {
            return bout.copyWith(
              r: await _saveDeepParticipantState(
                bout.r,
                previousAthleteBoutState: previousBout?.r,
                lineup: entity.home,
                weightClass: current.weightClass!,
                obfuscate: obfuscate,
              ),
              b: await _saveDeepParticipantState(
                bout.b,
                previousAthleteBoutState: previousBout?.b,
                lineup: entity.guest,
                weightClass: current.weightClass!,
                obfuscate: obfuscate,
              ),
            );
          },
        );

        // Add missing id to bout of boutActions
        final Iterable<BoutAction> boutActions = actions.map((action) => action.copyWith(bout: bout));
        final prevBoutActions = await BoutActionController()
            .getMany(conditions: ['bout_id = @id'], substitutionValues: {'id': bout.id}, obfuscate: obfuscate);
        await BoutActionController().updateOnDiffMany(boutActions.toList(), previous: prevBoutActions);
        return current.copyWith(bout: bout);
      },
      onDelete: (previous) async {
        await BoutActionController()
            .deleteMany(conditions: ['bout_id=@id'], substitutionValues: {'id': previous.bout.id});

        if (previous.bout.r != null) {
          await AthleteBoutStateController().deleteSingle(previous.bout.r!.id!);
        }
        if (previous.bout.b != null) {
          await AthleteBoutStateController().deleteSingle(previous.bout.b!.id!);
        }

        await BoutController().deleteSingle(previous.bout.id!);
      },
    );

    await _updateLineupParticipations(
        entity.home, Map.fromEntries(teamMatchBouts.map((tmb) => MapEntry(tmb.weightClass!, tmb.bout.r))));
    await _updateLineupParticipations(
        entity.guest, Map.fromEntries(teamMatchBouts.map((tmb) => MapEntry(tmb.weightClass!, tmb.bout.b))));

    updateLastImportUtcDateTime(entity.id!);
    if (includeSubjacent) {
      // Nothing to do
    }
  }

  Future<void> _updateLineupParticipations(
      TeamLineup lineup, Map<WeightClass, AthleteBoutState?> participantsMap) async {
    final prevParticipations = await TeamLineupParticipationController().getByLineup(null, lineup.id!);

    await TeamLineupParticipationController().updateOnDiffMany(
        participantsMap.entries
            .map((entry) {
              final weightClass = entry.key;
              final athleteBoutState = entry.value;
              if (athleteBoutState == null) return null;
              return TeamLineupParticipation(
                lineup: lineup,
                membership: athleteBoutState.membership,
                weight: null, // TODO: Weight not available in import (yet)
                weightClass: weightClass,
              );
            })
            .nonNulls
            .toList(),
        previous: prevParticipations);
  }

  Future<AthleteBoutState?> _saveDeepParticipantState(
    AthleteBoutState? athleteBoutState, {
    AthleteBoutState? previousAthleteBoutState,
    required TeamLineup lineup,
    required WeightClass weightClass,
    required bool obfuscate,
  }) async {
    if (athleteBoutState != null) {
      final person =
          await PersonController().updateOrCreateSingleOfOrg(athleteBoutState.membership.person, obfuscate: obfuscate);

      final membership = await MembershipController()
          .updateOrCreateSingleOfOrg(athleteBoutState.membership.copyWith(person: person), obfuscate: obfuscate);

      athleteBoutState = await AthleteBoutStateController()
          .updateOnDiffSingle(athleteBoutState.copyWith(membership: membership), previous: previousAthleteBoutState);

      return athleteBoutState;
    }
    return null;
  }

  @override
  Organization? getOrganization(TeamMatch entity) {
    return entity.organization;
  }
}
