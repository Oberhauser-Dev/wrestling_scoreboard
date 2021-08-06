import '../data.dart';

abstract class DataObject {
  int? id;

  DataObject([this.id]);

  Map<String, dynamic> toJson();

  String get tableName => getTableNameFromType(runtimeType);

  @override
  bool operator ==(o) => o is DataObject && o.runtimeType == runtimeType && id == o.id;
}

extension FromJson on Type {
  DataObject fromJson(Map<String, dynamic> json) {
    switch (this) {
      case Club:
        return Club.fromJson(json);
      case Fight:
        return Fight.fromJson(json);
      case League:
        return League.fromJson(json);
      case Lineup:
        return Lineup.fromJson(json);
      case Membership:
        return Membership.fromJson(json);
      case Participation:
        return Participation.fromJson(json);
      case Team:
        return Team.fromJson(json);
      case TeamMatch:
        return TeamMatch.fromJson(json);
      default:
        throw UnimplementedError('Json conversation for "${toString()}" not found.');
    }
  }
}