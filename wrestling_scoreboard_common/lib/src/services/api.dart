import '../../common.dart';

export 'apis/germany_nrw.dart';

enum WrestlingApiProvider {
  deNwRingenApi;

  WrestlingApi get api {
    switch (this) {
      case WrestlingApiProvider.deNwRingenApi:
        return NrwGermanyWrestlingApi();
    }
  }
}

/// Abstraction for providing an api interface.
abstract class WrestlingApi {
  Future<List<League>> importLeagues({int? season});
}
