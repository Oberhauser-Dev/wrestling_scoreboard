import 'package:common/src/data/data_object.dart';
import 'package:json_annotation/json_annotation.dart';

import 'participant_status.dart';
import 'person.dart';
import 'team.dart';

part 'lineup.g.dart';

@JsonSerializable()
class Lineup extends DataObject {
  final Team team;
  final Person? leader; // Mannschaftsführer
  final Person? coach; // Trainer
  final List<ParticipantStatus> participantStatusList;
  int tier; // Rangordnung

  Lineup({int? id, required this.team, required this.participantStatusList, this.leader, this.coach, this.tier = 1})
      : super(id);

  factory Lineup.fromJson(Map<String, dynamic> json) => _$LineupFromJson(json);

  Map<String, dynamic> toJson() => _$LineupToJson(this);
}
