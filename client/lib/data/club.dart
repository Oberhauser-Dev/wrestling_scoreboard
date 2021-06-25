import 'package:common/common.dart';

class ClientClub extends Club {
  ClientClub({required String name, String? id}) : super(name: name, id: id);

  ClientClub.from(Club obj) : this(name: obj.name, id: obj.id);

  factory ClientClub.fromJson(Map<String, dynamic> json) => ClientClub.from(Club.fromJson(json));
}
