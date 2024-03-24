import '../../common.dart';
import 'auth/authorization.dart';

export 'apis/germany_nrw.dart';

typedef GetSingleOfOrg = Future<T> Function<T extends DataObject>(String orgSyncId, {required int orgId});

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
        return NrwGermanyWrestlingApi(
          organization,
          getSingleOfOrg: getSingleOfOrg,
          apiUrl: 'https://www.brv-ringen.de/Api/v1/cs/',
          authService: authService as BasicAuthService,
        );
      case WrestlingApiProvider.deByRingenApi:
        if (authService != null && authService is! BasicAuthService) {
          throw 'Auth service is not valid for this API provider';
        }
        return NrwGermanyWrestlingApi(
          organization,
          getSingleOfOrg: getSingleOfOrg,
          apiUrl: 'https://www.brv-ringen.de/Api/v1/cs/',
          authService: authService as BasicAuthService,
        );
    }
  }
}

/// Abstraction for providing an api interface.
abstract class WrestlingApi {
  set isMock(bool isMock);

  Organization get organization;

  GetSingleOfOrg get getSingleOfOrg;

  AuthService? get authService;

  Future<Iterable<Division>> importDivisions({DateTime? minDate, DateTime? maxDate});

  Future<Iterable<DivisionWeightClass>> importDivisionWeightClasses({required Division division});

  Future<Iterable<Club>> importClubs();

  Future<Iterable<Membership>> importMemberships({required Club club});

  Future<Iterable<Team>> importTeams({required Club club});

  Future<Iterable<League>> importLeagues({required Division division});

  Future<Iterable<TeamMatch>> importTeamMatches({required League league});
}
