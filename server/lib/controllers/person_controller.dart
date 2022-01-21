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
    final gender = GenderParser.valueOf(e['gender']);

    return Person(
      id: e[primaryKeyName] as int?,
      prename: e['prename'] as String,
      surname: e['surname'] as String,
      gender: gender,
      birthDate: e['birth_date'] as DateTime?,
    );
  }

  @override
  Map<String, dynamic> parseFromClass(Person e) {
    return {
      if (e.id != null) primaryKeyName: e.id,
      'prename': e.prename,
      'surname': e.surname,
      'gender': e.gender?.name,
      'birth_date': e.birthDate,
    };
  }
}
