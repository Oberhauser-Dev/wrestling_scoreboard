import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_team_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/person_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

class LeagueController extends OrganizationalController<League> with ImportController<League> {
  static final LeagueController _singleton = LeagueController._internal();

  factory LeagueController() {
    return _singleton;
  }

  LeagueController._internal() : super();

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

  static String _weightClassesQuery(bool filterBySeasonPartition) => '''
        SELECT wc.* 
        FROM weight_class as wc
        JOIN league_weight_class AS dwc ON dwc.weight_class_id = wc.id
        WHERE dwc.league_id = @id ${filterBySeasonPartition ? 'AND dwc.season_partition = @season_partition' : ''}
        ORDER BY dwc.pos;''';

  Future<Response> requestWeightClasses(Request request, User? user, String id) async {
    return WeightClassController().handleRequestManyFromQuery(
      isRaw: request.isRaw,
      sqlQuery: _weightClassesQuery(false),
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<List<WeightClass>> getWeightClasses(String id, {int? seasonPartition, required bool obfuscate}) {
    return WeightClassController().getManyFromQuery(_weightClassesQuery(seasonPartition != null),
        substitutionValues: {
          'id': id,
          if (seasonPartition != null) 'season_partition': seasonPartition,
        },
        obfuscate: obfuscate);
  }

  Future<Response> requestLeagueWeightClasses(Request request, User? user, String id) async {
    return LeagueWeightClassController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['league_id = @id'],
      substitutionValues: {'id': id},
      orderBy: ['season_partition', 'pos'],
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<List<LeagueWeightClass>> getLeagueWeightClasses(
    String id, {
    int? seasonPartition,
    required bool obfuscate,
  }) {
    return LeagueWeightClassController().getMany(
      conditions: ['league_id = @id', if (seasonPartition != null) 'season_partition = @season_partition'],
      substitutionValues: {'id': id, if (seasonPartition != null) 'season_partition': seasonPartition},
      orderBy: ['season_partition', 'pos'],
      obfuscate: obfuscate,
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

    teamMatchs = await TeamMatchController().updateOrCreateManyOfOrg(
      teamMatchs.toList(),
      conditions: ['league_id = @id'],
      substitutionValues: {'id': entity.id},
      onUpdateOrCreate: (prevTeamMatch, teamMatch) async {
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
      onDelete: (previous) async {
        await LineupController().deleteSingle(previous.home.id!);
        await LineupController().deleteSingle(previous.guest.id!);
        // Do not delete persons
      },
      obfuscate: obfuscate,
    );

    await forEachFuture(teamMatchs, (teamMatch) async {
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
