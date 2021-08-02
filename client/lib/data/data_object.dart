import 'package:common/common.dart';

import 'club.dart';
import 'fight.dart';
import 'league.dart';
import 'lineup.dart';
import 'membership.dart';
import 'participant_state.dart';
import 'team.dart';
import 'team_match.dart';

Type getBaseType(Type type) {
  switch (type) {
    case ClientFight:
      return Fight;
    case ClientTeamMatch:
      return TeamMatch;
    case ClientTeam:
      return Team;
    case ClientClub:
      return Club;
    case ClientLeague:
      return League;
    case ClientLineup:
      return Lineup;
    case ClientMembership:
      return Membership;
    case ClientParticipantState:
      return ParticipantState;
    default:
      return type;
  }
}
