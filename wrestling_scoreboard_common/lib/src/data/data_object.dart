import '../data.dart';
import '../enums/crud.dart';

typedef GetSingleOfTypeCallback = Future<T> Function<T extends DataObject>(int id);

abstract class DataObject {
  int? get id;

  Map<String, Object?> toJson();

  Map<String, dynamic> toRaw();

  DataObject copyWithId(int? id);

  String get tableName;

  static T fromJson<T extends DataObject>(Map<String, dynamic> json) {
    switch (T) {
      case const (BoutConfig):
        return BoutConfig.fromJson(json) as T;
      case const (Club):
        return Club.fromJson(json) as T;
      case const (Bout):
        return Bout.fromJson(json) as T;
      case const (BoutAction):
        return BoutAction.fromJson(json) as T;
      case const (Organization):
        return Organization.fromJson(json) as T;
      case const (Division):
        return Division.fromJson(json) as T;
      case const (League):
        return League.fromJson(json) as T;
      case const (DivisionWeightClass):
        return DivisionWeightClass.fromJson(json) as T;
      case const (LeagueTeamParticipation):
        return LeagueTeamParticipation.fromJson(json) as T;
      case const (Lineup):
        return Lineup.fromJson(json) as T;
      case const (Membership):
        return Membership.fromJson(json) as T;
      case const (Participation):
        return Participation.fromJson(json) as T;
      case const (ParticipantState):
        return ParticipantState.fromJson(json) as T;
      case const (Person):
        return Person.fromJson(json) as T;
      case const (Team):
        return Team.fromJson(json) as T;
      case const (TeamMatch):
        return TeamMatch.fromJson(json) as T;
      case const (TeamMatchBout):
        return TeamMatchBout.fromJson(json) as T;
      case const (Competition):
        return Competition.fromJson(json) as T;
      case const (CompetitionBout):
        return CompetitionBout.fromJson(json) as T;
      case const (CompetitionPerson):
        return CompetitionPerson.fromJson(json) as T;
      case const (CompetitionTeamParticipation):
        return CompetitionTeamParticipation.fromJson(json) as T;
      case const (WeightClass):
        return WeightClass.fromJson(json) as T;
      default:
        throw UnimplementedError('Json conversation for "$T" not found.');
    }
  }

  static Future<T> fromRaw<T extends DataObject>(Map<String, dynamic> raw, GetSingleOfTypeCallback getSingle) async {
    switch (T) {
      case const (BoutConfig):
        return (await BoutConfig.fromRaw(raw)) as T;
      case const (Club):
        return (await Club.fromRaw(raw, getSingle)) as T;
      case const (Bout):
        return (await Bout.fromRaw(raw, getSingle)) as T;
      case const (BoutAction):
        return (await BoutAction.fromRaw(raw, getSingle)) as T;
      case const (Organization):
        return (await Organization.fromRaw(raw, getSingle)) as T;
      case const (Division):
        return (await Division.fromRaw(raw, getSingle)) as T;
      case const (League):
        return (await League.fromRaw(raw, getSingle)) as T;
      case const (DivisionWeightClass):
        return (await DivisionWeightClass.fromRaw(raw, getSingle)) as T;
      case const (LeagueTeamParticipation):
        return (await LeagueTeamParticipation.fromRaw(raw, getSingle)) as T;
      case const (Lineup):
        return (await Lineup.fromRaw(raw, getSingle)) as T;
      case const (Membership):
        return (await Membership.fromRaw(raw, getSingle)) as T;
      case const (Participation):
        return (await Participation.fromRaw(raw, getSingle)) as T;
      case const (ParticipantState):
        return (await ParticipantState.fromRaw(raw, getSingle)) as T;
      case const (Person):
        return (await Person.fromRaw(raw, getSingle)) as T;
      case const (Team):
        return (await Team.fromRaw(raw, getSingle)) as T;
      case const (TeamMatch):
        return (await TeamMatch.fromRaw(raw, getSingle)) as T;
      case const (TeamMatchBout):
        return (await TeamMatchBout.fromRaw(raw, getSingle)) as T;
      case const (Competition):
        return (await Competition.fromRaw(raw, getSingle)) as T;
      case const (CompetitionPerson):
        return (await CompetitionPerson.fromRaw(raw, getSingle)) as T;
      case const (CompetitionTeamParticipation):
        return (await CompetitionTeamParticipation.fromRaw(raw, getSingle)) as T;
      case const (WeightClass):
        return (await WeightClass.fromRaw(raw)) as T;
      default:
        throw UnimplementedError('Raw conversation for "$T" not found.');
    }
  }
}

abstract class Organizational {
  String? get orgSyncId => null;

  Organization? get organization => null;
}

class DataUnimplementedError extends UnimplementedError {
  DataUnimplementedError(CRUD operationType, Type type, [DataObject? filterObject])
      : super(
            'Data ${operationType.toString().substring(5).toUpperCase()}-request for "${type.toString()}" ${filterObject == null ? '' : 'in "${filterObject.runtimeType.toString()}"'} not found.');
}
