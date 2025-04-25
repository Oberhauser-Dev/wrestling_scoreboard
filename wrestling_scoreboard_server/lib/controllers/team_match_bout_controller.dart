import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';

class TeamMatchBoutController extends OrganizationalController<TeamMatchBout> {
  static final TeamMatchBoutController _singleton = TeamMatchBoutController._internal();

  factory TeamMatchBoutController() {
    return _singleton;
  }

  TeamMatchBoutController._internal() : super();
}
