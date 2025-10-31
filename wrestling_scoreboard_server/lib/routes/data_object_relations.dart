import 'package:wrestling_scoreboard_common/common.dart';

class OrderableProperty {
  final String property;
  final List<String> orderBy;

  const OrderableProperty(this.property, [this.orderBy = const []]);
}

const Map<Type, Map<Type, List<OrderableProperty>>> directDataObjectRelations = {
  Bout: {
    AthleteBoutState: [OrderableProperty('red_id'), OrderableProperty('blue_id')],
  },
  BoutResultRule: {
    BoutConfig: [OrderableProperty('bout_config_id')],
  },
  Membership: {
    Club: [OrderableProperty('club_id')],
    Person: [OrderableProperty('person_id')],
  },
  BoutAction: {
    Bout: [OrderableProperty('bout_id')],
  },
  Organization: {
    Organization: [OrderableProperty('parent_id')],
  },
  Division: {
    Organization: [OrderableProperty('organization_id')],
    Division: [OrderableProperty('parent_id')],
  },
  Club: {
    Organization: [OrderableProperty('organization_id')],
  },
  Person: {
    Organization: [OrderableProperty('organization_id')],
  },
  AgeCategory: {
    Organization: [OrderableProperty('organization_id')],
  },
  Competition: {
    Organization: [OrderableProperty('organization_id')],
  },
  League: {
    Division: [OrderableProperty('division_id')],
    Organization: [OrderableProperty('organization_id')],
  },
  Team: {
    Organization: [OrderableProperty('organization_id')],
  },
  LeagueTeamParticipation: {
    League: [OrderableProperty('league_id')],
    Team: [OrderableProperty('team_id')],
  },
  TeamMatch: {
    League: [
      OrderableProperty('league_id', ['date']),
    ],
  },
  TeamClubAffiliation: {
    Club: [OrderableProperty('club_id')],
    Team: [OrderableProperty('team_id')],
  },
  TeamLineupParticipation: {
    TeamLineup: [OrderableProperty('lineup_id')],
    Membership: [OrderableProperty('membership_id')],
  },
  CompetitionParticipation: {
    CompetitionLineup: [OrderableProperty('competition_lineup_id')],
    Membership: [OrderableProperty('membership_id')],
    CompetitionWeightCategory: [OrderableProperty('weight_category_id')],
  },
  TeamMatchBout: {
    TeamMatch: [OrderableProperty('team_match_id')],
  },
  TeamMatchPerson: {
    TeamMatch: [OrderableProperty('team_match_id')],
    Person: [OrderableProperty('person_id')],
  },
  CompetitionBout: {
    Competition: [OrderableProperty('competition_id')],
    CompetitionWeightCategory: [OrderableProperty('weight_category_id')],
  },
  CompetitionLineup: {
    Competition: [OrderableProperty('competition_id')],
    Club: [OrderableProperty('club_id')],
    Membership: [OrderableProperty('leader_id'), OrderableProperty('coach_id')],
  },
  CompetitionPerson: {
    Competition: [OrderableProperty('competition_id')],
    Person: [OrderableProperty('person_id')],
  },
  CompetitionWeightCategory: {
    Competition: [OrderableProperty('competition_id')],
    CompetitionAgeCategory: [OrderableProperty('competition_age_category_id')],
    WeightClass: [OrderableProperty('weight_class_id')],
  },
  CompetitionAgeCategory: {
    Competition: [OrderableProperty('competition_id')],
    AgeCategory: [OrderableProperty('age_category_id')],
  },
  CompetitionSystemAffiliation: {
    Competition: [OrderableProperty('competition_id')],
  },
  DivisionWeightClass: {
    Division: [
      OrderableProperty('division_id', ['season_partition']),
    ],
  },
  LeagueWeightClass: {
    League: [
      OrderableProperty('league_id', ['season_partition']),
    ],
  },
};
