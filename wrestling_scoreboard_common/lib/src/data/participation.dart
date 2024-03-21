import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'participation.freezed.dart';
part 'participation.g.dart';

/// The participation of a person (member) on a team match or competition through the teams lineup.
/// A person can participate in multiple weight classes, if wanted. But they only have to weight once.
@freezed
class Participation with _$Participation implements DataObject {
  const Participation._();

  const factory Participation({
    int? id,
    required Membership membership,
    required Lineup lineup,
    WeightClass? weightClass,
    double? weight,
  }) = _Participation;

  factory Participation.fromJson(Map<String, Object?> json) => _$ParticipationFromJson(json);

  static Future<Participation> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final weightClassId = e['weight_class_id'] as int?;
    final lineup = await getSingle<Lineup>(e['lineup_id'] as int);
    final membership = await getSingle<Membership>(e['membership_id'] as int);
    final weightEncoded = e['weight'];
    double? weight;
    if (weightEncoded != null) {
      weight = double.parse(weightEncoded);
    }

    return Participation(
      id: e['id'] as int?,
      weightClass: weightClassId == null ? null : await getSingle<WeightClass>(weightClassId),
      lineup: lineup,
      membership: membership,
      weight: weight,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'weight_class_id': weightClass?.id,
      'lineup_id': lineup.id,
      'membership_id': membership.id,
      'weight': weight?.toString(),
    };
  }

  @override
  String get tableName => 'participation';

  @override
  Participation copyWithId(int? id) {
    return copyWith(id: id);
  }

  @override
  String? get orgSyncId => throw UnimplementedError();

  @override
  Organization? get organization => throw UnimplementedError();
}
