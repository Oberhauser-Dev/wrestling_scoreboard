import 'package:freezed_annotation/freezed_annotation.dart';

import '../bout_config.dart';
import '../data_object.dart';

part 'league.freezed.dart';
part 'league.g.dart';

/// The league in which the team is fighting.
@freezed
class League with _$League implements DataObject {
  static League outOfCompetition =
      League(name: 'Out of competition', startDate: DateTime(DateTime.now().year), boutConfig: BoutConfig());

  const League._();

  const factory League({
    int? id,
    required String name,
    required DateTime startDate,
    required BoutConfig boutConfig,
  }) = _League;

  factory League.fromJson(Map<String, Object?> json) => _$LeagueFromJson(json);

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

  @override
  String get tableName => 'league';

  @override
  League copyWithId(int? id) {
    return copyWith(id: id);
  }
}
