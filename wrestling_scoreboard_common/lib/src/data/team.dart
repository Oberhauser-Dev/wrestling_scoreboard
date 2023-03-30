import 'package:json_annotation/json_annotation.dart';

import 'club.dart';
import 'data_object.dart';
import 'league.dart';

part 'team.g.dart';

/// The team of a club.
@JsonSerializable()
class Team extends DataObject {
  final String name;
  final String? description;
  League? league;
  Club club;

  Team({int? id, required this.name, required this.club, this.description, this.league}) : super(id);

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TeamToJson(this);

  static Future<Team> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final club = await getSingle<Club>(e['club_id'] as int);
    final leagueId = e['league_id'] as int?;
    final league = leagueId == null ? null : await getSingle<League>(leagueId);
    return Team(
        id: e['id'] as int?,
        name: e['name'] as String,
        club: club!,
        description: e['description'] as String?,
        league: league);
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'club_id': club.id,
      'league_id': league?.id,
    };
  }
}
