import 'package:quiver/core.dart';
import 'package:wrestling_scoreboard/util/units.dart';

import 'wrestling_style.dart';

class WeightClass {
  late final String name;
  final int weight;
  final WrestlingStyle style;

  WeightClass(this.weight, this.style, {String? name}) {
    this.name = name ?? this.weight.toString() + ' ' + weightUnit;
  }

  bool operator ==(o) => o is WeightClass && name == o.name && weight == o.weight;

  int get hashCode => hash2(name.hashCode, weight.hashCode);
}
