import '../data.dart';
import '../enums/crud.dart';

abstract class DataObject {
  int? id;

  DataObject([this.id]);

  Map<String, dynamic> toJson();

  String get tableName => getTableNameFromType(getBaseType());

  Type getBaseType() {
    if (this is Fight) return Fight;
    if (this is TeamMatch) return TeamMatch;
    if (this is Team) return Team;
    if (this is Club) return Club;
    if (this is League) return League;
    if (this is Lineup) return Lineup;
    if (this is Membership) return Membership;
    if (this is ParticipantState) return ParticipantState;
    return runtimeType;
  }

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

class DataUnimplementedError extends UnimplementedError {
  DataUnimplementedError(CRUD operationType, Type type, [DataObject? filterObject])
      : super(
      'Data ${operationType.toString().substring(5).toUpperCase()}-request for "${type.toString()}" ${filterObject ==
          null ? '' : 'in "${filterObject.runtimeType.toString()}'}" not found.');
}
