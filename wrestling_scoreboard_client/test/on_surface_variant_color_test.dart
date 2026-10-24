import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrestling_scoreboard_client/theme/emphasis_opacities.dart';
import 'package:wrestling_scoreboard_client/utils/colors.dart';

void main() {
  for (final theme in [ThemeData.light(), ThemeData.dark()]) {
    final textColor = theme.brightness == Brightness.light ? Colors.black : Colors.white;
    for (final highContrast in [false, true]) {
      final background = highContrast
          ? (theme.brightness == Brightness.light ? Colors.white : Colors.black)
          : theme.colorScheme.surface;
      final description = '${theme.brightness.name} theme background${highContrast ? ' in high contrast mode' : ''}';
      test('Medium emphasis text is readable on the $description', () {
        final text = Color.alphaBlend(
          (highContrast ? EmphasisOpacities.highContrast : EmphasisOpacities.standard).onSurfaceVariant(textColor),
          background,
        );
        expect(contrastRatio(text, background), greaterThanOrEqualTo(minTextContrast));
      });
    }
  }
}
