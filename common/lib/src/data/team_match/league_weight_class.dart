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

  Map<String, dynamic> toJson() => _$LeagueWeightClassToJson(this);
}
