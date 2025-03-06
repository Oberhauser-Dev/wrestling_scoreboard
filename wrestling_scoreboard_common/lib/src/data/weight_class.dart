import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'weight_class.freezed.dart';
part 'weight_class.g.dart';

@freezed
abstract class WeightClass with _$WeightClass implements DataObject {
  const WeightClass._();

  const factory WeightClass({
    int? id,
    required int weight,
    required WrestlingStyle style,
    String? suffix,
    @Default(WeightUnit.kilogram) WeightUnit unit,
  }) = _WeightClass;

  factory WeightClass.fromJson(Map<String, Object?> json) => _$WeightClassFromJson(json);

  String get name => [weight.toString(), unit.toAbbr(), if (suffix != null && suffix!.isNotEmpty) suffix].join(' ');

  static Future<WeightClass> fromRaw(Map<String, dynamic> e) async => WeightClass(
        id: e['id'] as int?,
        suffix: e['suffix'] as String?,
        weight: e['weight'] as int,
        unit: WeightUnit.values.byName(e['unit']),
        style: WrestlingStyle.values.byName(e['style']),
      );

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'suffix': suffix,
      'weight': weight,
      'unit': unit.name,
      'style': style.name,
    };
  }

  @override
  String get tableName => 'weight_class';

  // TODO: check if needed, with freezed serialization
  @override
  bool operator ==(other) =>
      other is WeightClass &&
      suffix == other.suffix &&
      weight == other.weight &&
      style == other.style &&
      unit == other.unit;

  @override
  int get hashCode => Object.hash(suffix, weight, style, unit);

  @override
  WeightClass copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Set<String> searchableAttributes = {
    'weight',
    'suffix',
  };
}
