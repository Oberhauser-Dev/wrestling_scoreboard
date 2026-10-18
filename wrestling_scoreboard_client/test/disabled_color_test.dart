import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrestling_scoreboard_client/utils/colors.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';

void main() {
  for (final theme in [ThemeData.light(), ThemeData.dark()]) {
    test('Disabled text is readable on the ${theme.brightness.name} theme background', () {
      final background = theme.colorScheme.surface;
      final disabledText = Color.alphaBlend(theme.colorScheme.onSurface.disabled(), background);
      expect(contrastRatio(disabledText, background), greaterThanOrEqualTo(minTextContrast));
    });
  }
}
