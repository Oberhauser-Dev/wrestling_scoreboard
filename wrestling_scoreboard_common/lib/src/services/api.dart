import '../../common.dart';

export 'apis/germany_nrw.dart';

typedef GetSingleOfProvider = Future<T> Function<T extends DataObject>(String providerId);

enum WrestlingApiProvider {
  deNwRingenApi,
  deByRingenApi;

  WrestlingApi getApi(
    Organization organization, {
    required GetSingleOfProvider getSingle,
  }) {
    switch (this) {
      case WrestlingApiProvider.deNwRingenApi:
        return NrwGermanyWrestlingApi(organization, getSingle: getSingle);
      case WrestlingApiProvider.deByRingenApi:
        return NrwGermanyWrestlingApi(
          organization,
          getSingle: getSingle,
          apiUrl: 'https://www.brv-ringen.de/Api/v1/cs/',
        );
    }
  }
}

/// Abstraction for providing an api interface.
abstract class WrestlingApi {
  set isMock(bool isMock);

  Organization get organization;

  Future<T> Function<T extends DataObject>(String providerId) get getSingle;

  Future<Iterable<Division>> importDivisions({DateTime? minDate, DateTime? maxDate});

  Future<Iterable<Club>> importClubs();

  Future<Iterable<Team>> importTeams({required Club club});

  Future<Iterable<League>> importLeagues({required Division division});

  Future<Iterable<TeamMatch>> importTeamMatches({required League league});
}
