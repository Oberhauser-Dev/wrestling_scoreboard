import 'package:freezed_annotation/freezed_annotation.dart';

import '../data_object.dart';
import '../fight.dart';
import 'team_match.dart';

part 'team_match_fight.freezed.dart';

part 'team_match_fight.g.dart';

@freezed
class TeamMatchFight with _$TeamMatchFight implements DataObject {
  const TeamMatchFight._();

  const factory TeamMatchFight({
    int? id,
    required int pos,
    required TeamMatch teamMatch,
    required Fight fight,
  }) = _TeamMatchFight;

  factory TeamMatchFight.fromJson(Map<String, Object?> json) => _$TeamMatchFightFromJson(json);

  static Future<TeamMatchFight> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final teamMatch = await getSingle<TeamMatch>(e['team_match_id'] as int);
    final fight = await getSingle<Fight>(e['fight_id'] as int);

    return TeamMatchFight(
      id: e['id'] as int?,
      teamMatch: teamMatch!,
      fight: fight!,
      pos: e['pos'],
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'pos': pos,
      'team_match_id': teamMatch.id,
      'fight_id': fight.id,
    };
  }

  @override
  String get tableName => 'team_match_fight';

  @override
  TeamMatchFight copyWithId(int? id) {
    return copyWith(id: id);
  }
}
