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

  @override
  Map<String, dynamic> toJson() => _$ParticipationToJson(this);

  static Future<Participation> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final weightClass = await getSingle<WeightClass>(e['weight_class_id'] as int);
    final lineup = await getSingle<Lineup>(e['lineup_id'] as int);
    final membership = await getSingle<Membership>(e['membership_id'] as int);
    final weightEncoded = e['weight'];
    double? weight;
    if (weightEncoded != null) {
      weight = double.parse(weightEncoded);
    }

    return Participation(
      id: e['id'] as int?,
      weightClass: weightClass!,
      lineup: lineup!,
      membership: membership!,
      weight: weight,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'weight_class_id': weightClass.id,
      'lineup_id': lineup.id,
      'membership_id': membership.id,
      'weight': weight?.toString(),
    };
  }
}
