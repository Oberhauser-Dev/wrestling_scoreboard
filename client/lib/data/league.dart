import 'package:common/common.dart';

class ClientLeague extends League {
  ClientLeague({required String name, required DateTime startDate}) : super(name: name, startDate: startDate);

  ClientLeague.from(League obj) : this(name: obj.name, startDate: obj.startDate);

  factory ClientLeague.fromJson(Map<String, dynamic> json) => ClientLeague.from(League.fromJson(json));
}
