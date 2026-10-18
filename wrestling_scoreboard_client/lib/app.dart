import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
import 'package:material_duration_picker/material_duration_picker.dart';
import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrestling_scoreboard_client/l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/models/backup.dart';
import 'package:wrestling_scoreboard_client/provider/backup_provider.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/routes/router.dart';
import 'package:wrestling_scoreboard_client/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_client/utils/colors.dart';
import 'package:wrestling_scoreboard_client/utils/environment.dart';
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

/// Attached to [MaterialApp.scaffoldMessengerKey] to show snackbars from outside the widget tree.
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class WrestlingScoreboardAppState extends ConsumerState<WrestlingScoreboardApp> {
  // Initialize router once to avoid reloading initial path on rebuild.
  final routerConfig = getRouter();

  @override
  void initState() {
    super.initState();

    // Need to init to listen to changes of settings.
    AudioCache.instance = AudioCache(prefix: '');
  }

  static MaterialColor primaryColor = createMaterialColor(Colors.blue); // const Color.fromARGB(255, 180, 0, 10)

  /// Builds the theme with the base colors of the red and blue corner, which are the default colors if null.
  ThemeData _buildTheme(Brightness brightness, String? fontFamily, (Color?, Color?) roleBaseColors) {
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
    final (red, blue) = roleBaseColors;
    theme = theme.copyWith(
      extensions: [RoleColors.fromBase(red: red, blue: blue, background: theme.colorScheme.surface)],
    );
    if (fontFamily != null) {
      return theme.copyWith(textTheme: GoogleFonts.getTextTheme(fontFamily, theme.textTheme));
    }
    return theme;
  }

  /// Loads the base colors of the red and blue corner for the light and dark theme.
  Future<Map<Brightness, (Color?, Color?)>> _loadRoleBaseColors() async {
    // Watch all providers synchronously, before awaiting any of them.
    final futures = {
      for (final brightness in Brightness.values)
        brightness: (
          ref.watch(roleColorProvider(BoutRole.red, brightness)),
          ref.watch(roleColorProvider(BoutRole.blue, brightness)),
        ),
    };
    return {
      for (final MapEntry(key: brightness, value: (red, blue)) in futures.entries) brightness: (await red, await blue),
    };
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder<Locale?>(
      future: ref.watch(localeProvider),
      builder: (context, locale) {
        return LoadingBuilder<ThemeMode>(
          future: ref.watch(themeModeProvider),
          builder: (context, themeMode) {
            return LoadingBuilder<String?>(
              future: ref.watch(fontFamilyProvider),
              builder: (context, fontFamily) {
                return LoadingBuilder<Map<Brightness, (Color?, Color?)>>(
                  future: _loadRoleBaseColors(),
                  builder: (context, roleBaseColors) {
                    return MaterialApp.router(
                      scaffoldMessengerKey: scaffoldMessengerKey,
                      debugShowCheckedModeBanner: false,
                      title: AppLocalizations.of(context)?.appName ?? 'Wrestling Scoreboard',
                      theme: _buildTheme(Brightness.light, fontFamily, roleBaseColors[Brightness.light]!),
                      darkTheme: _buildTheme(Brightness.dark, fontFamily, roleBaseColors[Brightness.dark]!),
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

  late final ProviderSubscription<Future<String?>> _appDataDirectorySubscription;
  late final ProviderSubscription<Future<(String?, List<BackupRule>)>> _backupSubscription;

  Future<Iterable<MapEntry<DateTime, FileSystemEntity>>> listDateFilesOfDirectory(String dirPath) async {
    final dir = Directory(dirPath);
    if (!(await dir.exists())) return [];
    return (await dir.list().map((fsEntity) {
      final dateStr = fsEntity.uri.pathSegments.last.split('_')[0];
      final date = FileNameDateTimeParser.tryParse(dateStr);
      if (date == null) return null;
      return MapEntry(date, fsEntity);
    }).toList()).nonNulls;
  }

  @override
  void initState() {
    super.initState();

    // Prepare log file
    _appDataDirectorySubscription = ref.listenManual(appDataDirectoryProvider, (previous, next) async {
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
    _backupSubscription = ref.listenManual(backupProvider, (previous, next) async {
      // Clear timers
      for (final timer in _backupTimers) {
        timer.cancel();
      }
      _backupTimers.clear();

      if (!ref.context.mounted) return;
      final (backupDir, backupRules) = await next;
      if (backupDir == null) return;

      final now = MockableDateTime.now();
      if (!ref.context.mounted) return;
      final dataManager = await ref.read(dataManagerProvider);

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
          final nextBackupIn = lastUpdateDate == null
              ? Duration.zero
              : (backupRule.period - now.difference(lastUpdateDate));

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
  void dispose() {
    _appDataDirectorySubscription.close();
    _backupSubscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = Shortcuts(
      shortcuts: appShortcuts,
      child: Actions(
        actions: <Type, Action<Intent>>{
          AppActionIntent: CallbackAction<AppActionIntent>(
            onInvoke: (AppActionIntent intent) async {
              await intent.handle(context, ref);
              return null;
            },
          ),
        },
        child: widget.child,
      ),
    );
    final isDevelopment = Env.appEnvironment.fromString() == 'development';
    if (isDevelopment) {
      return Banner(message: 'DEV', location: BannerLocation.bottomEnd, child: result);
    }
    return result;
  }
}

class ConnectionWidget extends ConsumerStatefulWidget {
  final Widget child;

  const ConnectionWidget({required this.child, super.key});

  @override
  ConsumerState<ConnectionWidget> createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends ConsumerState<ConnectionWidget> {
  bool _isDialogShown = false;
  late final ProviderSubscription<Future<WebSocketConnectionState>> _websocketStateSubscription;
  late final ProviderSubscription<Future<DataManager>> _dataManagerSubscription;

  @override
  void initState() {
    super.initState();

    // Start listening
    void onRetry() async {
      (await ref.read(webSocketManagerProvider)).onWebSocketConnection.sink.add(WebSocketConnectionState.connecting);
    }

    // Listen to the websocket provider as soon as possible to not miss any state changes.
    _websocketStateSubscription = ref.listenManual(webSocketStateStreamProvider.future, (previous, next) async {
      await catchAsync(context, () async {
        final connectionState = await next;
        if (!_isDialogShown && connectionState == WebSocketConnectionState.disconnected) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (mounted) {
              final localizations = context.l10n;
              _isDialogShown = true;
              await showExceptionDialog(
                context: context,
                exception: localizations.noWebSocketConnection,
                stackTrace: null,
                onRetry: onRetry,
              );
              _isDialogShown = false;
            }
          });
        } else if (mounted && _isDialogShown && connectionState == WebSocketConnectionState.connected) {
          // Pop dialog, if reconnect was successful.
          Navigator.of(context).pop();
        }
      }, onRetry: onRetry);
    });

    _dataManagerSubscription = ref.listenManual(dataManagerProvider, (previous, next) async {
      final dataManager = await next;
      final remoteConfig = await dataManager.getRemoteConfig();
      final migration = remoteConfig.migration;
      final minClientVersion = Version.parse(migration.minClientVersion);
      final packageVersion = Version.parse(packageInfo.version);
      final serverVersion = Version.parse(migration.semver);
      final clientTooOld = packageVersion < minClientVersion;
      // Set min supported server version before release
      final minSupportedServerVersion = Version(0, 3, 13);
      final serverTooOld = serverVersion < minSupportedServerVersion;
      if (clientTooOld || serverTooOld) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            final localizations = context.l10n;
            final compatibilityWarning = clientTooOld
                ? localizations.compatibleClientPhrase(migration.minClientVersion)
                : localizations.compatibleServerPhrase(minSupportedServerVersion.canonicalizedVersion);
            showOkDialog(
              context: context,
              child: MarkdownBody(
                shrinkWrap: true,
                selectable: true,
                data: localizations.incompatibleVersionsPhrase(
                  packageInfo.version,
                  migration.semver,
                  compatibilityWarning,
                ),
                onTapLink: (text, href, title) => launchUrl(Uri.parse(href!)),
              ),
            );
          }
        });
      }
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _websocketStateSubscription.close();
    _dataManagerSubscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
