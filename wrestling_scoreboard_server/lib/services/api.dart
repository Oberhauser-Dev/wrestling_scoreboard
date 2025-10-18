import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/services/apis/germany_by.dart';

/// Abstraction for providing an api interface.
abstract class WrestlingApi {
  final timeout = Duration(seconds: 10);

  set isMock(bool isMock);

  Organization get organization;

  GetSingleOfOrg get getSingleOfOrg;

  GetMany get getMany;

  AuthService? get authService;

  Future<Map<Division, Iterable<BoutResultRule>>> importDivisions({DateTime? minDate, DateTime? maxDate});

  Future<(Iterable<DivisionWeightClass>, Iterable<LeagueWeightClass>)> importDivisionAndLeagueWeightClasses({
    required Division division,
  });

  Future<Iterable<TeamClubAffiliation>> importTeamClubAffiliations();

  Future<Iterable<Membership>> importMemberships({required Club club});

  Future<Iterable<League>> importLeagues({required Division division});

  Future<Map<TeamMatch, Map<Person, PersonRole>>> importTeamMatches({required League league});

  Future<Map<TeamMatchBout, Iterable<BoutAction>>> importTeamMatchBouts({required TeamMatch teamMatch});

  Future<bool> checkCredentials();

  Future<List<DataObject>> search({required String searchStr, required Type searchType});
}

extension WrestlingApiProviderExtension on WrestlingApiProvider {
  WrestlingApi getApi(
    Organization organization, {
    required GetSingleOfOrg getSingleOfOrg,
    required GetMany getMany,
    AuthService? authService,
  }) {
    switch (this) {
      case WrestlingApiProvider.deNwRingenApi:
        return ByGermanyWrestlingApi(
          organization,
          getSingleOfOrg: getSingleOfOrg,
          getMany: getMany,
          apiUrl: 'https://www.brv-ringen.de/Api/dev/cs/',
          authService: authService as BasicAuthService,
        );
      case WrestlingApiProvider.deByRingenApi:
        if (authService != null && authService is! BasicAuthService) {
          throw 'Auth service is not valid for this API provider';
        }
        return ByGermanyWrestlingApi(
          organization,
          getSingleOfOrg: getSingleOfOrg,
          getMany: getMany,
          apiUrl: 'https://www.brv-ringen.de/Api/dev/cs/',
          authService: authService as BasicAuthService?,
        );
    }
  }
}
