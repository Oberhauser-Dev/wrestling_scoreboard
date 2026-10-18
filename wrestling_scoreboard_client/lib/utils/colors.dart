import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

const MaterialColor white = MaterialColor(0xFFFFFFFF, <int, Color>{
  50: Colors.white10,
  100: Colors.white24,
  200: Colors.white38,
  300: Colors.white54,
  400: Colors.white70,
  500: Colors.white,
  600: Colors.white,
  700: Colors.white,
  800: Colors.white,
  900: Colors.white,
});

/// Creates a [MaterialColor] with [color] as shade 500, lightening the lower and darkening the higher shades.
MaterialColor createMaterialColor(Color color) {
  final strengths = <double>[.05];
  final Map<int, Color> swatch = {};
  final double r = color.r, g = color.g, b = color.b;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (final strength in strengths) {
    final double ds = 0.5 - strength;
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

/// The colors of the red and blue corner (and home and guest team) in the UI.
/// Reports are not affected, as they use their own colors.
class RoleColors extends ThemeExtension<RoleColors> {
  static const defaultRed = Colors.red;
  static const defaultBlue = Colors.blue;

  /// Warm color swatches to select the base color of the red corner from, with their names.
  static final Map<ColorSwatch<Object>, String> redSwatches = {
    Colors.red: 'Red',
    createMaterialColor(const Color(0xFFFF0000)): 'Pure red',
    Colors.redAccent: 'Red accent',
    Colors.pink: 'Pink',
    Colors.deepOrange: 'Deep orange',
    Colors.orange: 'Orange',
    Colors.amber: 'Amber',
    Colors.yellow: 'Yellow',
  };

  /// Cold color swatches to select the base color of the blue corner from, with their names.
  static final Map<ColorSwatch<Object>, String> blueSwatches = {
    Colors.blue: 'Blue',
    createMaterialColor(const Color(0xFF0000FF)): 'Pure blue',
    Colors.blueAccent: 'Blue accent',
    Colors.lightBlue: 'Light blue',
    Colors.indigo: 'Indigo',
    Colors.deepPurple: 'Deep purple',
    Colors.cyan: 'Cyan',
    Colors.teal: 'Teal',
    Colors.green: 'Green',
  };

  final MaterialColor red;
  final MaterialColor blue;

  /// The color of red text on the theme background, e.g. a name of the red corner.
  final Color redText;

  /// The color of blue text on the theme background, e.g. a name of the blue corner.
  final Color blueText;

  const RoleColors({
    this.red = defaultRed,
    this.blue = defaultBlue,
    this.redText = defaultRed,
    this.blueText = defaultBlue,
  });

  /// Creates the role colors from the base colors, which is the default color if null.
  /// The text colors are derived from the base colors, so they are readable on the [background], see [textColorOf].
  factory RoleColors.fromBase({Color? red, Color? blue, required Color background}) {
    final redSwatch = red == null ? defaultRed : createMaterialColor(red);
    final blueSwatch = blue == null ? defaultBlue : createMaterialColor(blue);
    return RoleColors(
      red: redSwatch,
      blue: blueSwatch,
      redText: textColorOf(redSwatch, background),
      blueText: textColorOf(blueSwatch, background),
    );
  }

  @override
  RoleColors copyWith({MaterialColor? red, MaterialColor? blue, Color? redText, Color? blueText}) {
    return RoleColors(
      red: red ?? this.red,
      blue: blue ?? this.blue,
      redText: redText ?? this.redText,
      blueText: blueText ?? this.blueText,
    );
  }

  @override
  RoleColors lerp(covariant RoleColors? other, double t) {
    // MaterialColors cannot be interpolated, so switch at the half.
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }
}

extension RoleColorsContext on BuildContext {
  RoleColors get roleColors => Theme.of(this).extension<RoleColors>() ?? const RoleColors();
}
