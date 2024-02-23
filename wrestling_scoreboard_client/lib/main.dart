import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wrestling_scoreboard_client/app.dart';
import 'package:wrestling_scoreboard_client/mocks/main.dart';
import 'package:wrestling_scoreboard_client/utils/environment.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';

late PackageInfo packageInfo;

const defaultProviderScope = ProviderScope(child: WrestlingScoreboardApp());

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
  packageInfo = await PackageInfo.fromPlatform();

  if (isDesktop) {
    // Support fullscreen on Desktop
    await windowManager.ensureInitialized();
  }

  runApp(Env.appEnvironment.fromString() == 'mock' ? mockProviderScope : defaultProviderScope);
}
