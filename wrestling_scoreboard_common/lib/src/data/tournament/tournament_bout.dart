import 'package:freezed_annotation/freezed_annotation.dart';

import '../data_object.dart';
import '../bout.dart';
import 'tournament.dart';

part 'tournament_bout.freezed.dart';
part 'tournament_bout.g.dart';

@freezed
class TournamentBout with _$TournamentBout implements DataObject {
  const TournamentBout._();

  const factory TournamentBout({
    int? id,
    required Tournament tournament,
    required Bout bout,
  }) = _TournamentBout;

  factory TournamentBout.fromJson(Map<String, Object?> json) => _$TournamentBoutFromJson(json);

  static Future<TournamentBout> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final tournament = await getSingle<Tournament>(e['tournament_id'] as int);
    final bout = await getSingle<Bout>(e['bout_id'] as int);

    return TournamentBout(
      id: e['id'] as int?,
      tournament: tournament!,
      bout: bout!,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'tournament_id': tournament.id,
      'bout_id': bout.id,
    };
  }

  @override
  String get tableName => 'tournament_bout';

  @override
  TournamentBout copyWithId(int? id) {
    return copyWith(id: id);
  }
}
