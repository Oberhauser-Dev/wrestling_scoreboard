/// The unit of weight.
enum WeightUnit {
  kilogram,
  pound;

  String toAbbr() {
    if (this == WeightUnit.pound) return 'lb';
    return 'kg';
  }
}
