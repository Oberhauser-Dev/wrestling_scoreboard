import 'package:common/common.dart';

import 'entity_controller.dart';

class PersonController extends EntityController<Person> {
  static final PersonController _singleton = PersonController._internal();

  factory PersonController() {
    return _singleton;
  }

  PersonController._internal() : super(tableName: 'person');

  @override
  Future<Person> parseToClass(Map<String, dynamic> e) async {
    final gender = genderDecode(e['gender']);

    return Person(
      id: e['id'] as int?,
      prename: e['prename'] as String,
      surname: e['surname'] as String,
      gender: gender,
      birthDate: e['birthDate'] as DateTime?,
    );
  }
}
