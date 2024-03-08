import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';

void main() {
  group('APIs', () {
    test('Germany, NRW', () async {
      final wrestlingApi = WrestlingApiProvider.deNwRingenApi.api;
      final leagues = await wrestlingApi.importLeagues(season: 2023);
      expect(
        leagues,
        '',
      );
    });
  });
}
