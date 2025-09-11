import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/import_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_team_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/person_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_person_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

class LeagueController extends ShelfController<League> with OrganizationalController<League>, ImportController<League> {
  static final LeagueController _singleton = LeagueController._internal();

  factory LeagueController() {
    return _singleton;
  }

  LeagueController._internal() : super();

  static String _weightClassesQuery(bool filterBySeasonPartition) => '''
        SELECT wc.* 
        FROM ${WeightClass.cTableName} as wc
        JOIN ${LeagueWeightClass.cTableName} AS dwc ON dwc.weight_class_id = wc.id
        WHERE dwc.league_id = @id ${filterBySeasonPartition ? 'AND dwc.season_partition = @season_partition' : ''}
        ORDER BY dwc.pos;''';

  Future<Response> requestWeightClasses(Request request, User? user, String id) async {
    return WeightClassController().handleGetRequestManyFromQuery(
      isRaw: request.isRaw,
      sqlQuery: _weightClassesQuery(false),
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<List<WeightClass>> getWeightClasses(String id, {int? seasonPartition, required bool obfuscate}) {
    return WeightClassController().getManyFromQuery(
      _weightClassesQuery(seasonPartition != null),
      substitutionValues: {'id': id, if (seasonPartition != null) 'season_partition': seasonPartition},
      obfuscate: obfuscate,
    );
  }

  Future<List<LeagueWeightClass>> getLeagueWeightClasses(String id, {int? seasonPartition, required bool obfuscate}) {
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
    final teamMatchMap = await apiProvider.importTeamMatches(league: entity);

    final teamMatchs = await TeamMatchController().updateOrCreateManyOfOrg(
      teamMatchMap.keys.toList(),
      conditions: ['league_id = @id'],
      substitutionValues: {'id': entity.id},
      onUpdatedOrCreated: (previous, teamMatch) async {
        final officials = teamMatchMap.entries.where((tmm) => tmm.key.orgSyncId == teamMatch.orgSyncId).single.value;
        final prevOfficials = await TeamMatchPersonController().getMany(
          conditions: ['team_match_id = @id'],
          substitutionValues: {'id': teamMatch.id},
          obfuscate: obfuscate,
        );
        final updatedOfficials = await forEachFuture(
          officials.entries,
          (official) async => MapEntry(
            await PersonController().updateOrCreateSingleOfOrg(official.key, obfuscate: obfuscate),
            official.value,
          ),
        );

        await TeamMatchPersonController().updateOnDiffMany(
          updatedOfficials
              .map((official) => TeamMatchPerson(teamMatch: teamMatch, person: official.key, role: official.value))
              .toList(),
          previous: prevOfficials,
        );
      },
      onUpdateOrCreate: (prevTeamMatch, teamMatch) async {
        return teamMatch.copyWith(
          home: await TeamLineupController().updateOnDiffSingle(teamMatch.home, previous: prevTeamMatch?.home),
          guest: await TeamLineupController().updateOnDiffSingle(teamMatch.guest, previous: prevTeamMatch?.guest),
        );
      },
      onDelete: (previous) async {
        // Delete link to task of official person.
        // Do not delete persons themselves
        await TeamMatchPersonController().deleteMany(
          conditions: ['team_match_id=@id'],
          substitutionValues: {'id': previous.id},
        );
      },
      onDeleted: (previous) async {
        await TeamLineupController().deleteSingle(previous.home.id!);
        await TeamLineupController().deleteSingle(previous.guest.id!);
      },
      obfuscate: obfuscate,
    );

    await forEachFuture(teamMatchs, (teamMatch) async {
      // Do not add teams to a league multiple times.
      final previousHomeTeamParticipation = await LeagueTeamParticipationController().getByLeagueAndTeamId(
        teamId: teamMatch.home.team.id!,
        leagueId: entity.id!,
        obfuscate: obfuscate,
      );
      if (previousHomeTeamParticipation == null) {
        await LeagueTeamParticipationController().createSingle(
          LeagueTeamParticipation(league: entity, team: teamMatch.home.team),
        );
      }
      final previousGuestTeamParticipation = await LeagueTeamParticipationController().getByLeagueAndTeamId(
        teamId: teamMatch.guest.team.id!,
        leagueId: entity.id!,
        obfuscate: obfuscate,
      );
      if (previousGuestTeamParticipation == null) {
        await LeagueTeamParticipationController().createSingle(
          LeagueTeamParticipation(league: entity, team: teamMatch.guest.team),
        );
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
