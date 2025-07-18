import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wrestling_scoreboard_client/app.dart';
import 'package:wrestling_scoreboard_client/mocks/main.dart';
import 'package:wrestling_scoreboard_client/utils/environment.dart';
import 'package:wrestling_scoreboard_client/utils/package_info.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';

final defaultProviderScope = ProviderScope(
  // Never retry any provider
  retry: (retryCount, error) => null,
  child: WrestlingScoreboardApp(),
);

void main() async {
  // Use [HashUrlStrategy] by default to support Single Page Application without configuring the server.
  if (Env.usePathUrlStrategy.fromBool()) {
    usePathUrlStrategy();
  }

  // Add this option to provide a way to stack pages indefinitely with `context.push`.
  // The back button on the browser then behaves the same as the back button in the app.
  // This comes with the price that URLs may not reflect the current stack on deep links (pasted links).
  // The correct way would be to add all possible sub-routes of a base route.
  GoRouter.optionURLReflectsImperativeAPIs = true;

  WidgetsFlutterBinding.ensureInitialized();
  await initializePackageInfo();

  if (isDesktop) {
    // Support fullscreen on Desktop
    await windowManager.ensureInitialized();
  }

  for (var fileName in ['Roboto-LICENSE.txt']) {
    LicenseRegistry.addLicense(() async* {
      final license = await rootBundle.loadString('assets/fonts/google/$fileName');
      yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    });
  }

  runApp(Env.appEnvironment.fromString() == 'mock' ? mockProviderScope : defaultProviderScope);
}
