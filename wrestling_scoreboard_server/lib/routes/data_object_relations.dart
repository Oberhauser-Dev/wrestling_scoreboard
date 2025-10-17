import 'package:wrestling_scoreboard_common/common.dart';

const Map<Type, Map<Type, (String, List<String>)>> directDataObjectRelations = {
  Bout: {
    AthleteBoutState: ('red_id', []),
    // AthleteBoutState: ('blue_id', []), // Should also be present
  },
  BoutResultRule: {BoutConfig: ('bout_config_id', [])},
  Membership: {Club: ('club_id', []), Person: ('person_id', [])},
  BoutAction: {Bout: ('bout_id', [])},
  Organization: {Organization: ('parent_id', [])},
  Division: {Organization: ('organization_id', []), Division: ('parent_id', [])},
  Club: {Organization: ('organization_id', [])},
  Person: {Organization: ('organization_id', [])},
  AgeCategory: {Organization: ('organization_id', [])},
  Competition: {Organization: ('organization_id', [])},
  League: {Division: ('division_id', []), Organization: ('organization_id', [])},
  Team: {Organization: ('organization_id', [])},
  LeagueTeamParticipation: {League: ('league_id', []), Team: ('team_id', [])},
  TeamMatch: {
    League: ('league_id', ['date']),
  },
  TeamClubAffiliation: {Club: ('club_id', []), Team: ('team_id', [])},
  TeamLineupParticipation: {TeamLineup: ('lineup_id', []), Membership: ('membership_id', [])},
  CompetitionParticipation: {
    CompetitionLineup: ('competition_lineup_id', []),
    Membership: ('membership_id', []),
    CompetitionWeightCategory: ('weight_category_id', []),
  },
  TeamMatchBout: {
    TeamMatch: ('team_match_id', ['pos']),
  },
  TeamMatchPerson: {TeamMatch: ('team_match_id', []), Person: ('person_id', [])},
  CompetitionBout: {
    Competition: ('competition_id', ['pos']),
    CompetitionWeightCategory: ('weight_category_id', []),
  },
  CompetitionLineup: {
    Competition: ('competition_id', []),
    Club: ('club_id', []),
    Membership: ('leader_id', []),
    // Membership: ('coach_id', []), // Should also be present, but conflicts with type, or value should have a list of property names
  },
  CompetitionPerson: {Competition: ('competition_id', []), Person: ('person_id', [])},
  CompetitionWeightCategory: {
    Competition: ('competition_id', ['pos']),
    CompetitionAgeCategory: ('competition_age_category_id', []),
    WeightClass: ('weight_class_id', []),
  },
  CompetitionAgeCategory: {
    Competition: ('competition_id', ['pos']),
    AgeCategory: ('age_category_id', []),
  },
  CompetitionSystemAffiliation: {Competition: ('competition_id', [])},
  DivisionWeightClass: {
    Division: ('division_id', ['season_partition', 'pos']),
  },
  LeagueWeightClass: {
    League: ('league_id', ['season_partition', 'pos']),
  },
};
