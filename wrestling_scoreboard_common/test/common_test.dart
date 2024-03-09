import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';

void main() {
  group('A group of tests', () {
    final organization = Organization(name: 'Deutscher Ringer Bund', abbreviation: 'DRB');

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(organization.name, 'Deutscher Ringer Bund');
      expect(organization.abbreviation, 'DRB');
    });
  });
}
