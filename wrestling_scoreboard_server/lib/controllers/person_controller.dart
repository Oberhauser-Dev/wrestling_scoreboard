import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/membership_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_lineup_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/websocket_handler.dart';

final _logger = Logger('PersonController');

class PersonController extends OrganizationalController<Person> {
  static final PersonController _singleton = PersonController._internal();

  factory PersonController() {
    return _singleton;
  }

  PersonController._internal() : super();

  @override
  Map<String, dynamic> obfuscate(Map<String, dynamic> raw) {
    final id = raw['id'];
    raw['prename'] = 'Pre: $id';
    raw['surname'] = 'Sur: $id';
    raw['birth_date'] = null;
    raw['nationality'] = null;
    raw['gender'] = null;
    raw['org_sync_id'] = null;
    return raw;
  }

  Future<Response> postMerge(Request request, User? user) async {
    final message = await request.readAsString();
    try {
      final many = parseManyJson<Person>(jsonDecode(message)).data;
      if (many.length < 2) throw Exception('Cannot merge less than 2 elements');
      var keepPerson = many.first;
      final deletePersons = many.sublist(1);

      final keepMemberships = await getMemberships(user, keepPerson.id!);

      for (final deletePerson in deletePersons) {
        final deleteMemberships = await getMemberships(user, deletePerson.id!);
        for (final deleteMembership in deleteMemberships) {
          final replacingMembership = keepMemberships
              .where((m) => m.club == deleteMembership.club && m.organization == deleteMembership.organization)
              .firstOrNull;
          if (replacingMembership != null) {
            if (replacingMembership.no != null &&
                deleteMembership.no != null &&
                replacingMembership.no != deleteMembership.no) {
              _logger.warning(
                  'Replacing Membership ${deleteMembership.id} (${deleteMembership.no}) with ${replacingMembership.id} (${replacingMembership.no}) lead to a different club number.');
            }

            // Update deleted memberships
            final lnc = TeamLineupController();
            final lineupsByLeader = await lnc.getByLeader(user, deleteMembership.id!);
            await Future.wait(lineupsByLeader.map((e) => lnc.updateSingle(e.copyWith(leader: replacingMembership))));

            final lineupsByCoach = await lnc.getByCoach(user, deleteMembership.id!);
            await Future.wait(lineupsByCoach.map((e) => lnc.updateSingle(e.copyWith(coach: replacingMembership))));

            final participations =
                await TeamLineupParticipationController().getByMembership(user, deleteMembership.id!);
            await Future.wait(participations.map(
                (e) => TeamLineupParticipationController().updateSingle(e.copyWith(membership: replacingMembership))));

            final wasDeleted = await MembershipController().deleteSingle(deleteMembership.id!);
            if (!wasDeleted) return Response.badRequest(body: 'Membership ${deleteMembership.id} could not be deleted');
          } else {
            // Keep if membership doesn't exist yet
            await MembershipController().updateSingle(deleteMembership.copyWith(person: keepPerson));
          }
        }
        // TODO: Referenced by CompetitionPerson
        // TODO: Referenced by SecuredUser

        final tmc = TeamMatchController();
        final teamMatchsByReferee = await tmc.getByReferee(user, deletePerson.id!);
        final teamMatchsByTranscriptWriter = await tmc.getByTranscriptWriter(user, deletePerson.id!);
        final teamMatchsByTimeKeeper = await tmc.getByTimeKeeper(user, deletePerson.id!);
        final teamMatchsByMatChairman = await tmc.getByMatChairman(user, deletePerson.id!);
        final teamMatchsByJudge = await tmc.getByJudge(user, deletePerson.id!);

        await Future.wait(teamMatchsByReferee.map((e) => tmc.updateSingle(e.copyWith(referee: keepPerson))));
        await Future.wait(
            teamMatchsByTranscriptWriter.map((e) => tmc.updateSingle(e.copyWith(transcriptWriter: keepPerson))));
        await Future.wait(teamMatchsByTimeKeeper.map((e) => tmc.updateSingle(e.copyWith(timeKeeper: keepPerson))));
        await Future.wait(teamMatchsByMatChairman.map((e) => tmc.updateSingle(e.copyWith(matChairman: keepPerson))));
        await Future.wait(teamMatchsByJudge.map((e) => tmc.updateSingle(e.copyWith(judge: keepPerson))));

        // Override delete person, with all attributes of keep person. So when keepPerson is missing an attribute, it falls back to deletePerson.
        keepPerson = deletePerson.copyWith(
          id: keepPerson.id,
          birthDate: keepPerson.birthDate,
          gender: keepPerson.gender,
          nationality: keepPerson.nationality,
          organization: keepPerson.organization,
          orgSyncId: keepPerson.orgSyncId,
          prename: keepPerson.prename,
          surname: keepPerson.surname,
        );
        final wasDeleted = await deleteSingle(deletePerson.id!);
        if (!wasDeleted) return Response.badRequest(body: 'Person ${deletePerson.id} could not be deleted');
      }

      await updateSingle(keepPerson);

      // Update list of persons for its organization
      broadcast((obfuscate) async => jsonEncode(manyToJson(
          await OrganizationController().getPersons(user, keepPerson.organization!.id!), Person, CRUD.update,
          isRaw: false, filterType: Organization, filterId: keepPerson.organization!.id)));

      return Response.ok('{"status": "success"}');
    } on FormatException catch (e) {
      final errMessage = 'The data objects $tableName could not be merged. Check the format: $message'
          '\nFormatException: ${e.message}';
      _logger.warning(errMessage.toString());
      return Response.notFound(errMessage);
    }
  }

  Future<List<Membership>> getMemberships(User? user, int id) async {
    return await MembershipController().getMany(
      conditions: ['person_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      'gender': null,
    };
  }
}
