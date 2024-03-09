import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'league.freezed.dart';

part 'league.g.dart';

/// The league in which the team is bouting.
@freezed
class League with _$League implements DataObject {
  const League._();

  const factory League({
    int? id,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required Division division,
  }) = _League;

  factory League.fromJson(Map<String, Object?> json) => _$LeagueFromJson(json);

  static Future<League> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final division = await getSingle<Division>(e['division_id'] as int);
    return League(
      id: e['id'] as int?,
      name: e['name'] as String,
      startDate: e['start_date'] as DateTime,
      endDate: e['end_date'] as DateTime,
      division: division,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'start_date': startDate,
      'end_date': endDate,
      'division_id': division.id,
    };
  }

  @override
  String get tableName => 'league';

  String get fullname => '${division.fullname}, $name';

  @override
  League copyWithId(int? id) {
    return copyWith(id: id);
  }
}
