import 'data/club.dart';
import 'data/fight.dart';
import 'data/fight_action.dart';
import 'data/league.dart';
import 'data/lineup.dart';
import 'data/membership.dart';
import 'data/participant_state.dart';
import 'data/participation.dart';
import 'data/team.dart';
import 'data/team_match/team_match.dart';
import 'data/tournament/tournament.dart';

export 'data/club.dart';
export 'data/data_object.dart';
export 'data/fight.dart';
export 'data/fight_action.dart';
export 'data/league.dart';
export 'data/lineup.dart';
export 'data/membership.dart';
export 'data/participant_state.dart';
export 'data/participation.dart';
export 'data/person.dart';
export 'data/team.dart';
export 'data/team_match/team_match.dart';
export 'data/team_match/team_match_fight.dart';
export 'data/team_match/league_weight_class.dart';
export 'data/tournament/tournament.dart';
export 'data/tournament/tournament_fight.dart';
export 'data/weight_class.dart';
export 'data/wrestling_event.dart';

const List<Type> dataObjectTypes = [
  Club,
  Fight,
  FightAction,
  League,
  Lineup,
  Membership,
  Participation,
  ParticipantState,
  Team,
  TeamMatch,
];

String getTableNameFromType(Type t) {
  switch (t) {
    case Club:
      return 'club';
    case Fight:
      return 'fight';
    case FightAction:
      return 'fight_action';
    case League:
      return 'league';
    case Lineup:
      return 'lineup';
    case Membership:
      return 'membership';
    case Participation:
      return 'participation';
    case ParticipantState:
      return 'participant_state';
    case Team:
      return 'team';
    case TeamMatch:
      return 'team_match';
    case Tournament:
      return 'tournament';
    case Object:
      return 'object';
    default:
      throw UnimplementedError('ClassName for "${t.toString()}" not found.');
  }
}

Type getTypeFromTableName(String tableName) {
  switch (tableName) {
    case 'club':
      return Club;
    case 'fight':
      return Fight;
    case 'fight_action':
      return FightAction;
    case 'league':
      return League;
    case 'lineup':
      return Lineup;
    case 'membership':
      return Membership;
    case 'participation':
      return Participation;
    case 'participant_state':
      return ParticipantState;
    case 'team':
      return Team;
    case 'team_match':
      return TeamMatch;
    case 'tournament':
      return Tournament;
    case 'object':
      return Object;
    default:
      throw UnimplementedError('Type for "${tableName.toString()}" not found.');
  }
}
