import 'package:common/common.dart';
import 'package:test/test.dart';

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
