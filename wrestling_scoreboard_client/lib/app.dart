import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
import 'package:material_duration_picker/material_duration_picker.dart';
import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';
import 'package:wrestling_scoreboard_client/l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/backup_provider.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/routes/router.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_client/utils/io.dart';
import 'package:wrestling_scoreboard_client/utils/package_info.dart';
import 'package:wrestling_scoreboard_client/view/shortcuts/app_shortcuts.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class WrestlingScoreboardApp extends ConsumerStatefulWidget {
  const WrestlingScoreboardApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => WrestlingScoreboardAppState();
}

class WrestlingScoreboardAppState extends ConsumerState<WrestlingScoreboardApp> {
  // Initialize router once to avoid reloading initial path on rebuild.
  final routerConfig = getRouter();

  @override
  void initState() {
    super.initState();

    // Need to init to listen to changes of settings.
    AudioCache.instance = AudioCache(prefix: '');
  }

  static MaterialColor primaryColor = _createMaterialColor(Colors.blue); // const Color.fromARGB(255, 180, 0, 10)

  static MaterialColor _createMaterialColor(Color color) {
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
    // ignore: deprecated_member_use
    return MaterialColor(color.value, swatch);
  }

  ThemeData _buildTheme(Brightness brightness, String? fontFamily) {
    ThemeData theme;
    if (brightness == Brightness.light) {
      theme = ThemeData.light();
      theme = theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(primary: primaryColor, secondary: primaryColor.shade800),
      );
    } else {
      theme = ThemeData.dark();
      theme = theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(primary: primaryColor, secondary: primaryColor.shade300),
      );
    }
    if (fontFamily != null) {
      return theme.copyWith(textTheme: GoogleFonts.getTextTheme(fontFamily, theme.textTheme));
    }
    return theme;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder<Locale?>(
      future: ref.watch(localeNotifierProvider),
      builder: (context, locale) {
        return LoadingBuilder<ThemeMode>(
          future: ref.watch(themeModeNotifierProvider),
          builder: (context, themeMode) {
            return LoadingBuilder<String?>(
              future: ref.watch(fontFamilyNotifierProvider),
              builder: (context, fontFamily) {
                return MaterialApp.router(
                  //debugShowCheckedModeBanner: false,
                  title: AppLocalizations.of(context)?.appName ?? 'Wrestling Scoreboard',
                  theme: _buildTheme(Brightness.light, fontFamily),
                  darkTheme: _buildTheme(Brightness.dark, fontFamily),
                  themeMode: themeMode,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalMaterialDurationPickerLocalizations.delegate,
                  ],
                  supportedLocales: Preferences.supportedLanguages,
                  builder: (context, child) => GlobalWidget(child: child ?? const CircularProgressIndicator()),
                  locale: locale,
                  routerConfig: routerConfig,
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Widget to handle global functionality.
class GlobalWidget extends ConsumerStatefulWidget {
  final Widget child;

  const GlobalWidget({required this.child, super.key});

  @override
  ConsumerState<GlobalWidget> createState() => _GlobalWidgetState();
}

class _GlobalWidgetState extends ConsumerState<GlobalWidget> {
  final Set<Timer> _backupTimers = {};

  Future<Iterable<MapEntry<DateTime, FileSystemEntity>>> listDateFilesOfDirectory(String dirPath) async {
    final dir = Directory(dirPath);
    if (!(await dir.exists())) return [];
    return (await dir.list().map((fsEntity) {
          final dateStr = fsEntity.uri.pathSegments.last.split('_')[0];
          final date = FileNameDateTimeParser.tryParse(dateStr);
          if (date == null) return null;
          return MapEntry(date, fsEntity);
        }).toList())
        .nonNulls;
  }

  @override
  void initState() {
    super.initState();

    // Prepare log file
    ref.listenManual(appDataDirectoryNotifierProvider, (previous, next) async {
      final appDataDir = await next;
      if (appDataDir == null) return;
      final now = MockableDateTime.now();
      final loggingDir = path.join(appDataDir, 'logs');

      // Delete all logs older than 31 days
      await Future.wait(
        (await listDateFilesOfDirectory(loggingDir))
            .where((entry) {
              return entry.key.isBefore(now.subtract(Duration(days: 31)));
            })
            .map((entry) => entry.value.delete()),
      );

      final loggingFile = File(path.join(loggingDir, '${now.toFileNameDateFormat()}_wrestling-scoreboard-client.log'));
      await loggingFile.create(recursive: true);
      Logger.root.onRecord.listen((record) {
        loggingFile.writeAsString('${record.formatted}\n', mode: FileMode.append);
      });
    }, fireImmediately: true);

    // Prepare backups
    ref.listenManual(backupNotifierProvider, (previous, next) async {
      // Clear timers
      for (final timer in _backupTimers) {
        timer.cancel();
      }
      _backupTimers.clear();

      final (backupDir, backupRules) = await next;
      if (backupDir == null) return;

      final now = MockableDateTime.now();
      final dataManager = await ref.read(dataManagerNotifierProvider);

      await Future.wait(
        backupRules.map((backupRule) async {
          final ruleDir = path.join(backupDir, backupRule.name);
          // Delete all backups older than deleteAfter
          final dateFiles = await listDateFilesOfDirectory(ruleDir);
          final groupedFiles = dateFiles.groupSetsBy((entry) {
            return entry.key.isBefore(now.subtract(backupRule.deleteAfter));
          });
          final outdatedFiles = groupedFiles[true];
          final validFiles = groupedFiles[false];
          if (outdatedFiles != null) await Future.wait(outdatedFiles.map((entry) => entry.value.delete()));
          final lastUpdateDate = validFiles?.map((e) => e.key).sorted().last;
          final nextBackupIn =
              lastUpdateDate == null ? Duration.zero : (backupRule.period - now.difference(lastUpdateDate));

          runBackup(Timer timer) async {
            // Wait the initial duration, then start the backup.
            await Future.delayed(nextBackupIn, () async {
              // Skip, if timer already was removed in the mean time.
              if (!_backupTimers.contains(timer) || !mounted) return;
              final sqlString = await dataManager.exportDatabase();
              final backupFile = File(
                path.join(
                  ruleDir,
                  '${MockableDateTime.now().toFileNameDateTimeFormat()}_wrestling_scoreboard-dump.sql',
                ),
              );
              await backupFile.create(recursive: true);
              await backupFile.writeAsString(sqlString, mode: FileMode.writeOnly);
            });
          }

          final timer = Timer.periodic(backupRule.period, (timer) => runBackup(timer));
          _backupTimers.add(timer);
          // Run the backup the first time as soon as [nextBackupIn].
          runBackup(timer);
        }),
      );
    }, fireImmediately: true);
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: appShortcuts,
      child: Actions(
        actions: <Type, Action<Intent>>{
          AppActionIntent: CallbackAction<AppActionIntent>(
            onInvoke: (AppActionIntent intent) {
              return intent.handle(context, ref);
            },
          ),
        },
        child: widget.child,
      ),
    );
  }
}

class ConnectionWidget extends ConsumerStatefulWidget {
  final Widget child;

  const ConnectionWidget({required this.child, super.key});

  @override
  ConsumerState<ConnectionWidget> createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends ConsumerState<ConnectionWidget> {
  @override
  void initState() {
    super.initState();

    // Start listening
    void onRetry() async {
      (await ref.read(
        webSocketManagerNotifierProvider,
      )).onWebSocketConnection.sink.add(WebSocketConnectionState.connecting);
    }

    // Listen to the websocket provider as soon as possible to not miss any state changes.
    ref.listenManual(webSocketStateStreamProvider.future, (previous, next) async {
      await catchAsync(context, () async {
        final connectionState = await next;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && connectionState == WebSocketConnectionState.disconnected) {
            final localizations = context.l10n;
            showExceptionDialog(
              context: context,
              exception: localizations.noWebSocketConnection,
              stackTrace: null,
              onRetry: onRetry,
            );
          }
        });
      }, onRetry: onRetry);
    });

    ref.listenManual(dataManagerNotifierProvider, (previous, next) async {
      final dataManager = await next;
      final migration = await dataManager.getMigration();
      // TODO: Also check, if the server version is too old.
      final minClientVersion = Version.parse(migration.minClientVersion);
      final packageVersion = Version.parse(packageInfo.version);
      final serverVersion = Version.parse(migration.semver);
      final clientTooOld = packageVersion < minClientVersion;
      final minSupportedServerVersion = Version(0, 1, 1);
      final serverTooOld = serverVersion < minSupportedServerVersion;
      if (clientTooOld || serverTooOld) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            var compatibilityWarning =
                'This client with version "${packageInfo.version}" is not compatible with the server version "${migration.semver}". ';
            if (clientTooOld) {
              compatibilityWarning += 'The minimum supported client version is "${migration.minClientVersion}".\n';
            } else {
              compatibilityWarning +=
                  'The server probably should be updated to the minimum compatible server version "${minSupportedServerVersion.canonicalizedVersion}".\n';
            }
            compatibilityWarning +=
                'Please download a compatible client from "https://github.com/Oberhauser-Dev/wrestling_scoreboard/releases" or change the server in the settings.';
            showOkDialog(context: context, child: SelectableText(compatibilityWarning));
          }
        });
      }
    }, fireImmediately: true);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
