import '../common.dart';

const Map<Type, List<String>> dataObjectOrder = {
  TeamMatch: ['date'],
  League: ['end_date', 'name'],
  Division: ['end_date', 'name'],
  Club: ['name'],
  DivisionWeightClass: ['season_partition'],
  LeagueWeightClass: ['season_partition'],
  Competition: ['date', 'name'],
  BoutAction: ['duration_millis'],
  Person: ['prename', 'surname'],
};

const Map<Type, Map<Type, List<String>>> directDataObjectRelations = {
  Bout: {
    AthleteBoutState: ['red_id', 'blue_id'],
  },
  BoutResultRule: {
    BoutConfig: ['bout_config_id'],
  },
  Membership: {
    Club: ['club_id'],
    Person: ['person_id'],
  },
  BoutAction: {
    Bout: ['bout_id'],
  },
  Organization: {
    Organization: ['parent_id'],
  },
  Division: {
    Organization: ['organization_id'],
    Division: ['parent_id'],
  },
  Club: {
    Organization: ['organization_id'],
  },
  Person: {
    Organization: ['organization_id'],
  },
  AgeCategory: {
    Organization: ['organization_id'],
  },
  Competition: {
    Organization: ['organization_id'],
  },
  League: {
    Division: ['division_id'],
    Organization: ['organization_id'],
  },
  Team: {
    Organization: ['organization_id'],
  },
  LeagueTeamParticipation: {
    League: ['league_id'],
    Team: ['team_id'],
  },
  TeamMatch: {
    League: ['league_id'],
  },
  TeamClubAffiliation: {
    Club: ['club_id'],
    Team: ['team_id'],
  },
  TeamLineupParticipation: {
    TeamLineup: ['lineup_id'],
    Membership: ['membership_id'],
  },
  CompetitionParticipation: {
    CompetitionLineup: ['competition_lineup_id'],
    Membership: ['membership_id'],
    CompetitionWeightCategory: ['weight_category_id'],
  },
  TeamMatchBout: {
    TeamMatch: ['team_match_id'],
  },
  TeamMatchPerson: {
    TeamMatch: ['team_match_id'],
    Person: ['person_id'],
  },
  CompetitionBout: {
    Competition: ['competition_id'],
    CompetitionWeightCategory: ['weight_category_id'],
  },
  CompetitionLineup: {
    Competition: ['competition_id'],
    Club: ['club_id'],
    Membership: ['leader_id', 'coach_id'],
  },
  CompetitionPerson: {
    Competition: ['competition_id'],
    Person: ['person_id'],
  },
  CompetitionWeightCategory: {
    Competition: ['competition_id'],
    CompetitionAgeCategory: ['competition_age_category_id'],
    WeightClass: ['weight_class_id'],
  },
  CompetitionAgeCategory: {
    Competition: ['competition_id'],
    AgeCategory: ['age_category_id'],
  },
  CompetitionSystemAffiliation: {
    Competition: ['competition_id'],
  },
  DivisionWeightClass: {
    Division: ['division_id'],
  },
  LeagueWeightClass: {
    League: ['league_id'],
  },
};
