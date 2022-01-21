import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';

import '../enums/wrestling_style.dart';
import 'data_object.dart';

part 'weight_class.g.dart';

@JsonSerializable()
class WeightClass extends DataObject {
  late final String name;
  final int weight;
  final WrestlingStyle style;

  WeightClass({int? id, required this.weight, required this.style, String? name, String weightUnit = 'kg'})
      : super(id) {
    this.name = name ?? this.weight.toString() + ' ' + weightUnit;
  }

  factory WeightClass.fromJson(Map<String, dynamic> json) => _$WeightClassFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WeightClassToJson(this);

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'weight': weight,
      'style': style.name,
    };
  }
  
  @override
  bool operator ==(o) => o is WeightClass && name == o.name && weight == o.weight && style == o.style;

  @override
  int get hashCode => hash3(name.hashCode, weight.hashCode, style.hashCode);
}
