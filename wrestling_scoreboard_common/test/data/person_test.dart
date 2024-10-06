import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';

void main() {
  test('Persons age', () {
    MockableDateTime.isMocked = true;

    final personA = Person(prename: 'John', surname: 'Doe', birthDate: DateTime(2015, 8, 1));
    final personB = Person(prename: 'Max', surname: 'Muster', birthDate: DateTime(2015, 7, 31));
    final personC = Person(prename: 'Ashok', surname: 'Kumar', birthDate: DateTime(2015, 1, 1));
    final personD = Person(prename: 'Fred', surname: 'Nurk', birthDate: DateTime(2014, 12, 31));

    MockableDateTime.mockedDateTime = DateTime(2020, 12, 30);
    expect(personA.age, 5);
    expect(personB.age, 5);
    expect(personC.age, 5);
    expect(personD.age, 5);

    MockableDateTime.mockedDateTime = DateTime(2020, 12, 31);
    expect(personA.age, 5);
    expect(personB.age, 5);
    expect(personC.age, 5);
    expect(personD.age, 6);

    MockableDateTime.mockedDateTime = DateTime(2021, 1, 1);
    expect(personA.age, 5);
    expect(personB.age, 5);
    expect(personC.age, 6);
    expect(personD.age, 6);

    MockableDateTime.mockedDateTime = DateTime(2021, 7, 31);
    expect(personA.age, 5);
    expect(personB.age, 6);
    expect(personC.age, 6);
    expect(personD.age, 6);

    MockableDateTime.mockedDateTime = DateTime(2021, 8, 1);
    expect(personA.age, 6);
    expect(personB.age, 6);
    expect(personC.age, 6);
    expect(personD.age, 6);
  });
}
