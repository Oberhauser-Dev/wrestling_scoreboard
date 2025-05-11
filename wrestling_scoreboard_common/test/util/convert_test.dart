import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';

void main() {
  test('Character to Index', () {
    expect(encodeBase32(0), '');
    expect(encodeBase32(31), '7');
    expect(encodeBase32(32), 'BA');
    expect(encodeBase32(64), 'CA');
    expect(encodeBase32(66), 'CC');
    expect(decodeBase32('CA'), 64);
    expect(decodeBase32('cc'), 66);
  });
}
