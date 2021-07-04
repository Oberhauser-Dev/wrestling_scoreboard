import 'package:common/common.dart';

class ClientClub extends Club {
  ClientClub({required String name, int? id, String? no}) : super(name: name, id: id, no: no);

  ClientClub.from(Club obj) : this(name: obj.name, id: obj.id, no: obj.no);

  factory ClientClub.fromJson(Map<String, dynamic> json) => ClientClub.from(Club.fromJson(json));
}
