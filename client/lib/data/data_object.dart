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
    case DataObject:
      throw 'Base type not found';
    default:
      return type;
  }
}

S toClientObject<T extends DataObject, S extends T>(T dataObject) {
  if (dataObject is Club) {
    if (dataObject is ClientClub) return dataObject as S;
    return ClientClub.from(dataObject) as S;
  } else if (dataObject is Fight) {
    if (dataObject is ClientFight) return dataObject as S;
    return ClientFight.from(dataObject) as S;
  } else if (dataObject is FightAction) {
    return dataObject as S;
  } else if (dataObject is League) {
    if (dataObject is ClientLeague) return dataObject as S;
    return ClientLeague.from(dataObject) as S;
  } else if (dataObject is Lineup) {
    if (dataObject is ClientLineup) return dataObject as S;
    return ClientLineup.from(dataObject) as S;
  } else if (dataObject is Membership) {
    if (dataObject is ClientMembership) return dataObject as S;
    return ClientMembership.from(dataObject) as S;
  } else if (dataObject is Participation) {
    return dataObject as S;
  } else if (dataObject is Team) {
    if (dataObject is ClientTeam) return dataObject as S;
    return ClientTeam.from(dataObject) as S;
  } else if (dataObject is TeamMatch) {
    if (dataObject is ClientTeamMatch) return dataObject as S;
    return ClientTeamMatch.from(dataObject) as S;
  }
  throw UnimplementedError('Cannot deserialize ${T.toString()}');
}
