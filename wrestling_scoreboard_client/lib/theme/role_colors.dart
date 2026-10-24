import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/utils/colors.dart';

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
