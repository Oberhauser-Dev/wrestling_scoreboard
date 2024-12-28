import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/membership_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

final _logger = Logger('PersonController');

class PersonController extends OrganizationalController<Person> {
  static final PersonController _singleton = PersonController._internal();

  factory PersonController() {
    return _singleton;
  }

  PersonController._internal() : super(tableName: 'person');

  @override
  Map<String, dynamic> obfuscate(Map<String, dynamic> raw) {
    final id = raw['id'];
    raw['prename'] = 'Pre: $id';
    raw['surname'] = 'Sur: $id';
    raw['birth_date'] = null;
    raw['nationality'] = null;
    raw['gender'] = null;
    return raw;
  }

  Future<Response> postMerge(Request request, User? user) async {
    final message = await request.readAsString();
    try {
      final many = parseManyJson<Person>(jsonDecode(message)).data;
      if (many.length < 2) throw Exception('Cannot merge less than 2 elements');
      var keepPerson = many.first;
      final deletePersons = many.sublist(1);

      final keptMemberships = await getMemberships(user, keepPerson.id!);

      for (final deletePerson in deletePersons) {
        final memberships = await getMemberships(user, deletePerson.id!);
        for (final membership in memberships) {
          final keptMembership = keptMemberships.where(
              (m) => m.club == membership.club && m.no == membership.no && m.organization == membership.organization);
          if (keptMembership.isNotEmpty) {
            // Update deleted memberships
            final lnc = LineupController();
            final lineupsByLeader = await lnc.getByLeader(user, membership.id!);
            await Future.wait(lineupsByLeader.map((e) => lnc.updateSingle(e.copyWith(leader: keptMembership.first))));

            final lineupsByCoach = await lnc.getByCoach(user, membership.id!);
            await Future.wait(lineupsByCoach.map((e) => lnc.updateSingle(e.copyWith(coach: keptMembership.first))));

            final participations = await ParticipationController().getByMembership(user, membership.id!);
            await Future.wait(participations
                .map((e) => ParticipationController().updateSingle(e.copyWith(membership: keptMembership.first))));

            final wasDeleted = await deleteSingle(membership.id!);
            if (!wasDeleted) return Response.badRequest(body: 'Membership ${membership.id} could not be deleted');
          } else {
            // Keep if membership doesn't exist yet
            await MembershipController().updateSingle(membership.copyWith(person: keepPerson));
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

  Future<Response> requestMemberships(Request request, User? user, String id) async {
    return MembershipController().handleRequestMany(
      isRaw: request.isRaw,
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
