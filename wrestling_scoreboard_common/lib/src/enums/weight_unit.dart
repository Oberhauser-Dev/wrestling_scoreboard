/// The unit of weight.
enum WeightUnit {
  kilogram,
  pound;

  String get name => toString().split('.').last;

  String toAbbr() {
    if (this == WeightUnit.pound) return 'lb';
    return 'kg';
  }
}
