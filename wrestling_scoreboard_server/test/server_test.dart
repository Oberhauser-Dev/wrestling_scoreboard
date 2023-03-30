import 'package:test/test.dart';

void main() {
  myTestMethod() => 42;
  
  test('Run some test', () {
    expect(myTestMethod(), 42);
  });
}
