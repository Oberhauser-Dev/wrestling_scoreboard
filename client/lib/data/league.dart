import 'package:common/common.dart';

class ClientLeague extends League {
  ClientLeague({required String name, required DateTime year}) : super(name: name, year: year);
  ClientLeague.from(League obj) : this(name: obj.name, year: obj.year);

  factory ClientLeague.fromJson(Map<String, dynamic> json) => ClientLeague.from(League.fromJson(json));
}
