import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_team_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/person_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

class LeagueController extends OrganizationalController<League> with ImportController<League> {
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
  Future<void> import({
    required WrestlingApi apiProvider,
    required League entity,
    bool obfuscate = true,
    bool includeSubjacent = false,
  }) async {
    var teamMatchs = await apiProvider.importTeamMatches(league: entity);

    teamMatchs = await forEachFuture(teamMatchs, (teamMatch) async {
      teamMatch = await TeamMatchController().updateOrCreateSingleOfOrg(
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
          .getByLeagueAndTeamId(teamId: teamMatch.home.team.id!, leagueId: entity.id!, obfuscate: obfuscate);
      if (previousHomeTeamParticipation == null) {
        await LeagueTeamParticipationController()
            .createSingle(LeagueTeamParticipation(league: entity, team: teamMatch.home.team));
      }
      final previousGuestTeamParticipation = await LeagueTeamParticipationController()
          .getByLeagueAndTeamId(teamId: teamMatch.guest.team.id!, leagueId: entity.id!, obfuscate: obfuscate);
      if (previousGuestTeamParticipation == null) {
        await LeagueTeamParticipationController()
            .createSingle(LeagueTeamParticipation(league: entity, team: teamMatch.guest.team));
      }
      return teamMatch;
    });

    updateLastImportUtcDateTime(entity.id!);
    if (includeSubjacent) {
      for (final teamMatch in teamMatchs) {
        await TeamMatchController().import(
          entity: teamMatch,
          apiProvider: apiProvider,
          obfuscate: obfuscate,
          includeSubjacent: includeSubjacent,
        );
      }
    }
  }

  @override
  Organization? getOrganization(League entity) {
    return entity.organization;
  }
}
