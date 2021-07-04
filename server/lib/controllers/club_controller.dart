import 'package:common/common.dart';
import 'package:server/controllers/entity_controller.dart';

class ClubController extends EntityController<Club> {
  static final ClubController _singleton = ClubController._internal();

  factory ClubController() {
    return _singleton;
  }

  ClubController._internal() : super(tableName: 'club');

  @override
  Future<Club> parseToClass(Map<String, dynamic> e) async {
    return Club(id: e['id'] as int?, no: e['no'] as String?, name: e['name'] as String);
  }
}
