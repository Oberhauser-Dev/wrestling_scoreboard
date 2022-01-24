import 'package:json_annotation/json_annotation.dart';

import '../fight.dart';
import '../participation.dart';
import '../weight_class.dart';
import '../wrestling_event.dart';

part 'tournament.g.dart';

/// For team matches only.
@JsonSerializable()
class Tournament extends WrestlingEvent {
  final String name;

  @override
  Duration roundDuration = Duration(minutes: 3);

  @override
  Duration breakDuration = Duration(seconds: 30);

  @override
  Duration activityDuration = Duration(seconds: 30);

  @override
  Duration injuryDuration = Duration(seconds: 30);

  @override
  int maxRounds = 2;

  Tournament({
    int? id,
    required this.name,
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

  static Future<Tournament> fromRaw(Map<String, dynamic> e) async {
    // TODO fetch lineups, referees, weightClasses, etc.
    return Tournament(
      id: e['id'] as int?,
      name: e['name'],
      location: e['location'] as String?,
      date: e['date'] as DateTime?,
      visitorsCount: e['visitors_count'] as int?,
      comment: e['comment'] as String?,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return super.toRaw()
      ..addAll({
        if (id != null) 'id': id,
        'name': name,
      });
  }

  @override
  Future<List<Fight>> generateFights(List<List<Participation>> teamParticipations, List<WeightClass> weightClasses) {
    // TODO: implement generateFights
    throw UnimplementedError();
  }
}
