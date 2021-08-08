import 'package:common/common.dart';

import 'entity_controller.dart';

class WeightClassController extends EntityController<WeightClass> {
  static final WeightClassController _singleton = WeightClassController._internal();

  factory WeightClassController() {
    return _singleton;
  }

  WeightClassController._internal() : super(tableName: 'weight_class');

  @override
  Future<WeightClass> parseToClass(Map<String, dynamic> e) async {
    return WeightClass(
      id: e[primaryKeyName] as int?,
      name: e['name'] as String?,
      weight: e['weight'] as int,
      style: WrestlingStyleParser.valueOf(e['style']),
    );
  }

  @override
  Map<String, dynamic> parseFromClass(WeightClass e) {
    return {
      if (e.id != null) primaryKeyName: e.id,
      'name': e.name,
      'weight': e.weight,
      'style': e.style.name,
    };
  }
}