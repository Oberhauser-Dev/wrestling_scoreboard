import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrestling_scoreboard_client/l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/utils/colors.dart';
import 'package:wrestling_scoreboard_client/view/widgets/color.dart';

void main() {
  // Fail on taps, which miss their widget, e.g. because it is scrolled out of view.
  setUp(() => WidgetController.hitTestWarningShouldBeFatal = true);
  tearDown(() => WidgetController.hitTestWarningShouldBeFatal = false);

  Future<void> openDialog(WidgetTester tester, {Color? initialColor, required void Function(Color?) onSelect}) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showColorDialog(
              context: context,
              initialColor: initialColor,
              defaultColor: Colors.red,
              swatches: RoleColors.redSwatches,
              onSelect: onSelect,
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('Selects a color from the picker', (WidgetTester tester) async {
    Color? selected;
    var called = false;
    await openDialog(
      tester,
      onSelect: (color) {
        called = true;
        selected = color;
      },
    );
    expect(find.byType(ColorPicker), findsOneWidget);
    // Only the preset swatches and the wheel are offered.
    final picker = tester.widget<ColorPicker>(find.byType(ColorPicker));
    expect(picker.customColorSwatchesAndNames, RoleColors.redSwatches);
    expect(find.text('Presets'), findsOneWidget);
    expect(find.text('Custom'), findsOneWidget);
    // The default labels of the primary and accent pickers.
    expect(find.text('Primary'), findsNothing);
    expect(find.text('Accent'), findsNothing);
    // The shades of the selected color are labeled.
    expect(find.text('Shade'), findsOneWidget);

    tester.widget<ColorPicker>(find.byType(ColorPicker)).onColorChanged(Colors.indigo);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(called, isTrue);
    expect(selected?.toARGB32(), Colors.indigo.toARGB32());
  });

  testWidgets('Resets to the default color', (WidgetTester tester) async {
    Color? selected = Colors.indigo;
    await openDialog(tester, initialColor: Colors.indigo, onSelect: (color) => selected = color);

    // The dialog is scrollable and may be higher than the test window.
    await tester.ensureVisible(find.text('Reset'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(selected, isNull);
  });

  testWidgets('Cancel keeps the color', (WidgetTester tester) async {
    var called = false;
    await openDialog(tester, initialColor: Colors.indigo, onSelect: (_) => called = true);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(called, isFalse);
  });
}
