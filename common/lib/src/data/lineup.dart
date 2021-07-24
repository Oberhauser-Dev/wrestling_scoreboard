import 'package:json_annotation/json_annotation.dart';

import 'data_object.dart';
import 'membership.dart';
import 'team.dart';

part 'lineup.g.dart';

/// The lineup for a team match or tournament.
@JsonSerializable()
class Lineup extends DataObject {
  Team team;
  Membership? leader; // Mannschaftsführer
  Membership? coach; // Trainer
  final int tier; // Rangordnung

  Lineup({int? id, required this.team, this.leader, this.coach, this.tier = 1}) : super(id);

  factory Lineup.fromJson(Map<String, dynamic> json) => _$LineupFromJson(json);

  Map<String, dynamic> toJson() => _$LineupToJson(this);
}
