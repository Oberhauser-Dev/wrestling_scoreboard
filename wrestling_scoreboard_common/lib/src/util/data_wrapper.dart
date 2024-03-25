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
  return switch (type) {
    const (BoutConfig) => _handleFromJsonGeneric<BoutConfig>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Club) => _handleFromJsonGeneric<Club>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Bout) => _handleFromJsonGeneric<Bout>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (BoutAction) => _handleFromJsonGeneric<BoutAction>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Organization) => _handleFromJsonGeneric<Organization>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Division) => _handleFromJsonGeneric<Division>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (League) => _handleFromJsonGeneric<League>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (DivisionWeightClass) => _handleFromJsonGeneric<DivisionWeightClass>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (LeagueTeamParticipation) => _handleFromJsonGeneric<LeagueTeamParticipation>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Lineup) => _handleFromJsonGeneric<Lineup>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Membership) => _handleFromJsonGeneric<Membership>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Participation) => _handleFromJsonGeneric<Participation>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (ParticipantState) => _handleFromJsonGeneric<ParticipantState>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Person) => _handleFromJsonGeneric<Person>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Team) => _handleFromJsonGeneric<Team>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (TeamMatch) => _handleFromJsonGeneric<TeamMatch>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (TeamMatchBout) => _handleFromJsonGeneric<TeamMatchBout>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Competition) => _handleFromJsonGeneric<Competition>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (CompetitionTeamParticipation) => _handleFromJsonGeneric<CompetitionTeamParticipation>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (WeightClass) => _handleFromJsonGeneric<WeightClass>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    _ => throw UnimplementedError('Cannot handle Json for type "${type.toString()}".'),
  };
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
  final operation = CRUD.values.byName(json['operation']);

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
  return switch (t) {
    const (BoutConfig) => 'bout_config',
    const (Club) => 'club',
    const (Bout) => 'bout',
    const (BoutAction) => 'bout_action',
    const (Organization) => 'organization',
    const (Division) => 'division',
    const (League) => 'league',
    const (DivisionWeightClass) => 'division_weight_class',
    const (LeagueTeamParticipation) => 'league_team_participation',
    const (Lineup) => 'lineup',
    const (Membership) => 'membership',
    const (Participation) => 'participation',
    const (ParticipantState) => 'participant_state',
    const (Person) => 'person',
    const (Team) => 'team',
    const (TeamMatch) => 'team_match',
    const (TeamMatchBout) => 'team_match_bout',
    const (Competition) => 'competition',
    const (WeightClass) => 'weight_class',
    _ => throw UnimplementedError('ClassName for "${t.toString()}" not found.'),
  };
}

Type getTypeFromTableName(String tableName) {
  return switch (tableName) {
    'bout_config' => BoutConfig,
    'club' => Club,
    'bout' => Bout,
    'bout_action' => BoutAction,
    'organization' => Organization,
    'division' => Division,
    'league' => League,
    'division_weight_class' => DivisionWeightClass,
    'league_team_participation' => LeagueTeamParticipation,
    'lineup' => Lineup,
    'membership' => Membership,
    'participation' => Participation,
    'participant_state' => ParticipantState,
    'person' => Person,
    'team' => Team,
    'team_match' => TeamMatch,
    'team_match_bout' => TeamMatchBout,
    'competition' => Competition,
    'weight_class' => WeightClass,
    _ => throw UnimplementedError('Type for "${tableName.toString()}" not found.'),
  };
}

/// Hierarchically ordered data types.
final dataTypes = [
  BoutAction,
  ParticipantState,
  TeamMatchBout,
  Bout,
  Participation,
  TeamMatch,
  Competition,
  Lineup,
  LeagueTeamParticipation,
  League,
  BoutConfig,
  Membership,
  Person,
  Team,
  Club,
  DivisionWeightClass,
  Division,
  WeightClass,
  Organization,
];
