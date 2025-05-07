import 'package:wrestling_scoreboard_common/common.dart';

const Map<Type, Map<String, (Type, List<String>)>> directDataObjectRelations = {
  BoutResultRule: {'bout_config_id': (BoutConfig, [])},
  Membership: {'club_id': (Club, []), 'person_id': (Person, [])},
  BoutAction: {'bout_id': (Bout, [])},
  Organization: {'parent_id': (Organization, [])},
  Division: {'organization_id': (Organization, []), 'parent_id': (Division, [])},
  Club: {'organization_id': (Organization, [])},
  Person: {'organization_id': (Organization, [])},
  AgeCategory: {'organization_id': (Organization, [])},
  Competition: {'organization_id': (Organization, [])},
  League: {'division_id': (Division, [])},
  Team: {'league_id': (League, [])},
  LeagueTeamParticipation: {'league_id': (League, [])},
  TeamMatch: {
    'league_id': (League, ['date']),
  },
  TeamLineupParticipation: {'lineup_id': (TeamLineup, []), 'membership_id': (Membership, [])},
  CompetitionParticipation: {
    'competition_lineup_id': (CompetitionLineup, []),
    'membership_id': (Membership, []),
    'weight_category_id': (CompetitionWeightCategory, []),
  },
  TeamMatchBout: {
    'team_match_id': (TeamMatch, ['pos']),
  },
  CompetitionBout: {'competition_id': (Competition, []), 'weight_category_id': (CompetitionWeightCategory, [])},
  CompetitionLineup: {'competition_id': (Competition, [])},
  CompetitionWeightCategory: {'competition_id': (Competition, [])},
  CompetitionSystemAffiliation: {'competition_id': (Competition, [])},
  DivisionWeightClass: {
    'division_id': (Division, ['season_partition', 'pos']),
  },
  LeagueWeightClass: {
    'league_id': (League, ['season_partition', 'pos']),
  },
};
