import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_person_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/membership_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_lineup_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_person_controller.dart';

final _logger = Logger('PersonController');

class PersonController extends ShelfController<Person> with OrganizationalController<Person> {
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
    raw['image_uri'] = null;
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
          final replacingMembership =
              keepMemberships
                  .where((m) => m.club == deleteMembership.club && m.organization == deleteMembership.organization)
                  .firstOrNull;
          if (replacingMembership != null) {
            if (replacingMembership.no != null &&
                deleteMembership.no != null &&
                replacingMembership.no != deleteMembership.no) {
              _logger.warning(
                'Replacing Membership ${deleteMembership.id} (${deleteMembership.no}) with ${replacingMembership.id} (${replacingMembership.no}) lead to a different club number.',
              );
            }

            // Update deleted memberships
            final lnc = TeamLineupController();
            final lineupsByLeader = await lnc.getByLeader(user, deleteMembership.id!);
            await Future.wait(lineupsByLeader.map((e) => lnc.updateSingle(e.copyWith(leader: replacingMembership))));

            final lineupsByCoach = await lnc.getByCoach(user, deleteMembership.id!);
            await Future.wait(lineupsByCoach.map((e) => lnc.updateSingle(e.copyWith(coach: replacingMembership))));

            final participations = await TeamLineupParticipationController().getByMembership(
              user,
              deleteMembership.id!,
            );
            await Future.wait(
              participations.map(
                (e) => TeamLineupParticipationController().updateSingle(e.copyWith(membership: replacingMembership)),
              ),
            );

            final wasDeleted = await MembershipController().deleteSingle(deleteMembership.id!);
            if (!wasDeleted) return Response.badRequest(body: 'Membership ${deleteMembership.id} could not be deleted');
          } else {
            // Keep if membership doesn't exist yet
            await MembershipController().updateSingle(deleteMembership.copyWith(person: keepPerson));
          }
        }
        // TODO: Referenced by SecuredUser: Probably only should be allowed for admins.

        final tmpc = TeamMatchPersonController();
        final teamMatchPersonsByPerson = await tmpc.getByPerson(user, deletePerson.id!);
        await Future.wait(teamMatchPersonsByPerson.map((e) => tmpc.updateSingle(e.copyWith(person: keepPerson))));

        final cpc = CompetitionPersonController();
        final competitionPersonsByPerson = await cpc.getByPerson(user, deletePerson.id!);
        await Future.wait(competitionPersonsByPerson.map((e) => cpc.updateSingle(e.copyWith(person: keepPerson))));

        // Override keepPerson. It falls back to deletePerson, if an attribute is missing.
        keepPerson = keepPerson.copyWith(
          id: keepPerson.id ?? deletePerson.id,
          birthDate: keepPerson.birthDate ?? deletePerson.birthDate,
          gender: keepPerson.gender ?? deletePerson.gender,
          nationality: keepPerson.nationality ?? deletePerson.nationality,
          organization: keepPerson.organization ?? deletePerson.organization,
          orgSyncId: keepPerson.orgSyncId ?? deletePerson.orgSyncId,
          prename: keepPerson.prename,
          surname: keepPerson.surname,
        );
        final wasDeleted = await deleteSingle(deletePerson.id!);
        if (!wasDeleted) return Response.badRequest(body: 'Person ${deletePerson.id} could not be deleted');
      }

      await updateSingle(keepPerson);

      // Update list of persons for its organization
      broadcastUpdateMany<Person>(
        (obfuscate) async =>
            await OrganizationController().getPersons(user?.obfuscate ?? true, keepPerson.organization!.id!),
        filterType: Organization,
        filterId: keepPerson.organization!.id,
      );

      // Broadcast the updated information
      broadcastUpdateSingle<Person>((obfuscate) async => keepPerson);

      return Response.ok('{"status": "success"}');
    } on FormatException catch (e) {
      final errMessage =
          'The data objects $tableName could not be merged. Check the format: $message'
          '\nFormatException: ${e.message}';
      _logger.warning(errMessage.toString());
      return Response.badRequest(body: errMessage);
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
    return {'gender': null};
  }
}
