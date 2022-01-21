import 'package:common/common.dart';
import 'package:json_annotation/json_annotation.dart';

import '../data_object.dart';

part 'league_weight_class.g.dart';

@JsonSerializable()
class LeagueWeightClass extends DataObject {
  int pos;
  League league;
  WeightClass weightClass;

  LeagueWeightClass({int? id, required this.league, required this.weightClass, required this.pos}) : super(id);

  factory LeagueWeightClass.fromJson(Map<String, dynamic> json) => _$LeagueWeightClassFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LeagueWeightClassToJson(this);

  @override
  Map<String, dynamic> toRaw() {
    return {
      'pos': pos,
      'league_id': league.id,
      'weight_class_id': weightClass.id,
    };
  }

  static Future<LeagueWeightClass> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async =>
      LeagueWeightClass(
        league: (await getSingle<League>(e['league_id'] as int))!,
        weightClass: (await getSingle<WeightClass>(e['weight_class_id'] as int))!,
        pos: e['pos'],
      );
}
