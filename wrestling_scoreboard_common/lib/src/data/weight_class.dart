import 'package:json_annotation/json_annotation.dart';

import '../enums/weight_unit.dart';
import '../enums/wrestling_style.dart';
import 'data_object.dart';

part 'weight_class.g.dart';

@JsonSerializable()
class WeightClass extends DataObject {
  final String? suffix;
  final int weight;
  final WrestlingStyle style;
  final WeightUnit unit;

  WeightClass({int? id, required this.weight, required this.style, this.suffix, this.unit = WeightUnit.kilogram})
      : super(id);

  String get name => [weight.toString(), unit.toAbbr(), if (suffix != null && suffix!.isNotEmpty) suffix].join(' ');

  factory WeightClass.fromJson(Map<String, dynamic> json) => _$WeightClassFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WeightClassToJson(this);

  static Future<WeightClass> fromRaw(Map<String, dynamic> e) async => WeightClass(
        id: e['id'] as int?,
        suffix: e['suffix'] as String?,
        weight: e['weight'] as int,
        unit: WeightUnitParser.valueOf(e['unit']),
        style: WrestlingStyleParser.valueOf(e['style']),
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
  bool operator ==(other) =>
      other is WeightClass &&
      suffix == other.suffix &&
      weight == other.weight &&
      style == other.style &&
      unit == other.unit;

  @override
  int get hashCode => Object.hash(suffix, weight, style, unit);
}
