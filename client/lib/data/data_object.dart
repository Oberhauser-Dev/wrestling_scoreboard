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

T toClientObject<T extends DataObject>(T dataObject) {
  if (dataObject is Club) {
    if(dataObject is ClientClub) return dataObject;
    return ClientClub.from(dataObject) as T;
  } else if (dataObject is Fight) {
    if(dataObject is ClientFight) return dataObject;
    return ClientFight.from(dataObject) as T;
  } else if (dataObject is League) {
    if(dataObject is ClientLeague) return dataObject;
    return ClientLeague.from(dataObject) as T;
  } else if (dataObject is Lineup) {
    if(dataObject is ClientLineup) return dataObject;
    return ClientLineup.from(dataObject) as T;
  } else if (dataObject is Membership) {
    if(dataObject is ClientMembership) return dataObject;
    return ClientMembership.from(dataObject) as T;
  } else if (dataObject is Participation) {
    return dataObject;
  } else if (dataObject is Team) {
    if(dataObject is ClientTeam) return dataObject;
    return ClientTeam.from(dataObject) as T;
  } else if (dataObject is TeamMatch) {
    if(dataObject is ClientTeamMatch) return dataObject;
    return ClientTeamMatch.from(dataObject) as T;
  }
  throw UnimplementedError('Cannot deserialize ${T.toString()}');
}
