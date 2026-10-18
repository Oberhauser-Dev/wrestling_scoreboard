import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:wrestling_scoreboard_client/utils/colors.dart';

Hct _hct(Color color) => Hct.fromInt(color.toARGB32());

void main() {
  group('contrastingColor', () {
    test('keeps a color with enough contrast', () {
      const darkRed = Color(0xFFB71C1C);
      expect(contrastingColor(darkRed, Colors.white), darkRed);
    });

    test('darkens a light color on a light background', () {
      const lightRed = Color(0xFFEF9A9A);
      final textColor = contrastingColor(lightRed, Colors.white);
      expect(contrastRatio(textColor, Colors.white), greaterThanOrEqualTo(minTextContrast));
      expect(_hct(textColor).tone, lessThan(_hct(lightRed).tone));
      expect(_hct(textColor).hue, closeTo(_hct(lightRed).hue, 2));
    });

    test('lightens a dark color on a dark background', () {
      const darkBlue = Color(0xFF0D1B4C);
      final textColor = contrastingColor(darkBlue, Colors.black);
      expect(contrastRatio(textColor, Colors.black), greaterThanOrEqualTo(minTextContrast));
      expect(_hct(textColor).tone, greaterThan(_hct(darkBlue).tone));
      expect(_hct(textColor).hue, closeTo(_hct(darkBlue).hue, 2));
    });

    test('changes the tone only as much as necessary', () {
      for (final (color, background) in [
        (const Color(0xFFEF9A9A), Colors.white),
        (const Color(0xFF0D1B4C), Colors.black),
      ]) {
        final textColor = contrastingColor(color, background);
        expect(contrastRatio(textColor, background), greaterThanOrEqualTo(minTextContrast));
        // A slightly smaller change of the tone does not reach the contrast anymore.
        final hct = _hct(textColor);
        final lessChanged = Hct.from(hct.hue, hct.chroma, hct.tone + (hct.tone < _hct(color).tone ? 1 : -1));
        expect(contrastRatio(Color(lessChanged.toInt()), background), lessThan(minTextContrast));
      }
    });

    test('uses the highest possible chroma, if requested', () {
      const lightRed = Color(0xFFEF9A9A);
      final keptChroma = _hct(contrastingColor(lightRed, Colors.white));
      final maxChroma = _hct(contrastingColor(lightRed, Colors.white, maxChroma: true));
      expect(contrastRatio(Color(maxChroma.toInt()), Colors.white), greaterThanOrEqualTo(minTextContrast));
      // Same hue and tone, but more colorful.
      expect(maxChroma.hue, closeTo(keptChroma.hue, 2));
      expect(maxChroma.tone, closeTo(keptChroma.tone, 0.5));
      expect(maxChroma.chroma, greaterThan(keptChroma.chroma + 10));
    });

    test('keeps a readable color unchanged, even if the highest chroma is requested', () {
      const darkRed = Color(0xFFB71C1C);
      expect(contrastingColor(darkRed, Colors.white, maxChroma: true), darkRed);
    });

    test('darkens on a mid grey background, where black has more contrast than white', () {
      // The brightness of this background is estimated as dark, but white only has a contrast of about 3.4 to it,
      // while black has about 6.2.
      const background = Color(0xFF8C8C8C);
      final textColor = contrastingColor(const Color(0xFF999999), background);
      expect(contrastRatio(textColor, background), greaterThanOrEqualTo(minTextContrast));
      expect(_hct(textColor).tone, lessThan(_hct(background).tone));
    });

    test('returns the most contrasting tone, if the contrast cannot be reached', () {
      // Black has a contrast of about 5.3 to this background, which is the maximum.
      const background = Color(0xFF808080);
      final textColor = contrastingColor(const Color(0xFF606060), background, minContrast: 10);
      expect(textColor.toARGB32(), Colors.black.toARGB32());
    });
  });

  group('textColorOf', () {
    test('keeps a readable color', () {
      // Has a contrast of about 5 on the dark theme surface.
      expect(textColorOf(Colors.red, const Color(0xFF141218)), Colors.red);
    });

    test('adjusts the tone of an unreadable color as little as possible', () {
      const lightRed = Color(0xFFEF9A9A);
      final textColor = textColorOf(lightRed, Colors.white);
      expect(textColor, contrastingColor(lightRed, Colors.white));
      expect(contrastRatio(textColor, Colors.white), greaterThanOrEqualTo(minTextContrast));
      expect(_hct(textColor).hue, closeTo(_hct(lightRed).hue, 2));
    });
  });

  test('RoleColors.fromBase derives readable text colors', () {
    for (final background in [ThemeData.light().colorScheme.surface, ThemeData.dark().colorScheme.surface]) {
      final roleColors = RoleColors.fromBase(red: const Color(0xFF7F0000), blue: null, background: background);
      expect(contrastRatio(roleColors.redText, background), greaterThanOrEqualTo(minTextContrast));
      expect(contrastRatio(roleColors.blueText, background), greaterThanOrEqualTo(minTextContrast));
      // The background colors are not changed.
      expect(roleColors.red.toARGB32(), 0xFF7F0000);
      expect(roleColors.blue, RoleColors.defaultBlue);
    }
  });

  test('Presets contain pure red and blue', () {
    expect(RoleColors.redSwatches.keys.map((swatch) => swatch.toARGB32()), contains(0xFFFF0000));
    expect(RoleColors.blueSwatches.keys.map((swatch) => swatch.toARGB32()), contains(0xFF0000FF));
  });
}
