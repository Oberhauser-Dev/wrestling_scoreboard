import 'package:freezed_annotation/freezed_annotation.dart';

import '../data_object.dart';
import '../weight_class.dart';
import 'league.dart';

part 'league_weight_class.freezed.dart';
part 'league_weight_class.g.dart';

@freezed
class LeagueWeightClass with _$LeagueWeightClass implements DataObject {
  const LeagueWeightClass._();

  const factory LeagueWeightClass({
    int? id,
    required int pos,
    required League league,
    required WeightClass weightClass,
    int? seasonPartition,
  }) = _LeagueWeightClass;

  factory LeagueWeightClass.fromJson(Map<String, Object?> json) => _$LeagueWeightClassFromJson(json);

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'pos': pos,
      'league_id': league.id,
      'weight_class_id': weightClass.id,
      'season_partition': seasonPartition,
    };
  }

  static Future<LeagueWeightClass> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async =>
      LeagueWeightClass(
        id: e['id'] as int?,
        league: (await getSingle<League>(e['league_id'] as int)),
        weightClass: (await getSingle<WeightClass>(e['weight_class_id'] as int)),
        pos: e['pos'] as int,
        seasonPartition: e['season_partition'] as int?,
      );

  @override
  String get tableName => 'league_weight_class';

  @override
  LeagueWeightClass copyWithId(int? id) {
    return copyWith(id: id);
  }
}
