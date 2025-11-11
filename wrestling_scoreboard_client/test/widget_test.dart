import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrestling_scoreboard_client/mocks/main.dart';
import 'package:wrestling_scoreboard_client/utils/package_info.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  PackageInfo.setMockInitialValues(
    appName: 'Wrestling Scoreboard Client',
    packageName: 'wrestling_scoreboard_client',
    version: '0.3.7',
    buildNumber: '0',
    buildSignature: '',
  );
  await initializePackageInfo();
  SharedPreferences.setMockInitialValues({});

  testWidgets('App launched', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(mockProviderScope);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.explore), findsOneWidget);
    expect(find.byIcon(Icons.more_horiz), findsOneWidget);

    // Tap more icon.
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    // Verify the more page has loaded.
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.byIcon(Icons.info), findsNWidgets(2));
  });
}
