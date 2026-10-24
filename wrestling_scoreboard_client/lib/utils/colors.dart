import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

/// Creates a [MaterialColor] with [color] as shade 500, lightening the lower and darkening the higher shades.
/// If [mirrored], the higher shades are lightened and the lower shades darkened instead.
MaterialColor createMaterialColor(Color color, {bool mirrored = false}) {
  final strengths = <double>[.05];
  final Map<int, Color> swatch = {};
  final double r = color.r, g = color.g, b = color.b;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (final strength in strengths) {
    final double ds = mirrored ? strength - 0.5 : 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.from(
      red: r + ((ds < 0 ? r : (1 - r)) * ds),
      green: g + ((ds < 0 ? g : (1 - g)) * ds),
      blue: b + ((ds < 0 ? b : (1 - b)) * ds),
      alpha: 1,
    );
  }
  return MaterialColor(color.toARGB32(), swatch);
}

/// The contrast ratio of normal text according to WCAG AA.
const double minTextContrast = 4.5;

/// The contrast ratio between two colors according to WCAG, from 1 (none) to 21 (black and white).
double contrastRatio(Color a, Color b) {
  final luminanceA = a.computeLuminance();
  final luminanceB = b.computeLuminance();
  return (max(luminanceA, luminanceB) + 0.05) / (min(luminanceA, luminanceB) + 0.05);
}

/// A chroma above the highest one, which can be displayed (about 130 in sRGB).
const double _unlimitedChroma = 200;

/// Creates the color with the [tone] (perceptual lightness L* from 0 to 100) and the hue and chroma of the [color].
/// If [maxChroma], the highest chroma which can be displayed is used instead.
/// The chroma is reduced, if the combination cannot be displayed.
Color _withTone(Color color, double tone, {bool maxChroma = false}) {
  final hct = Hct.fromInt(color.toARGB32());
  return Color(Hct.from(hct.hue, maxChroma ? _unlimitedChroma : hct.chroma, tone).toInt());
}

/// The color of text in the color of [color] on the [background].
/// The [color] is kept, if it is already readable. Otherwise only its tone is adjusted as little as possible
/// via [contrastingColor], so it stays close to the [color].
Color textColorOf(Color color, Color background, {double minContrast = minTextContrast, bool maxChroma = false}) =>
    contrastingColor(color, background, minContrast: minContrast, maxChroma: maxChroma);

/// Adjusts the tone (perceptual lightness L*) of [color] while keeping its hue and chroma, so it just reaches the
/// [minContrast] to the [background]: it is darkened on a light background and lightened on a dark background
/// (whichever of black or white has the higher contrast to the [background]).
/// If [maxChroma], the adjusted color gets the highest chroma which can be displayed with its tone instead,
/// e.g. so a pale color does not result in a dull dark color.
/// The [color] is returned unchanged, if it already has enough contrast.
/// If the [minContrast] cannot be reached, the darkest or lightest color is returned.
Color contrastingColor(Color color, Color background, {double minContrast = minTextContrast, bool maxChroma = false}) {
  if (contrastRatio(color, background) >= minContrast) return color;
  // Darken, if black has more contrast to the background than white, otherwise lighten.
  final darken = contrastRatio(Colors.black, background) >= contrastRatio(Colors.white, background);
  // The tone is a closed-form function of the luminance, which determines the contrast.
  // So the tone with the required contrast can be calculated directly from the tone of the background.
  final backgroundTone = Hct.fromInt(background.toARGB32()).tone;
  final tone = darken
      ? Contrast.darkerUnsafe(tone: backgroundTone, ratio: minContrast)
      : Contrast.lighterUnsafe(tone: backgroundTone, ratio: minContrast);
  return _withTone(color, tone, maxChroma: maxChroma);
}
