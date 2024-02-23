import '../data.dart';
import '../enums/crud.dart';

Map<String, dynamic> singleToJson(Object single, Type type, CRUD operation) {
  return <String, dynamic>{
    'operation': operation.name,
    'isMany': false,
    'isRaw': single is! DataObject,
    'tableName': getTableNameFromType(type),
    'data': single, // Is converted automatically with jsonEncode
  };
}

Map<String, dynamic> manyToJson(
  List<Object> many,
  Type type,
  CRUD operation, {
  required bool isRaw,
  Type? filterType,
  int? filterId,
}) {
  return <String, dynamic>{
    'operation': operation.name,
    'isMany': true,
    'isRaw': isRaw,
    'filterType': filterType == null ? null : getTableNameFromType(filterType),
    if (filterId != null) 'filterId': filterId,
    'tableName': getTableNameFromType(type),
    'data': many, // Is converted automatically with jsonEncode
  };
}

typedef HandleSingleCallback = Future<int> Function<T extends DataObject>({required CRUD operation, required T single});
typedef HandleSingleRawCallback = Future<int> Function<T extends DataObject>(
    {required CRUD operation, required Map<String, dynamic> single});
typedef HandleManyCallback = Future<void> Function<T extends DataObject>(
    {required CRUD operation, required ManyDataObject<T> many});
typedef HandleManyRawCallback = Future<void> Function<T extends DataObject>(
    {required CRUD operation, required ManyDataObject<Map<String, dynamic>> many});

Future<int?> handleFromJson(
  Map<String, Object?> json, {
  required HandleSingleCallback handleSingle,
  required HandleManyCallback handleMany,
  required HandleSingleRawCallback handleSingleRaw,
  required HandleManyRawCallback handleManyRaw,
}) {
  final type = getTypeFromTableName(json['tableName'] as String);
  switch (type) {
    case const (BoutConfig):
      return _handleFromJsonGeneric<BoutConfig>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case const (Club):
      return _handleFromJsonGeneric<Club>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case const (Bout):
      return _handleFromJsonGeneric<Bout>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case const (BoutAction):
      return _handleFromJsonGeneric<BoutAction>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case const (League):
      return _handleFromJsonGeneric<League>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case const (LeagueWeightClass):
      return _handleFromJsonGeneric<LeagueWeightClass>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case const (LeagueTeamParticipation):
      return _handleFromJsonGeneric<LeagueTeamParticipation>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case const (Lineup):
      return _handleFromJsonGeneric<Lineup>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case const (Membership):
      return _handleFromJsonGeneric<Membership>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case const (Participation):
      return _handleFromJsonGeneric<Participation>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case const (ParticipantState):
      return _handleFromJsonGeneric<ParticipantState>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case const (Person):
      return _handleFromJsonGeneric<Person>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case const (Team):
      return _handleFromJsonGeneric<Team>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case const (TeamMatch):
      return _handleFromJsonGeneric<TeamMatch>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case const (TeamMatchBout):
      return _handleFromJsonGeneric<TeamMatchBout>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case const (Competition):
      return _handleFromJsonGeneric<Competition>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case const (CompetitionTeamParticipation):
      return _handleFromJsonGeneric<CompetitionTeamParticipation>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    case const (WeightClass):
      return _handleFromJsonGeneric<WeightClass>(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    default:
      throw UnimplementedError('Cannot handle Json for type "${type.toString()}".');
  }
}

Future<int?> _handleFromJsonGeneric<T extends DataObject>(
  Map<String, dynamic> json, {
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
    case const (Bout):
      return 'bout';
    case const (BoutAction):
      return 'bout_action';
    case const (League):
      return 'league';
    case const (LeagueWeightClass):
      return 'league_weight_class';
    case const (LeagueTeamParticipation):
      return 'league_team_participation';
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
    case const (TeamMatchBout):
      return 'team_match_bout';
    case const (Competition):
      return 'competition';
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
    case 'bout':
      return Bout;
    case 'bout_action':
      return BoutAction;
    case 'league':
      return League;
    case 'league_weight_class':
      return LeagueWeightClass;
    case 'league_team_participation':
      return LeagueTeamParticipation;
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
    case 'team_match_bout':
      return TeamMatchBout;
    case 'competition':
      return Competition;
    case 'weight_class':
      return WeightClass;
    default:
      throw UnimplementedError('Type for "${tableName.toString()}" not found.');
  }
}

/// Hierarchically ordered data types
final dataTypes = [
  BoutAction,
  ParticipantState,
  TeamMatchBout,
  Bout,
  LeagueTeamParticipation,
  Participation,
  TeamMatch,
  LeagueWeightClass,
  BoutConfig,
  Lineup,
  Membership,
  Person,
  Team,
  Club,
  League,
  WeightClass,
  Competition,
];
