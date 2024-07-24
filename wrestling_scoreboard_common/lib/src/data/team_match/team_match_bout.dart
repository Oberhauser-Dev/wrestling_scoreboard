import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'team_match_bout.freezed.dart';
part 'team_match_bout.g.dart';

@freezed
class TeamMatchBout with _$TeamMatchBout implements DataObject {
  const TeamMatchBout._();

  const factory TeamMatchBout({
    int? id,
    required int pos,
    required TeamMatch teamMatch,
    required Bout bout,
  }) = _TeamMatchBout;

  factory TeamMatchBout.fromJson(Map<String, Object?> json) => _$TeamMatchBoutFromJson(json);

  static Future<TeamMatchBout> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final teamMatch = await getSingle<TeamMatch>(e['team_match_id'] as int);
    final bout = await getSingle<Bout>(e['bout_id'] as int);

    return TeamMatchBout(
      id: e['id'] as int?,
      teamMatch: teamMatch,
      bout: bout,
      pos: e['pos'],
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'pos': pos,
      'team_match_id': teamMatch.id!,
      'bout_id': bout.id!,
    };
  }

  @override
  String get tableName => 'team_match_bout';

  @override
  TeamMatchBout copyWithId(int? id) {
    return copyWith(id: id);
  }

  @override
  String? get orgSyncId => throw UnimplementedError();

  @override
  Organization? get organization => throw UnimplementedError();
}
