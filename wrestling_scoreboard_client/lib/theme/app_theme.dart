import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wrestling_scoreboard_client/theme/emphasis_opacities.dart';
import 'package:wrestling_scoreboard_client/theme/role_colors.dart';
import 'package:wrestling_scoreboard_client/utils/colors.dart';

final MaterialColor _primaryColor = createMaterialColor(Colors.blue); // const Color.fromARGB(255, 180, 0, 10)

/// Builds the theme with the base colors of the red and blue corner, which are the default colors if null.
/// The text colors are black or white with the opacity of their emphasis, see [EmphasisOpacities].
/// If [highContrast] is true, their opacity is increased and the background is pure white or black.
ThemeData buildTheme(
  Brightness brightness,
  String? fontFamily,
  (Color?, Color?) roleBaseColors, {
  bool highContrast = false,
}) {
  final isLight = brightness == Brightness.light;
  var theme = isLight ? ThemeData.light() : ThemeData.dark();
  final textColor = isLight ? Colors.black : Colors.white;
  final emphasis = highContrast ? EmphasisOpacities.highContrast : EmphasisOpacities.standard;
  final onSurface = emphasis.onSurface(textColor);
  final surface = highContrast ? (isLight ? Colors.white : Colors.black) : null;
  theme = theme.copyWith(
    colorScheme: theme.colorScheme.copyWith(
      primary: _primaryColor,
      secondary: isLight ? _primaryColor.shade800 : _primaryColor.shade300,
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: emphasis.onSurfaceVariant(textColor),
    ),
    scaffoldBackgroundColor: surface,
    canvasColor: surface,
    disabledColor: emphasis.disabled(textColor),
    textTheme: theme.textTheme.apply(bodyColor: onSurface, displayColor: onSurface),
  );
  final (red, blue) = roleBaseColors;
  theme = theme.copyWith(
    extensions: [
      RoleColors.fromBase(red: red, blue: blue, brightness: brightness, background: theme.colorScheme.surface),
      emphasis,
    ],
  );
  if (fontFamily != null) {
    return theme.copyWith(textTheme: GoogleFonts.getTextTheme(fontFamily, theme.textTheme));
  }
  return theme;
}
