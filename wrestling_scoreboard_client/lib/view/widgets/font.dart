import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';

class HeadingText extends StatelessWidget {
  final String heading;

  const HeadingText(this.heading, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10, top: 20),
      child: Text(heading.toUpperCase(), style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

class AutoTextScaler extends TextScaler {
  @override
  final double textScaleFactor;
  final double minFontSize;
  final double maxFontSize;

  const AutoTextScaler({this.textScaleFactor = 1, this.minFontSize = 0, this.maxFontSize = double.infinity});

  @override
  double scale(double fontSize) {
    fontSize = fontSize * textScaleFactor;
    return clampDouble(fontSize, minFontSize, maxFontSize);
  }
}

class Font {
  static final List<String> supportedFontFamilies = GoogleFonts.asMap().keys.toList();

  static TextStyle? getStyleOfFamily({required String? fontFamily, required TextTheme textTheme}) {
    if (fontFamily == null) return null;
    return GoogleFonts.getTextTheme(fontFamily, textTheme).headlineMedium;
  }

  static Widget buildStyledEntry(BuildContext context, {required String? fontFamily}) {
    final currentTextTheme = Theme.of(context).textTheme;
    final fontStyle =
        Font.getStyleOfFamily(textTheme: currentTextTheme, fontFamily: fontFamily) ??
        currentTextTheme.apply(fontFamily: Typography.material2021().white.headlineMedium?.fontFamily).headlineMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(fontFamily ?? context.l10n.systemFont, style: fontStyle)),
        IconButton(
          onPressed: () => showOkDialog(
            context: context,
            child: Text('ABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwxyz', style: fontStyle),
          ),
          icon: const Icon(Icons.abc),
        ),
      ],
    );
  }

  static Future<void> showFontDialog(
    BuildContext context, {
    String? initialFontFamily,
    Iterable<String>? supportedFontFamilies,
    required void Function(String? fontFamily) onSelect,
  }) async {
    final List<String?> fontFamilies = [null];
    fontFamilies.addAll(supportedFontFamilies ?? Font.supportedFontFamilies);
    await showRadioDialog<String?>(
      context: context,
      initialValue: initialFontFamily,
      shrinkWrap: false,
      itemCount: fontFamilies.length,
      itemBuilder: (index) {
        final fontFamily = fontFamilies[index];
        return (fontFamily, Font.buildStyledEntry(context, fontFamily: fontFamily));
      },
      onSuccess: onSelect,
    );
  }
}
