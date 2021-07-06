import 'package:common/src/data/data_object.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';

import 'wrestling_style.dart';

part 'weight_class.g.dart';

@JsonSerializable()
class WeightClass extends DataObject {
  late final String name;
  final int weight;
  final WrestlingStyle style;

  WeightClass(this.weight, this.style, {int? id, String? name, String weightUnit = 'kg'}) : super(id) {
    this.name = name ?? this.weight.toString() + ' ' + weightUnit;
  }

  factory WeightClass.fromJson(Map<String, dynamic> json) => _$WeightClassFromJson(json);

  Map<String, dynamic> toJson() => _$WeightClassToJson(this);

  bool operator ==(o) => o is WeightClass && name == o.name && weight == o.weight;

  int get hashCode => hash2(name.hashCode, weight.hashCode);
}
