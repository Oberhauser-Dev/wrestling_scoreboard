import '../../common.dart';

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

Map<String, dynamic> parseSingleRawJson(Map<String, dynamic> json) {
  return json['data'];
}

T parseSingleJson<T extends DataObject>(Map<String, dynamic> json) {
  return DataObject.fromJson<T>(json['data']);
}

ManyDataObject<Map<String, dynamic>> parseManyRawJson(Map<String, dynamic> json) {
  final List<dynamic> data = json['data'];
  final filterType = json['filterType'] == null ? null : getTypeFromTableName(json['filterType']);
  final int? filterId = json['filterId'];
  return ManyDataObject<Map<String, dynamic>>(
      data: data.map((e) {
        return e as Map<String, dynamic>;
      }).toList(),
      filterType: filterType,
      filterId: filterId);
}

ManyDataObject<T> parseManyJson<T extends DataObject>(Map<String, dynamic> json) {
  final List<dynamic> data = json['data'];
  final filterType = json['filterType'] == null ? null : getTypeFromTableName(json['filterType']);
  final int? filterId = json['filterId'];
  return ManyDataObject<T>(
      data: data.map((e) {
        return DataObject.fromJson<T>(e as Map<String, dynamic>);
      }).toList(),
      filterType: filterType,
      filterId: filterId);
}

Future<int?> handleGenericJson(
  Map<String, dynamic> json, {
  required HandleSingleCallback handleSingle,
  required HandleManyCallback handleMany,
  required HandleSingleRawCallback handleSingleRaw,
  required HandleManyRawCallback handleManyRaw,
}) {
  final type = getTypeFromTableName(json['tableName'] as String);
  return switch (type) {
    const (Bout) => handleJson<Bout>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (BoutAction) => handleJson<BoutAction>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (BoutConfig) => handleJson<BoutConfig>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (BoutResultRule) => handleJson<BoutResultRule>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Club) => handleJson<Club>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Competition) => handleJson<Competition>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (CompetitionTeamParticipation) => handleJson<CompetitionTeamParticipation>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Division) => handleJson<Division>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (DivisionWeightClass) => handleJson<DivisionWeightClass>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (League) => handleJson<League>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (LeagueTeamParticipation) => handleJson<LeagueTeamParticipation>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (LeagueWeightClass) => handleJson<LeagueWeightClass>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Lineup) => handleJson<Lineup>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Membership) => handleJson<Membership>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Organization) => handleJson<Organization>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Participation) => handleJson<Participation>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (ParticipantState) => handleJson<ParticipantState>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Person) => handleJson<Person>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (SecuredUser) => handleJson<SecuredUser>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (Team) => handleJson<Team>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (TeamMatch) => handleJson<TeamMatch>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (TeamMatchBout) => handleJson<TeamMatchBout>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (User) => handleJson<User>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (WeightClass) => handleJson<WeightClass>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    _ => throw UnimplementedError('Cannot handle Json for type "${type.toString()}".'),
  };
}

Future<int?> handleJson<T extends DataObject>(
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
    if (isRaw) {
      await handleManyRaw<T>(operation: operation, many: parseManyRawJson(json));
    } else {
      await handleMany<T>(
        operation: operation,
        many: parseManyJson<T>(json),
      );
    }
  } else {
    if (isRaw) {
      return await handleSingleRaw<T>(operation: operation, single: parseSingleRawJson(json));
    } else {
      final single = parseSingleJson<T>(json);
      return await handleSingle<T>(operation: operation, single: single);
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
    const (Bout) => 'bout',
    const (BasicAuthService) => 'basic_auth_service', // Only used for type encoding
    const (BoutConfig) => 'bout_config',
    const (BoutResultRule) => 'bout_result_rule',
    const (Club) => 'club',
    const (Competition) => 'competition',
    const (BoutAction) => 'bout_action',
    const (Organization) => 'organization',
    const (Division) => 'division',
    const (DivisionWeightClass) => 'division_weight_class',
    const (League) => 'league',
    const (LeagueWeightClass) => 'league_weight_class',
    const (LeagueTeamParticipation) => 'league_team_participation',
    const (Lineup) => 'lineup',
    const (Membership) => 'membership',
    const (Participation) => 'participation',
    const (ParticipantState) => 'participant_state',
    const (Person) => 'person',
    const (SecuredUser) => 'secured_user',
    const (Team) => 'team',
    const (TeamClubAffiliation) => 'team_club_affiliation',
    const (TeamMatch) => 'team_match',
    const (TeamMatchBout) => 'team_match_bout',
    const (User) => 'user',
    const (WeightClass) => 'weight_class',
    _ => throw UnimplementedError('ClassName for "${t.toString()}" not found.'),
  };
}

Type getTypeFromTableName(String tableName) {
  return switch (tableName) {
    'basic_auth_service' => BasicAuthService, // Only used for type decoding
    'bout' => Bout,
    'bout_action' => BoutAction,
    'bout_config' => BoutConfig,
    'bout_result_rule' => BoutResultRule,
    'club' => Club,
    'competition' => Competition,
    'division' => Division,
    'division_weight_class' => DivisionWeightClass,
    'league' => League,
    'league_team_participation' => LeagueTeamParticipation,
    'league_weight_class' => LeagueWeightClass,
    'lineup' => Lineup,
    'membership' => Membership,
    'organization' => Organization,
    'participation' => Participation,
    'participant_state' => ParticipantState,
    'person' => Person,
    'secured_user' => SecuredUser,
    'team' => Team,
    'team_club_affiliation' => TeamClubAffiliation,
    'team_match' => TeamMatch,
    'team_match_bout' => TeamMatchBout,
    'user' => User,
    'weight_class' => WeightClass,
    _ => throw UnimplementedError('Type for "${tableName.toString()}" not found.'),
  };
}

/// Hierarchically ordered data types (most to least dependent on others).
/// DO NOT CHANGE THE ORDER unless you know what you do!
final dataTypes = [
  BoutAction,
  TeamMatchBout,
  Bout,
  ParticipantState,
  Participation,
  TeamMatch,
  Competition,
  Lineup,
  LeagueTeamParticipation,
  LeagueWeightClass,
  League,
  Membership,
  Person,
  TeamClubAffiliation,
  Team,
  Club,
  DivisionWeightClass,
  Division,
  WeightClass,
  BoutResultRule,
  BoutConfig,
  Organization,
  SecuredUser,
  User,
];

/// Returns a map of data types with searchable attributes.
/// TODO: with macros, apply it to the property @Searchable.
final Map<Type, Set<String>> searchableDataTypes = {
  Bout: Bout.searchableAttributes,
  Club: Club.searchableAttributes,
  Organization: Organization.searchableAttributes,
  WeightClass: WeightClass.searchableAttributes,
  // Uses same attributes as WrestlingEvent ATM
  Competition: WrestlingEvent.searchableAttributes,
  // Uses same attributes as WrestlingEvent ATM
  TeamMatch: WrestlingEvent.searchableAttributes,
  Division: Division.searchableAttributes,
  League: League.searchableAttributes,
  Membership: Membership.searchableAttributes,
  Person: Person.searchableAttributes,
  Team: Team.searchableAttributes,
  TeamMatchBout: TeamMatchBout.searchableAttributes,
};

final Map<Type, Map<String, Type>> searchableForeignAttributeMapping = {
  Bout: Bout.searchableForeignAttributeMapping,
  Membership: Membership.searchableForeignAttributeMapping,
  ParticipantState: ParticipantState.searchableForeignAttributeMapping,
  Participation: Participation.searchableForeignAttributeMapping,
  TeamMatchBout: TeamMatchBout.searchableForeignAttributeMapping,
};
