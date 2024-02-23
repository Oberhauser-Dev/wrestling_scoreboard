import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrestling_scoreboard_client/mocks/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  testWidgets('App launched', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(mockProviderScope);
    await tester.pump();

    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.more_horiz), findsOneWidget);

    // Tap more icon.
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pump();

    // Verify the more page has loaded.
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.byIcon(Icons.info), findsNWidgets(2));
  });
}
