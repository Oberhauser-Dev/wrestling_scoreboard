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

/// The colors of the red and blue corner (and home and guest team) in the UI.
/// Reports are not affected, as they use their own colors.
class RoleColors extends ThemeExtension<RoleColors> {
  /// The default base color of the red corner in the theme with the [brightness], both with white text:
  /// a vivid red with the highest chroma and a contrast of 5.0 in the light theme,
  /// and the darker Material red 800 with a contrast of more than 5.5 in the dark theme.
  static Color defaultRedOf(Brightness brightness) =>
      brightness == Brightness.light ? const Color(0xFFDF000D) : const Color(0xFFC62828);

  /// The default base color of the blue corner in the theme with the [brightness], both with white text:
  /// a vivid blue with the highest chroma and a contrast of 5.0 in the light theme,
  /// and the darker Material blue 800 with a contrast of more than 5.5 in the dark theme.
  static Color defaultBlueOf(Brightness brightness) =>
      brightness == Brightness.light ? const Color(0xFF0072BE) : const Color(0xFF1565C0);

  /// Warm color swatches to select the base color of the red corner from in the theme with the [brightness],
  /// with their names. The default color of the theme comes first.
  static Map<ColorSwatch<Object>, String> redSwatchesOf(Brightness brightness) => _redSwatchesOf[brightness]!;

  /// Cold color swatches to select the base color of the blue corner from in the theme with the [brightness],
  /// with their names. The default color of the theme comes first.
  static Map<ColorSwatch<Object>, String> blueSwatchesOf(Brightness brightness) => _blueSwatchesOf[brightness]!;

  // Created once, as the color picker resets, when it gets other swatches.
  static final Map<Brightness, Map<ColorSwatch<Object>, String>> _redSwatchesOf = {
    for (final brightness in Brightness.values)
      brightness: {swatchOf(defaultRedOf(brightness)): 'Default red', ..._redSwatches},
  };

  static final Map<Brightness, Map<ColorSwatch<Object>, String>> _blueSwatchesOf = {
    for (final brightness in Brightness.values)
      brightness: {swatchOf(defaultBlueOf(brightness)): 'Default blue', ..._blueSwatches},
  };

  static final Map<ColorSwatch<Object>, String> _redSwatches = {
    Colors.red: 'Red',
    createMaterialColor(const Color(0xFFFF0000)): 'Pure red',
    Colors.redAccent: 'Red accent',
    Colors.pink: 'Pink',
    Colors.deepOrange: 'Deep orange',
    Colors.orange: 'Orange',
    Colors.amber: 'Amber',
    Colors.yellow: 'Yellow',
  };

  static final Map<ColorSwatch<Object>, String> _blueSwatches = {
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

  /// Creates the shades of a base [color]. The emphasized (higher) shades of a light color are lighter,
  /// so they keep the dark text, while those of a dark color are darker.
  static MaterialColor swatchOf(Color color) =>
      createMaterialColor(color, mirrored: ThemeData.estimateBrightnessForColor(color) == Brightness.light);

  final MaterialColor red;
  final MaterialColor blue;

  /// The color of red text on the theme background, e.g. a name of the red corner.
  final Color redText;

  /// The color of blue text on the theme background, e.g. a name of the blue corner.
  final Color blueText;

  const RoleColors({required this.red, required this.blue, required this.redText, required this.blueText});

  /// Creates the role colors of the theme with the [brightness] from the base colors,
  /// which are the default colors if null.
  /// The text colors are derived from the base colors, so they are readable on the [background], see [textColorOf].
  /// In the light theme, they get the highest possible chroma, as the usually pale base colors
  /// would otherwise result in dull dark text colors.
  factory RoleColors.fromBase({Color? red, Color? blue, required Brightness brightness, required Color background}) {
    final redSwatch = swatchOf(red ?? defaultRedOf(brightness));
    final blueSwatch = swatchOf(blue ?? defaultBlueOf(brightness));
    final maxChroma = brightness == Brightness.light;
    return RoleColors(
      red: redSwatch,
      blue: blueSwatch,
      redText: textColorOf(redSwatch, background, maxChroma: maxChroma),
      blueText: textColorOf(blueSwatch, background, maxChroma: maxChroma),
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
  RoleColors get roleColors {
    final theme = Theme.of(this);
    return theme.extension<RoleColors>() ??
        RoleColors.fromBase(brightness: theme.brightness, background: theme.colorScheme.surface);
  }
}
