import 'package:freezed_annotation/freezed_annotation.dart';

import '../bout_config.dart';
import '../data_object.dart';
import '../bout.dart';
import '../participation.dart';
import '../weight_class.dart';
import '../wrestling_event.dart';

part 'competition.freezed.dart';
part 'competition.g.dart';

/// For team matches only.
@freezed
class Competition extends WrestlingEvent with _$Competition {
  const Competition._();

  const factory Competition({
    int? id,
    required String name,
    required BoutConfig boutConfig,
    String? location,
    required DateTime date,
    String? no,
    int? visitorsCount,
    String? comment,
  }) = _Competition;

  factory Competition.fromJson(Map<String, Object?> json) => _$CompetitionFromJson(json);

  static Future<Competition> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final boutConfig = await getSingle<BoutConfig>(e['bout_config_id'] as int);
    // TODO fetch lineups, referees, weightClasses, etc.
    return Competition(
      id: e['id'] as int?,
      name: e['name'],
      location: e['location'] as String?,
      date: e['date'] as DateTime,
      visitorsCount: e['visitors_count'] as int?,
      comment: e['comment'] as String?,
      boutConfig: boutConfig,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return super.toRaw()
      ..addAll({
        if (id != null) 'id': id,
        'name': name,
        'bout_config_id': boutConfig.id,
      });
  }

  @override
  Future<List<Bout>> generateBouts(List<List<Participation>> teamParticipations, List<WeightClass> weightClasses) {
    // TODO: implement generateBouts
    throw UnimplementedError();
  }

  @override
  String get tableName => 'competition';

  @override
  Competition copyWithId(int? id) {
    return copyWith(id: id);
  }
}
