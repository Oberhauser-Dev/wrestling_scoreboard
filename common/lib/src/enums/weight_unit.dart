/// The unit of weight.
enum WeightUnit {
  kilogram,
  pound,
}

extension WeightUnitParser on WeightUnit {
  String get name => toString().split('.').last;

  static WeightUnit valueOf(String name) => WeightUnit.values.singleWhere((element) => element.name == name);

  String toAbbr() {
    if (this == WeightUnit.pound) return 'lb';
    return 'kg';
  }
}
