import 'package:json_annotation/json_annotation.dart';

import 'bout_config.dart';
import 'data_object.dart';

part 'league.g.dart';

/// The league in which the team is fighting.
@JsonSerializable()
class League extends DataObject {
  static League outOfCompetition =
      League(name: 'Out of competition', startDate: DateTime(DateTime.now().year), boutConfig: BoutConfig());
  final DateTime startDate;
  final String name;
  final BoutConfig boutConfig;

  League({
    int? id,
    required this.name,
    required this.startDate,
    required this.boutConfig,
  }) : super(id);

  factory League.fromJson(Map<String, dynamic> json) => _$LeagueFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LeagueToJson(this);

  static Future<League> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final boutConfig = await getSingle<BoutConfig>(e['bout_config_id'] as int);
    return League(
      id: e['id'] as int?,
      name: e['name'] as String,
      startDate: e['start_date'] as DateTime,
      boutConfig: boutConfig!,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'start_date': startDate,
      'bout_config_id': boutConfig.id,
    };
  }
}
