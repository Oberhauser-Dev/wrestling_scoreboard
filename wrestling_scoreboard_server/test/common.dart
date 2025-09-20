import 'package:http/http.dart' as http;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_common/src/mocked_data.dart';

Future<Map<String, String>> getAuthHeaders(String apiUrl) async {
  final defaultHeaders = {'Content-Type': 'application/json'};

  Future<String> signIn(BasicAuthService authService) async {
    final uri = Uri.parse('$apiUrl/auth/sign_in');
    final response = await http.post(uri, headers: {...authService.header, ...defaultHeaders});
    return response.body;
  }

  final token = await signIn(BasicAuthService(username: 'admin', password: 'admin'));

  return {'Content-Type': 'application/json', ...BearerAuthService(token: token).header};
}

final mockedData = MockedData();

List<DataObject> getMockedDataObjects(Type type) {
  return switch (type) {
    const (AgeCategory) => mockedData.getAgeCategories(),
    const (Bout) => mockedData.getBouts(),
    const (BoutAction) => mockedData.getBoutActions(),
    const (BoutConfig) => mockedData.getBoutConfigs(),
    const (BoutResultRule) => mockedData.getBoutResultRules(),
    const (Club) => mockedData.getClubs(),
    const (Competition) => mockedData.getCompetitions(),
    const (CompetitionPerson) => mockedData.getCompetitionPersons(),
    const (CompetitionBout) => mockedData.getCompetitionBouts(),
    const (CompetitionLineup) => mockedData.getCompetitionLineups(),
    const (CompetitionSystemAffiliation) => mockedData.getCompetitionSystemAffiliations(),
    const (CompetitionAgeCategory) => mockedData.getCompetitionAgeCategories(),
    const (CompetitionWeightCategory) => mockedData.getCompetitionWeightCategories(),
    const (CompetitionParticipation) => mockedData.getCompetitionParticipations(),
    const (Organization) => mockedData.getOrganizations(),
    const (Division) => mockedData.getDivisions(),
    const (DivisionWeightClass) => mockedData.getDivisionWeightClasses(),
    const (League) => mockedData.getLeagues(),
    const (LeagueTeamParticipation) => mockedData.getLeagueTeamParticipations(),
    const (LeagueWeightClass) => mockedData.getLeagueWeightClasses(),
    const (TeamLineup) => mockedData.getTeamLineups(),
    const (Membership) => mockedData.getMemberships(),
    const (TeamLineupParticipation) => mockedData.getTeamLineupParticipations(),
    const (AthleteBoutState) => mockedData.getAthleteBoutStates(),
    const (Person) => mockedData.getPersons(),
    const (Team) => mockedData.getTeams(),
    const (TeamClubAffiliation) => mockedData.getTeamClubAffiliations(),
    const (TeamMatch) => mockedData.getTeamMatches(),
    const (TeamMatchBout) => mockedData.getTeamMatchBouts(),
    const (TeamMatchPerson) => mockedData.getTeamMatchPersons(),
    const (WeightClass) => mockedData.getWeightClasses(),
    _ => throw UnimplementedError(),
  };
}
