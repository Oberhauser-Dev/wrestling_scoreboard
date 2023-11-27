import 'package:freezed_annotation/freezed_annotation.dart';

import '../data_object.dart';
import '../fight.dart';
import 'tournament.dart';

part 'tournament_fight.freezed.dart';
part 'tournament_fight.g.dart';

@freezed
class TournamentFight with _$TournamentFight implements DataObject {
  const TournamentFight._();

  const factory TournamentFight({
    int? id,
    required Tournament tournament,
    required Fight fight,
  }) = _TournamentFight;

  factory TournamentFight.fromJson(Map<String, Object?> json) => _$TournamentFightFromJson(json);

  static Future<TournamentFight> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final tournament = await getSingle<Tournament>(e['tournament_id'] as int);
    final fight = await getSingle<Fight>(e['fight_id'] as int);

    return TournamentFight(
      id: e['id'] as int?,
      tournament: tournament!,
      fight: fight!,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'tournament_id': tournament.id,
      'fight_id': fight.id,
    };
  }

  @override
  String get tableName => 'tournament_fight';

  @override
  TournamentFight copyWithId(int? id) {
    return copyWith(id: id);
  }
}
