import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_action_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_team_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/membership_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/participant_state_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/person_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

import 'bout_controller.dart';

class LeagueController extends OrganizationalController<League> {
  static final LeagueController _singleton = LeagueController._internal();

  factory LeagueController() {
    return _singleton;
  }

  LeagueController._internal() : super(tableName: 'league');

  Future<Response> requestTeams(Request request, User? user, String id) async {
    return TeamController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['league_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<Response> requestLeagueTeamParticipations(Request request, User? user, String id) async {
    return LeagueTeamParticipationController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['league_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<Response> requestTeamMatchs(Request request, User? user, String id) async {
    return TeamMatchController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['league_id = @id'],
      substitutionValues: {'id': id},
      orderBy: ['date'],
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<Response> import(Request request, User? user, String leagueId) async {
    try {
      final bool obfuscate = user?.obfuscate ?? true;
      final league = await LeagueController().getSingle(int.parse(leagueId), obfuscate: false);

      final organizationId = league.organization?.id;
      if (organizationId == null) {
        throw Exception('No organization found for league $leagueId.');
      }

      final apiProvider = await OrganizationController().initApiProvider(request, organizationId);
      if (apiProvider == null) {
        throw Exception('No API provider selected for the organization $organizationId.');
      }
      // apiProvider.isMock = true;

      final teamMatchs = await apiProvider.importTeamMatches(league: league);

      await Future.forEach(teamMatchs, (teamMatch) async {
        teamMatch = teamMatch.copyWith(
          // TODO: Don't create lineup or delete old one, if match already exists.
          home: await LineupController().createSingleReturn(teamMatch.home),
          guest: await LineupController().createSingleReturn(teamMatch.guest),
          referee: teamMatch.referee == null
              ? null
              : await PersonController().getOrCreateSingleOfOrg(teamMatch.referee!, obfuscate: obfuscate),
          judge: teamMatch.judge == null
              ? null
              : await PersonController().getOrCreateSingleOfOrg(teamMatch.judge!, obfuscate: obfuscate),
          matChairman: teamMatch.matChairman == null
              ? null
              : await PersonController().getOrCreateSingleOfOrg(teamMatch.matChairman!, obfuscate: obfuscate),
          transcriptWriter: teamMatch.transcriptWriter == null
              ? null
              : await PersonController().getOrCreateSingleOfOrg(teamMatch.transcriptWriter!, obfuscate: obfuscate),
          timeKeeper: teamMatch.timeKeeper == null
              ? null
              : await PersonController().getOrCreateSingleOfOrg(teamMatch.timeKeeper!, obfuscate: obfuscate),
        );
        teamMatch = await TeamMatchController().getOrCreateSingleOfOrg(teamMatch, obfuscate: obfuscate);

        // TODO: may do this in a separate import call for the participating teams:
        try {
          await LeagueTeamParticipationController()
              .createSingle(LeagueTeamParticipation(league: league, team: teamMatch.home.team));
          await LeagueTeamParticipationController()
              .createSingle(LeagueTeamParticipation(league: league, team: teamMatch.guest.team));
        } on InvalidParameterException catch (_) {
          // Do not add teams multiple times.
        }

        final boutMap = await apiProvider.importBouts(event: teamMatch);
        final bouts = await Future.wait(boutMap.entries.map((boutEntry) async {
          var bout = boutEntry.key;

          Future<ParticipantState?> saveDeepParticipantState(ParticipantState? participantState) async {
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

          bout = await BoutController().createSingleReturn(bout.copyWith(
            r: await saveDeepParticipantState(bout.r),
            b: await saveDeepParticipantState(bout.b),
          ));

          // Add missing id to bout of boutActions
          final Iterable<BoutAction> boutActions = boutEntry.value.map((action) => action.copyWith(bout: bout));
          await BoutActionController().createMany(boutActions.toList());
          return bout;
        }));

        await Future.wait(bouts.asMap().entries.map((boutEntry) async {
          final index = boutEntry.key;
          final bout = boutEntry.value;
          await TeamMatchBoutController()
              .createSingleReturn(TeamMatchBout(pos: index, teamMatch: teamMatch, bout: bout));
        }));
      });

      return Response.ok('{"status": "success"}');
    } catch (err, stackTrace) {
      return Response.internalServerError(body: '{"err": "$err", "stackTrace": "$stackTrace"}');
    }
  }

  @override
  Set<String> getSearchableAttributes() => {'name'};
}
