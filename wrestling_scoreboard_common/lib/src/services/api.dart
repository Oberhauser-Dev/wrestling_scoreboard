import '../../common.dart';
import 'apis/germany_by.dart';

typedef GetSingleOfOrg = Future<T> Function<T extends Organizational>(String orgSyncId, {required int orgId});

enum WrestlingApiProvider {
  deNwRingenApi,
  deByRingenApi;

  String get name => toString().split('.').last;

  WrestlingApi getApi(
    Organization organization, {
    required GetSingleOfOrg getSingleOfOrg,
    AuthService? authService,
  }) {
    switch (this) {
      case WrestlingApiProvider.deNwRingenApi:
        return ByGermanyWrestlingApi(
          organization,
          getSingleOfOrg: getSingleOfOrg,
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
          apiUrl: 'https://www.brv-ringen.de/Api/dev/cs/',
          authService: authService as BasicAuthService?,
        );
    }
  }
}

/// Abstraction for providing an api interface.
abstract class WrestlingApi {
  final timeout = Duration(seconds: 10);

  set isMock(bool isMock);

  Organization get organization;

  GetSingleOfOrg get getSingleOfOrg;

  AuthService? get authService;

  Future<Map<Division, Iterable<BoutResultRule>>> importDivisions({DateTime? minDate, DateTime? maxDate});

  Future<(Iterable<DivisionWeightClass>, Iterable<LeagueWeightClass>)> importDivisionAndLeagueWeightClasses({
    required Division division,
  });

  Future<Iterable<TeamClubAffiliation>> importTeamClubAffiliations();

  Future<Iterable<Membership>> importMemberships({required Club club});

  Future<Iterable<League>> importLeagues({required Division division});

  Future<Iterable<TeamMatch>> importTeamMatches({required League league});

  Future<Map<Bout, Iterable<BoutAction>>> importBouts({required WrestlingEvent event});

  Future<List<DataObject>> search({required String searchStr, required Type searchType});
}
