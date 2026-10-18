import 'package:flutter/material.dart';

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

  const RoleColors({this.red = defaultRed, this.blue = defaultBlue});

  /// Creates the role colors from the base colors, which is the default color if null.
  factory RoleColors.fromBase({Color? red, Color? blue}) {
    return RoleColors(
      red: red == null ? defaultRed : createMaterialColor(red),
      blue: blue == null ? defaultBlue : createMaterialColor(blue),
    );
  }

  @override
  RoleColors copyWith({MaterialColor? red, MaterialColor? blue}) {
    return RoleColors(red: red ?? this.red, blue: blue ?? this.blue);
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
