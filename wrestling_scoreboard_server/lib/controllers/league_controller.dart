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
  Future<Response> import(Request request, User? user, String entityId) async {
    try {
      final bool obfuscate = user?.obfuscate ?? true;
      final league = await LeagueController().getSingle(int.parse(entityId), obfuscate: false);

      final organizationId = league.organization?.id;
      if (organizationId == null) {
        throw Exception('No organization found for league $entityId.');
      }

      final apiProvider = await OrganizationController().initApiProvider(request, organizationId);
      if (apiProvider == null) {
        throw Exception('No API provider selected for the organization $organizationId.');
      }
      // apiProvider.isMock = true;

      final teamMatchs = await apiProvider.importTeamMatches(league: league);

      await Future.forEach(teamMatchs, (teamMatch) async {
        await TeamMatchController().getOrCreateSingleOfOrg(teamMatch, obfuscate: obfuscate, onCreate: () async {
          return teamMatch.copyWith(
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
        });

        try {
          await LeagueTeamParticipationController()
              .createSingle(LeagueTeamParticipation(league: league, team: teamMatch.home.team));
          await LeagueTeamParticipationController()
              .createSingle(LeagueTeamParticipation(league: league, team: teamMatch.guest.team));
        } on InvalidParameterException catch (_) {
          // Do not add teams multiple times.
        }
      });

      updateLastImportUtcDateTime(entityId);
      return Response.ok('{"status": "success"}');
    } on HttpException catch (err, stackTrace) {
      return Response.badRequest(body: '{"err": "$err", "stackTrace": "$stackTrace"}');
    } catch (err, stackTrace) {
      return Response.internalServerError(body: '{"err": "$err", "stackTrace": "$stackTrace"}');
    }
  }
}
