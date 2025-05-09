import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';

void main() {
  test('Character to Index', () {
    expect('a'.toIndex(), 1);
    expect('b'.toIndex(), 2);
    expect('z'.toIndex(), 26);
    expect('A'.toIndex(), 1);
    expect('B'.toIndex(), 2);
    expect('C'.toIndex(), 3);
    expect('Z'.toIndex(), 26);
  });
}
