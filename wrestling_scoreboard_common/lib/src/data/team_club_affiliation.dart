import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'team_club_affiliation.freezed.dart';
part 'team_club_affiliation.g.dart';

/// The affiliation of a team and a club.
@freezed
abstract class TeamClubAffiliation with _$TeamClubAffiliation implements DataObject {
  const TeamClubAffiliation._();

  const factory TeamClubAffiliation({int? id, required Team team, required Club club}) = _TeamClubAffiliation;

  factory TeamClubAffiliation.fromJson(Map<String, Object?> json) => _$TeamClubAffiliationFromJson(json);

  static Future<TeamClubAffiliation> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final club = await getSingle<Club>(e['club_id'] as int);
    final team = await getSingle<Team>(e['team_id'] as int);
    return TeamClubAffiliation(id: e['id'] as int?, club: club, team: team);
  }

  @override
  Map<String, dynamic> toRaw() {
    return {if (id != null) 'id': id, 'club_id': club.id!, 'team_id': team.id!};
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'team_club_affiliation';

  @override
  TeamClubAffiliation copyWithId(int? id) {
    return copyWith(id: id);
  }
}
