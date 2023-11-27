import '../data.dart';
import '../enums/crud.dart';

typedef GetSingleOfTypeCallback = Future<T?> Function<T extends DataObject>(int id);

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
      case const (Fight):
        return Fight.fromJson(json) as T;
      case const (FightAction):
        return FightAction.fromJson(json) as T;
      case const (League):
        return League.fromJson(json) as T;
      case const (LeagueWeightClass):
        return LeagueWeightClass.fromJson(json) as T;
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
      case const (TeamMatchFight):
        return TeamMatchFight.fromJson(json) as T;
      case const (Tournament):
        return Tournament.fromJson(json) as T;
      case const (TournamentFight):
        return TournamentFight.fromJson(json) as T;
      case const (TournamentPerson):
        return TournamentPerson.fromJson(json) as T;
      case const (TournamentTeamParticipation):
        return TournamentTeamParticipation.fromJson(json) as T;
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
        return (await Club.fromRaw(raw)) as T;
      case const (Fight):
        return (await Fight.fromRaw(raw, getSingle)) as T;
      case const (FightAction):
        return (await FightAction.fromRaw(raw, getSingle)) as T;
      case const (League):
        return (await League.fromRaw(raw, getSingle)) as T;
      case const (LeagueWeightClass):
        return (await LeagueWeightClass.fromRaw(raw, getSingle)) as T;
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
        return (await Person.fromRaw(raw)) as T;
      case const (Team):
        return (await Team.fromRaw(raw, getSingle)) as T;
      case const (TeamMatch):
        return (await TeamMatch.fromRaw(raw, getSingle)) as T;
      case const (TeamMatchFight):
        return (await TeamMatchFight.fromRaw(raw, getSingle)) as T;
      case const (Tournament):
        return (await Tournament.fromRaw(raw, getSingle)) as T;
      case const (TournamentPerson):
        return (await TournamentPerson.fromRaw(raw, getSingle)) as T;
      case const (TournamentTeamParticipation):
        return (await TournamentTeamParticipation.fromRaw(raw, getSingle)) as T;
      case const (WeightClass):
        return (await WeightClass.fromRaw(raw)) as T;
      default:
        throw UnimplementedError('Raw conversation for "$T" not found.');
    }
  }
}

class DataUnimplementedError extends UnimplementedError {
  DataUnimplementedError(CRUD operationType, Type type, [DataObject? filterObject])
      : super(
            'Data ${operationType.toString().substring(5).toUpperCase()}-request for "${type.toString()}" ${filterObject == null ? '' : 'in "${filterObject.runtimeType.toString()}"'} not found.');
}
