import 'package:flutter/services.dart';

class NumericalRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  const NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    newValue = newValue.copyWith(text: newValue.text.replaceAll(',', '.'));
    if (newValue.text.isEmpty) return newValue;
    final parsed = double.tryParse(newValue.text);
    if (parsed == null) {
      return const TextEditingValue().copyWith(text: oldValue.text);
    } else if (parsed < min) {
      return const TextEditingValue().copyWith(text: min.toStringAsFixed(2));
    } else {
      return parsed > max ? oldValue : newValue;
    }
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
