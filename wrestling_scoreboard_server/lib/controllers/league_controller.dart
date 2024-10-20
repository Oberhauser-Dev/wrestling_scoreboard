import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_team_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/person_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

class LeagueController extends OrganizationalController<League> with ImportController {
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

  @override
  Future<void> import(int entityId, {String? message, bool obfuscate = true, bool useMock = false}) async {
    final league = await LeagueController().getSingle(entityId, obfuscate: obfuscate);

    final organizationId = league.organization?.id;
    if (organizationId == null) {
      throw Exception('No organization found for league $entityId.');
    }

    final apiProvider = await OrganizationController().initApiProvider(message, organizationId);
    if (apiProvider == null) {
      throw Exception('No API provider selected for the organization $organizationId.');
    }
    apiProvider.isMock = useMock;

    final teamMatchs = await apiProvider.importTeamMatches(league: league);

    await Future.forEach(teamMatchs, (teamMatch) async {
      await TeamMatchController().updateOrCreateSingleOfOrg(
        teamMatch,
        obfuscate: obfuscate,
        onUpdateOrCreate: (prevTeamMatch) async {
          return teamMatch.copyWith(
            home: await LineupController().updateOnDiffSingle(teamMatch.home, previous: prevTeamMatch?.home),
            guest: await LineupController().updateOnDiffSingle(teamMatch.guest, previous: prevTeamMatch?.guest),
            referee: teamMatch.referee == null
                ? null
                : await PersonController().updateOrCreateSingleOfOrg(teamMatch.referee!, obfuscate: obfuscate),
            judge: teamMatch.judge == null
                ? null
                : await PersonController().updateOrCreateSingleOfOrg(teamMatch.judge!, obfuscate: obfuscate),
            matChairman: teamMatch.matChairman == null
                ? null
                : await PersonController().updateOrCreateSingleOfOrg(teamMatch.matChairman!, obfuscate: obfuscate),
            transcriptWriter: teamMatch.transcriptWriter == null
                ? null
                : await PersonController().updateOrCreateSingleOfOrg(teamMatch.transcriptWriter!, obfuscate: obfuscate),
            timeKeeper: teamMatch.timeKeeper == null
                ? null
                : await PersonController().updateOrCreateSingleOfOrg(teamMatch.timeKeeper!, obfuscate: obfuscate),
          );
        },
      );

      // Do not add teams to a league multiple times.
      final previousHomeTeamParticipation = await LeagueTeamParticipationController()
          .getByLeagueAndTeamId(teamId: teamMatch.home.team.id!, leagueId: league.id!, obfuscate: obfuscate);
      if (previousHomeTeamParticipation == null) {
        await LeagueTeamParticipationController()
            .createSingle(LeagueTeamParticipation(league: league, team: teamMatch.home.team));
      }
      final previousGuestTeamParticipation = await LeagueTeamParticipationController()
          .getByLeagueAndTeamId(teamId: teamMatch.guest.team.id!, leagueId: league.id!, obfuscate: obfuscate);
      if (previousGuestTeamParticipation == null) {
        await LeagueTeamParticipationController()
            .createSingle(LeagueTeamParticipation(league: league, team: teamMatch.guest.team));
      }
    });
  }
}
