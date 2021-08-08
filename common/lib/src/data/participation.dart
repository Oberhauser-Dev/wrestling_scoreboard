import 'package:json_annotation/json_annotation.dart';

import 'data_object.dart';
import 'lineup.dart';
import 'membership.dart';
import 'weight_class.dart';

part 'participation.g.dart';

/// The participation of a person (member) on a team match or tournament through the teams lineup.
/// A person can participate in multiple weight classes, if wanted. But they only have to weight once.
@JsonSerializable()
class Participation extends DataObject {
  Membership membership;
  Lineup lineup;
  final WeightClass weightClass;
  double? weight;

  Participation({
    int? id,
    required this.membership,
    required this.lineup,
    required this.weightClass,
    this.weight,
  }) : super(id);

  factory Participation.fromJson(Map<String, dynamic> json) => _$ParticipationFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipationToJson(this);
}
