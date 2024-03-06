export 'reports/germany_nrw.dart';

enum WrestlingApiProvider {
  deNwRingenApi;

  WrestlingApi get api {
    switch (this) {
      case WrestlingApiProvider.deNwRingenApi:
        throw UnimplementedError();
    }
  }
}

/// Abstraction for providing an api interface.
abstract class WrestlingApi {}
