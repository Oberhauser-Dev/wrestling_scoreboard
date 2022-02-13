import 'package:json_annotation/json_annotation.dart';

import '../bout_config.dart';
import '../data_object.dart';
import '../fight.dart';
import '../participation.dart';
import '../weight_class.dart';
import '../wrestling_event.dart';

part 'tournament.g.dart';

/// For team matches only.
@JsonSerializable()
class Tournament extends WrestlingEvent {
  final String name;
  final BoutConfig boutConfig;

  Tournament({
    int? id,
    required this.name,
    required this.boutConfig,
    String? location,
    DateTime? date,
    int? visitorsCount,
    String? comment,
  }) : super(
          id: id,
          location: location,
          date: date,
          comment: comment,
          visitorsCount: visitorsCount,
        );

  factory Tournament.fromJson(Map<String, dynamic> json) => _$TournamentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TournamentToJson(this);

  static Future<Tournament> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final boutConfig = await getSingle<BoutConfig>(e['bout_config_id'] as int);
    // TODO fetch lineups, referees, weightClasses, etc.
    return Tournament(
      id: e['id'] as int?,
      name: e['name'],
      location: e['location'] as String?,
      date: e['date'] as DateTime?,
      visitorsCount: e['visitors_count'] as int?,
      comment: e['comment'] as String?,
      boutConfig: boutConfig!,
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
  Future<List<Fight>> generateFights(List<List<Participation>> teamParticipations, List<WeightClass> weightClasses) {
    // TODO: implement generateFights
    throw UnimplementedError();
  }
}
