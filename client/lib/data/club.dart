import 'package:common/common.dart';

class ClientClub extends Club {
  ClientClub({int? id, required String name, String? no}) : super(id: id, name: name, no: no);

  ClientClub.from(Club obj) : this(id: obj.id, name: obj.name, no: obj.no);

  factory ClientClub.fromJson(Map<String, dynamic> json) => ClientClub.from(Club.fromJson(json));
}
