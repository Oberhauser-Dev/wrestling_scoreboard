import '../../common.dart';

/// Hierarchically ordered data types (most to least dependent on others).
/// DO NOT CHANGE THE ORDER unless you know what you do!
final dataTypes = [
  BoutAction,
  TeamMatchBout,
  Bout,
  AthleteBoutState,
  TeamMatchParticipation,
  TeamMatch,
  Competition,
  TeamLineup,
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
  AthleteBoutState: AthleteBoutState.searchableForeignAttributeMapping,
  TeamMatchParticipation: TeamMatchParticipation.searchableForeignAttributeMapping,
  TeamMatchBout: TeamMatchBout.searchableForeignAttributeMapping,
};

// TODO: May think about using an enum instead of a Type. Then all can use switch cases and no classes are forgotten anymore.
String getTableNameFromType(Type t) {
  return switch (t) {
    const (AgeCategory) => AgeCategory.cTableName,
    const (BasicAuthService) => BasicAuthService.cTableName, // Only used for type encoding
    const (Bout) => Bout.cTableName,
    const (BoutAction) => BoutAction.cTableName,
    const (BoutConfig) => BoutConfig.cTableName,
    const (BoutResultRule) => BoutResultRule.cTableName,
    const (Club) => Club.cTableName,
    const (Competition) => Competition.cTableName,
    const (CompetitionBout) => CompetitionBout.cTableName,
    const (CompetitionLineup) => CompetitionLineup.cTableName,
    const (CompetitionWeightCategory) => CompetitionWeightCategory.cTableName,
    const (CompetitionParticipation) => CompetitionParticipation.cTableName,
    const (CompetitionPerson) => CompetitionPerson.cTableName,
    const (CompetitionSystemAffiliation) => CompetitionSystemAffiliation.cTableName,
    const (Organization) => Organization.cTableName,
    const (Division) => Division.cTableName,
    const (DivisionWeightClass) => DivisionWeightClass.cTableName,
    const (League) => League.cTableName,
    const (LeagueWeightClass) => LeagueWeightClass.cTableName,
    const (LeagueTeamParticipation) => LeagueTeamParticipation.cTableName,
    const (TeamLineup) => TeamLineup.cTableName,
    const (Membership) => Membership.cTableName,
    const (TeamMatchParticipation) => TeamMatchParticipation.cTableName,
    const (AthleteBoutState) => AthleteBoutState.cTableName,
    const (Person) => Person.cTableName,
    const (SecuredUser) => SecuredUser.cTableName,
    const (Team) => Team.cTableName,
    const (TeamClubAffiliation) => TeamClubAffiliation.cTableName,
    const (TeamMatch) => TeamMatch.cTableName,
    const (TeamMatchBout) => TeamMatchBout.cTableName,
    const (User) => User.cTableName,
    const (WeightClass) => WeightClass.cTableName,
    _ => throw UnimplementedError('ClassName for "${t.toString()}" not found.'),
  };
}

Type getTypeFromTableName(String tableName) {
  return switch (tableName) {
    BasicAuthService.cTableName => BasicAuthService, // Only used for type decoding
    Bout.cTableName => Bout,
    BoutAction.cTableName => BoutAction,
    BoutConfig.cTableName => BoutConfig,
    BoutResultRule.cTableName => BoutResultRule,
    Club.cTableName => Club,
    Competition.cTableName => Competition,
    Division.cTableName => Division,
    DivisionWeightClass.cTableName => DivisionWeightClass,
    League.cTableName => League,
    LeagueTeamParticipation.cTableName => LeagueTeamParticipation,
    LeagueWeightClass.cTableName => LeagueWeightClass,
    TeamLineup.cTableName => TeamLineup,
    Membership.cTableName => Membership,
    Organization.cTableName => Organization,
    TeamMatchParticipation.cTableName => TeamMatchParticipation,
    AthleteBoutState.cTableName => AthleteBoutState,
    Person.cTableName => Person,
    SecuredUser.cTableName => SecuredUser,
    Team.cTableName => Team,
    TeamClubAffiliation.cTableName => TeamClubAffiliation,
    TeamMatch.cTableName => TeamMatch,
    TeamMatchBout.cTableName => TeamMatchBout,
    User.cTableName => User,
    WeightClass.cTableName => WeightClass,
    _ => throw UnimplementedError('Type for "${tableName.toString()}" not found.'),
  };
}

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

typedef HandleSingleCallback = Future<int> Function<T extends DataObject>({
  required CRUD operation,
  required T single,
});
typedef HandleSingleRawCallback = Future<int> Function<T extends DataObject>({
  required CRUD operation,
  required Map<String, dynamic> single,
});
typedef HandleManyCallback = Future<void> Function<T extends DataObject>({
  required CRUD operation,
  required ManyDataObject<T> many,
});
typedef HandleManyRawCallback = Future<void> Function<T extends DataObject>({
  required CRUD operation,
  required ManyDataObject<Map<String, dynamic>> many,
});

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
    const (AgeCategory) => handleJson<AgeCategory>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
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
    const (CompetitionLineup) => handleJson<CompetitionLineup>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (CompetitionWeightCategory) => handleJson<CompetitionWeightCategory>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (CompetitionParticipation) => handleJson<CompetitionParticipation>(json,
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
    const (TeamLineup) => handleJson<TeamLineup>(json,
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
    const (TeamMatchParticipation) => handleJson<TeamMatchParticipation>(json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw),
    const (AthleteBoutState) => handleJson<AthleteBoutState>(json,
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
