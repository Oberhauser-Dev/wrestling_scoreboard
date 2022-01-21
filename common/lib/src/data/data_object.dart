import '../data.dart';
import '../enums/crud.dart';

typedef GetSingleOfTypeCallback = Future<T?> Function<T extends DataObject>(int id);

abstract class DataObject {
  int? id;

  DataObject([this.id]);

  Map<String, dynamic> toJson();

  Map<String, dynamic> toRaw();

  String get tableName => getTableNameFromType(getBaseType());

  Type getBaseType() {
    if (this is Fight) return Fight;
    if (this is FightAction) return FightAction;
    if (this is TeamMatch) return TeamMatch;
    if (this is Team) return Team;
    if (this is Club) return Club;
    if (this is League) return League;
    if (this is Lineup) return Lineup;
    if (this is Membership) return Membership;
    if (this is ParticipantState) return ParticipantState;
    return runtimeType;
  }

  static T fromJson<T extends DataObject>(Map<String, dynamic> json) {
    switch (T) {
      case Club:
        return Club.fromJson(json) as T;
      case Fight:
        return Fight.fromJson(json) as T;
      case FightAction:
        return FightAction.fromJson(json) as T;
      case League:
        return League.fromJson(json) as T;
      case Lineup:
        return Lineup.fromJson(json) as T;
      case Membership:
        return Membership.fromJson(json) as T;
      case Participation:
        return Participation.fromJson(json) as T;
      case Team:
        return Team.fromJson(json) as T;
      case TeamMatch:
        return TeamMatch.fromJson(json) as T;
      default:
        throw UnimplementedError('Json conversation for "$T" not found.');
    }
  }

  static Future<T> fromRaw<T extends DataObject>(
      Map<String, dynamic> raw, GetSingleOfTypeCallback getSingle) async {
    switch (T) {
      case Club:
        return (await Club.fromRaw(raw)) as T;
      case Fight:
        return (await Fight.fromRaw(raw, getSingle)) as T;
      case FightAction:
        return (await FightAction.fromRaw(raw, getSingle)) as T;
      case League:
        return (await League.fromRaw(raw)) as T;
      case Lineup:
        return (await Lineup.fromRaw(raw, getSingle)) as T;
      case Membership:
        return (await Membership.fromRaw(raw, getSingle)) as T;
      case Participation:
        return (await Participation.fromRaw(raw, getSingle)) as T;
      case ParticipantState:
        return (await ParticipantState.fromRaw(raw, getSingle)) as T;
      case Person:
        return (await Person.fromRaw(raw)) as T;
      case Team:
        return (await Team.fromRaw(raw, getSingle)) as T;
      case TeamMatch:
        return (await TeamMatch.fromRaw(raw, getSingle)) as T;
      case WeightClass:
        return (await WeightClass.fromRaw(raw)) as T;
      default:
        throw UnimplementedError('Raw conversation for "$T" not found.');
    }
  }

  @override
  bool operator ==(o) => o is DataObject && o.runtimeType == runtimeType && id == o.id;
}

class DataUnimplementedError extends UnimplementedError {
  DataUnimplementedError(CRUD operationType, Type type, [DataObject? filterObject])
      : super(
            'Data ${operationType.toString().substring(5).toUpperCase()}-request for "${type.toString()}" ${filterObject == null ? '' : 'in "${filterObject.runtimeType.toString()}'}" not found.');
}
