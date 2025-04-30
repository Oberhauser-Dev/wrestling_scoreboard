import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_bout_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

class MembershipController extends OrganizationalController<Membership> {
  static final MembershipController _singleton = MembershipController._internal();

  factory MembershipController() {
    return _singleton;
  }

  MembershipController._internal() : super();

  static const _teamMatchBoutsQuery = '''
        SELECT tmb.* 
        FROM bout as b
        JOIN participant_state AS pst ON b.red_id = pst.id OR b.blue_id = pst.id
        JOIN participation AS p ON pst.participation_id = p.id
        JOIN team_match_bout AS tmb ON tmb.bout_id = b.id
        JOIN team_match AS tm ON tmb.team_match_id = tm.id
        WHERE p.membership_id = @id
        ORDER BY tm.date DESC, tmb.pos;''';

  Future<Response> requestTeamMatchBouts(Request request, User? user, String id) async {
    final bool obfuscate = user?.obfuscate ?? true;

    return TeamMatchBoutController().handleRequestManyFromQuery(
      isRaw: request.isRaw,
      sqlQuery: _teamMatchBoutsQuery,
      substitutionValues: {'id': id},
      obfuscate: obfuscate,
    );
  }

  Future<Response> requestParticipations(Request request, User? user, String id) async {
    return TeamLineupParticipationController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['membership_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  @override
  Map<String, dynamic> obfuscate(Map<String, dynamic> raw) {
    raw['no'] = null;
    raw['org_sync_id'] = null;
    return raw;
  }
}
