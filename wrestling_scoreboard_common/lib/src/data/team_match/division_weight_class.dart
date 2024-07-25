import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'division_weight_class.freezed.dart';
part 'division_weight_class.g.dart';

@freezed
class DivisionWeightClass with _$DivisionWeightClass implements DataObject {
  const DivisionWeightClass._();

  /// The [seasonPartition] is started counting at 0.
  const factory DivisionWeightClass({
    int? id,
    required int pos,
    required Division division,
    required WeightClass weightClass,
    int? seasonPartition,
  }) = _DivisionWeightClass;

  factory DivisionWeightClass.fromJson(Map<String, Object?> json) => _$DivisionWeightClassFromJson(json);

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'pos': pos,
      'division_id': division.id!,
      'weight_class_id': weightClass.id!,
      'season_partition': seasonPartition,
    };
  }

  static Future<DivisionWeightClass> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async =>
      DivisionWeightClass(
        id: e['id'] as int?,
        division: (await getSingle<Division>(e['division_id'] as int)),
        weightClass: (await getSingle<WeightClass>(e['weight_class_id'] as int)),
        pos: e['pos'] as int,
        seasonPartition: e['season_partition'] as int?,
      );

  @override
  String get tableName => 'division_weight_class';

  @override
  DivisionWeightClass copyWithId(int? id) {
    return copyWith(id: id);
  }
}
