import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/theme/role_colors.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';

/// Lets the user select a base color, from which the shades are derived.
/// A null color represents the [defaultColor].
/// The color can be selected from the shades of the [swatches], or freely from a color wheel.
Future<void> showColorDialog({
  required BuildContext context,
  required Color? initialColor,
  required Color defaultColor,
  required Map<ColorSwatch<Object>, String> swatches,
  Widget? title,
  required void Function(Color? color) onSelect,
}) async {
  final result = await showDialog<(Color?,)>(
    context: context,
    builder: (context) =>
        ColorDialog(initialColor: initialColor, defaultColor: defaultColor, swatches: swatches, title: title),
  );
  if (result != null) onSelect(result.$1);
}

class ColorDialog extends StatefulWidget {
  final Color? initialColor;
  final Color defaultColor;

  /// The color swatches with their names, whose shades can be selected.
  final Map<ColorSwatch<Object>, String> swatches;
  final Widget? title;

  const ColorDialog({
    required this.initialColor,
    required this.defaultColor,
    required this.swatches,
    this.title,
    super.key,
  });

  @override
  State<ColorDialog> createState() => _ColorDialogState();
}

class _ColorDialogState extends State<ColorDialog> {
  Color? _color;

  @override
  void initState() {
    super.initState();
    _color = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final materialColor = RoleColors.swatchOf(_color ?? widget.defaultColor);
    return OkCancelDialog<(Color?,)>(
      title: widget.title,
      getResult: () => (_color,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ColorPicker(
            color: _color ?? widget.defaultColor,
            onColorChanged: (color) => setState(() => _color = color),
            padding: EdgeInsets.zero,
            width: 36,
            height: 36,
            borderRadius: 18,
            wheelDiameter: 220,
            // Primary and accent are shown, if not explicitly disabled.
            pickersEnabled: const {
              ColorPickerType.primary: false,
              ColorPickerType.accent: false,
              ColorPickerType.custom: true,
              ColorPickerType.wheel: true,
            },
            customColorSwatchesAndNames: widget.swatches,
            pickerTypeLabels: {
              ColorPickerType.custom: localizations.colorPresets,
              ColorPickerType.wheel: localizations.customColor,
            },
            // Label the shades of the selected color, so they are not mistaken for further colors.
            subheading: Text(localizations.colorShade, style: Theme.of(context).textTheme.labelLarge),
            wheelSubheading: Text(localizations.colorShade, style: Theme.of(context).textTheme.labelLarge),
            showColorCode: true,
            colorCodeHasColor: true,
            copyPasteBehavior: const ColorPickerCopyPasteBehavior(longPressMenu: true),
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: _color == null ? null : () => setState(() => _color = null),
              icon: const Icon(Icons.restart_alt),
              label: Text(localizations.reset),
            ),
          ),
          Text(localizations.preview),
          const SizedBox(height: 8),
          // Preview the derived shades with their text color, as used on the scoreboard.
          Row(
            children: [500, 800, 900]
                .map(
                  (shade) => Expanded(
                    child: ThemedContainer(
                      color: materialColor[shade],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Center(
                        child: Text('12', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
