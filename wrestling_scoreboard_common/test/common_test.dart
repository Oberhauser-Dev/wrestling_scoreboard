import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';

void main() {
  group('A group of tests', () {
    final club = Club(name: 'Quahog Hunters');

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(club.name, 'Quahog Hunters');
    });
  });
}
