/// Library for common functionality in client and server wrestling applications.
@TypeLookup(dataTypes)
library wrestling_scoreboard_common;

import 'package:wrestling_scoreboard_macros/macros.dart';

import 'common.dart';

export 'src/data.dart';
export 'src/enums.dart';
export 'src/services.dart';
export 'src/util.dart';

const dataTypes = [
  BoutAction,
  ParticipantState,
  TeamMatchBout,
  Bout,
  Participation,
  TeamMatch,
  Competition,
  Lineup,
  LeagueTeamParticipation,
  League,
  BoutConfig,
  Membership,
  Person,
  Team,
  Club,
  DivisionWeightClass,
  Division,
  WeightClass,
  Organization,
];
