import 'package:common/common.dart';

class ClientLeague extends League {
  ClientLeague({int? id, required String name, required DateTime startDate})
      : super(id: id, name: name, startDate: startDate);

  ClientLeague.from(League obj) : this(id: obj.id, name: obj.name, startDate: obj.startDate);

  factory ClientLeague.fromJson(Map<String, dynamic> json) => ClientLeague.from(League.fromJson(json));
}
