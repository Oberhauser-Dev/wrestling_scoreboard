import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'scratch_bout.freezed.dart';
part 'scratch_bout.g.dart';

@freezed
abstract class ScratchBout with _$ScratchBout implements DataObject {
  const ScratchBout._();

  const factory ScratchBout({
    int? id,
    required Bout bout,
    required WeightClass weightClass,
    required BoutConfig boutConfig,
  }) = _ScratchBout;

  factory ScratchBout.fromJson(Map<String, Object?> json) => _$ScratchBoutFromJson(json);

  static Future<ScratchBout> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final bout = await getSingle<Bout>(e['bout_id'] as int);
    final weightClass = await getSingle<WeightClass>(e['weight_class_id'] as int);
    final boutConfig = await getSingle<BoutConfig>(e['bout_config_id'] as int);

    return ScratchBout(id: e['id'] as int?, bout: bout, weightClass: weightClass, boutConfig: boutConfig);
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'bout_id': bout.id!,
      'weight_class_id': weightClass.id,
      'bout_config_id': boutConfig.id,
    };
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'scratch_bout';

  @override
  ScratchBout copyWithId(int? id) {
    return copyWith(id: id);
  }
}
