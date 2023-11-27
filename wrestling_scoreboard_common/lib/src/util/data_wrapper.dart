import '../data.dart';
import '../enums/crud.dart';

Map<String, dynamic> singleToJson(Object single, Type type, CRUD operation) {
  return <String, dynamic>{
    'operation': operation.name,
    'isMany': false,
    'isRaw': single is! DataObject,
    'tableName': getTableNameFromType(type),
    'data': single is DataObject ? single.toJson() : single,
  };
}

Map<String, dynamic> manyToJson(List<Object> many, Type type, CRUD operation, {Type? filterType, int? filterId}) {
  return <String, dynamic>{
    'operation': operation.name,
    'isMany': true,
    'isRaw': many.isEmpty || (many.first is! DataObject),
    'filterType': filterType == null ? null : getTableNameFromType(filterType),
    if (filterId != null) 'filterId': filterId,
    'tableName': getTableNameFromType(type),
    'data': many.map((e) => e is DataObject ? e.toJson() : e).toList(),
  };
}

typedef HandleSingleCallback = Future<int> Function<T extends DataObject>({required CRUD operation, required T single});
typedef HandleSingleRawCallback = Future<int> Function<T extends DataObject>(
    {required CRUD operation, required Map<String, dynamic> single});
typedef HandleManyCallback = Future<void> Function<T extends DataObject>(
    {required CRUD operation, required ManyDataObject<T> many});
typedef HandleManyRawCallback = Future<void> Function<T extends DataObject>(
    {required CRUD operation, required ManyDataObject<Map<String, dynamic>> many});

Future<int?> handleFromJson(Map<String, Object?> json, {
  required HandleSingleCallback handleSingle,
  required HandleManyCallback handleMany,
  required HandleSingleRawCallback handleSingleRaw,
  required HandleManyRawCallback handleManyRaw,
}) {
  final type = getTypeFromTableName(json['tableName'] as String);
  switch (type) {
    case BoutConfig:
      return _handleFromJsonGeneric<BoutConfig>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case Club:
      return _handleFromJsonGeneric<Club>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case Fight:
      return _handleFromJsonGeneric<Fight>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case FightAction:
      return _handleFromJsonGeneric<FightAction>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case League:
      return _handleFromJsonGeneric<League>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case LeagueWeightClass:
      return _handleFromJsonGeneric<LeagueWeightClass>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case LeagueTeamParticipation:
      return _handleFromJsonGeneric<LeagueTeamParticipation>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case Lineup:
      return _handleFromJsonGeneric<Lineup>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case Membership:
      return _handleFromJsonGeneric<Membership>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case Participation:
      return _handleFromJsonGeneric<Participation>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case ParticipantState:
      return _handleFromJsonGeneric<ParticipantState>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case Person:
      return _handleFromJsonGeneric<Person>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case Team:
      return _handleFromJsonGeneric<Team>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case TeamMatch:
      return _handleFromJsonGeneric<TeamMatch>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case Tournament:
      return _handleFromJsonGeneric<Tournament>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case TournamentTeamParticipation:
      return _handleFromJsonGeneric<TournamentTeamParticipation>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case WeightClass:
      return _handleFromJsonGeneric<WeightClass>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    default:
      throw UnimplementedError('Cannot handle Json for type "${type.toString()}".');
  }
}

Future<int?> _handleFromJsonGeneric<T extends DataObject>(Map<String, dynamic> json, {
  required HandleSingleCallback handleSingle,
  required HandleManyCallback handleMany,
  required HandleSingleRawCallback handleSingleRaw,
  required HandleManyRawCallback handleManyRaw,
}) async {
  final isMany = json['isMany'] as bool;
  final isRaw = json['isRaw'] as bool;
  final operation = CrudParser.valueOf(json['operation']);
  if (isMany) {
    final List<dynamic> data = json['data'];
    final filterType = json['filterType'] == null ? null : getTypeFromTableName(json['filterType']);
    final int? filterId = json['filterId'];
    if (isRaw) {
      await handleManyRaw<T>(
          operation: operation,
          many: ManyDataObject<Map<String, dynamic>>(
              data: data.map((e) => e as Map<String, dynamic>).toList(), filterType: filterType, filterId: filterId));
    } else {
      await handleMany<T>(
          operation: operation,
          many: ManyDataObject<T>(
              data: data.map((e) => DataObject.fromJson<T>(e as Map<String, dynamic>)).toList(),
              filterType: filterType,
              filterId: filterId));
    }
  } else {
    if (isRaw) {
      return await handleSingleRaw<T>(operation: operation, single: json['data']);
    } else {
      return await handleSingle<T>(operation: operation, single: DataObject.fromJson<T>(json['data']));
    }
  }
  return null;
}

class ManyDataObject<T> {
  List<T> data;
  final Type? filterType;
  final int? filterId;

  ManyDataObject({required this.data, this.filterType, this.filterId});
}

// TODO: deprecate in favor of Type.tableName
String getTableNameFromType(Type t) {
  switch (t) {
    case const (BoutConfig):
      return 'bout_config';
    case const (Club):
      return 'club';
    case const (Fight):
      return 'fight';
    case const (FightAction):
      return 'fight_action';
    case const (League):
      return 'league';
    case const (LeagueWeightClass):
      return 'league_weight_class';
    case const (Lineup):
      return 'lineup';
    case const (Membership):
      return 'membership';
    case const (Participation):
      return 'participation';
    case const (ParticipantState):
      return 'participant_state';
    case const (Person):
      return 'person';
    case const (Team):
      return 'team';
    case const (TeamMatch):
      return 'team_match';
    case const (TeamMatchFight):
      return 'team_match_fight';
    case const (Tournament):
      return 'tournament';
    case const (WeightClass):
      return 'weight_class';
    default:
      throw UnimplementedError('ClassName for "${t.toString()}" not found.');
  }
}

Type getTypeFromTableName(String tableName) {
  switch (tableName) {
    case 'bout_config':
      return BoutConfig;
    case 'club':
      return Club;
    case 'fight':
      return Fight;
    case 'fight_action':
      return FightAction;
    case 'league':
      return League;
    case 'league_weight_class':
      return LeagueWeightClass;
    case 'lineup':
      return Lineup;
    case 'membership':
      return Membership;
    case 'participation':
      return Participation;
    case 'participant_state':
      return ParticipantState;
    case 'person':
      return Person;
    case 'team':
      return Team;
    case 'team_match':
      return TeamMatch;
    case 'team_match_fight':
      return TeamMatchFight;
    case 'tournament':
      return Tournament;
    case 'weight_class':
      return WeightClass;
    default:
      throw UnimplementedError('Type for "${tableName.toString()}" not found.');
  }
}
