// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Check functionality of person', () {
    MockableDateTime.isMocked = true;
    MockableDateTime.mockedDateTime = DateTime(2021, 8, 1);

    final personA = Person(prename: 'John', surname: 'Doe', birthDate: DateTime(2015, 8, 1));
    final personB = Person(prename: 'Max', surname: 'Muster', birthDate: DateTime(2015, 7, 31));

    expect(personA.age, 6);
    expect(personB.age, 5);
  });
}
