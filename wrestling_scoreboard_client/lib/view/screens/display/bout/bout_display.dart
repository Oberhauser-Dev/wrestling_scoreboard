import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/audio_provider.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/score_sheet.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/utils/units.dart';
import 'package:wrestling_scoreboard_client/view/models/main_stopwatch.dart';
import 'package:wrestling_scoreboard_client/view/models/participant_state_model.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_actions.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_main_controls.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_shortcuts.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/technical_points.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/time_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tooltip.dart';
import 'package:wrestling_scoreboard_common/common.dart';

/// Everything is live updated, except the timers are running locally, to reduce traffic and raise accuracy.
class BoutScreen extends ConsumerStatefulWidget {
  final WrestlingEvent wrestlingEvent;
  final Map<Person, PersonRole> officials;
  final List<Bout> bouts;
  final Bout bout;
  final double? weightR;
  final double? weightB;
  final WeightClass? weightClass;
  final AgeCategory? ageCategory;
  final String? roundDescription;
  final int? mat;

  // TODO: may overwrite in settings to be more flexible
  final BoutConfig boutConfig;
  final List<BoutResultRule> boutRules;
  final List<Widget> headerItems;
  final int boutIndex;
  final List<ResponsiveScaffoldActionItemBuilder> actions;
  final void Function(BuildContext context, int boutIndex) navigateToBoutByIndex;

  const BoutScreen({
    super.key,
    required this.bouts,
    required this.bout,
    required this.boutIndex,
    this.headerItems = const [],
    this.actions = const [],
    required this.navigateToBoutByIndex,
    required this.boutConfig,
    required this.boutRules,
    required this.wrestlingEvent,
    required this.officials,
    this.weightClass,
    this.roundDescription,
    this.ageCategory,
    this.weightR,
    this.weightB,
    this.mat,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BoutState();
}

class BoutState extends ConsumerState<BoutScreen> {
  static const flexWidths = [50, 30, 50];

  late ParticipantStateModel _r;
  late ParticipantStateModel _b;
  late BoutConfig boutConfig;
  late List<BoutResultRule> boutRules;
  late WeightClass? weightClass;

  late Bout bout;
  int period = 1;

  late final StreamSubscription<Duration> _onEndBreakStopwatchSubscription;
  ProviderSubscription<Future<AthleteBoutState>>? _rChangeSub;
  ProviderSubscription<Future<AthleteBoutState>>? _bChangeSub;
  late final MainStopwatch mainStopwatch;

  Widget? _child;
  bool _isBigScreen = true;

  void _doForParticipantStateModels(void Function(ParticipantStateModel psm) callback) {
    callback(_r);
    callback(_b);
  }

  void _updateParticipantStateModel(ParticipantStateModel psm, AthleteBoutState abs) {
    if (abs.activityTime != null) {
      psm.activityStopwatchNotifier.value ??= ObservableStopwatch(limit: boutConfig.activityDuration);
      psm.activityStopwatch?.elapsed = abs.activityTime!;
      if (bout.isRunning) {
        psm.activityStopwatch?.start();
      } else {
        psm.activityStopwatch?.stop();
      }
    } else {
      psm.activityStopwatch?.dispose();
      psm.activityStopwatchNotifier.value = null;
    }

    if (abs.isInjuryTimeRunning != psm.injuryStopwatch.isRunning ||
        (!abs.isInjuryTimeRunning && !psm.injuryStopwatch.isRunning)) {
      psm.injuryStopwatch.elapsed = abs.injuryTime ?? Duration.zero;
      psm.isInjuryDisplayedNotifier.value = abs.isInjuryTimeRunning;
      if (abs.isInjuryTimeRunning) {
        psm.injuryStopwatch.start();
      } else {
        psm.injuryStopwatch.stop();
      }
    }

    if (abs.isBleedingInjuryTimeRunning != psm.bleedingInjuryStopwatch.isRunning ||
        (!abs.isBleedingInjuryTimeRunning && !psm.bleedingInjuryStopwatch.isRunning)) {
      psm.bleedingInjuryStopwatch.elapsed = abs.bleedingInjuryTime ?? Duration.zero;
      psm.isBleedingInjuryDisplayedNotifier.value = abs.isBleedingInjuryTimeRunning;
      if (abs.isBleedingInjuryTimeRunning) {
        psm.bleedingInjuryStopwatch.start();
      } else {
        psm.bleedingInjuryStopwatch.stop();
      }
    }
  }

  void _updateAthleteBoutState(ParticipantStateModel psm, AthleteBoutState Function(AthleteBoutState abs) apply) async {
    if (!ref.context.mounted) return;
    final abs = psm == _r ? bout.r : bout.b;
    if (abs != null) {
      final newAbs = apply(abs);
      if (abs != newAbs) {
        if (psm == _r) {
          bout = bout.copyWith(r: newAbs);
        } else {
          bout = bout.copyWith(b: newAbs);
        }
        await (await ref.readAsync(dataManagerProvider)).createOrUpdateSingle(newAbs);
      }
    }
  }

  @override
  initState() {
    super.initState();

    boutConfig = widget.boutConfig;
    boutRules = widget.boutRules;
    mainStopwatch = MainStopwatch(
      boutStopwatch: ObservableStopwatch(limit: boutConfig.totalPeriodDuration),
      breakStopwatch: ObservableStopwatch(limit: boutConfig.breakDuration),
    );

    _initializeBout();

    weightClass = widget.weightClass;
    _r = ParticipantStateModel();
    _b = ParticipantStateModel();

    _doForParticipantStateModels((psm) {
      // Regular injury
      psm.injuryStopwatch.limit = boutConfig.injuryDuration;
      psm.injuryStopwatch.onEnd.stream.listen((event) {
        psm.isInjury = false;
        psm.isInjuryDisplayedNotifier.value = false;

        handleOrCatchIntent(const BoutScreenActionIntent.horn());
      });

      // Bleeding injury
      psm.bleedingInjuryStopwatch.limit = boutConfig.bleedingInjuryDuration;
      psm.bleedingInjuryStopwatch.onEnd.stream.listen((event) {
        psm.isBleedingInjury = false;
        psm.isBleedingInjuryDisplayedNotifier.value = false;

        handleOrCatchIntent(const BoutScreenActionIntent.horn());
      });
    });

    mainStopwatch.boutStopwatch.onStart.stream.listen((event) async {
      _doForParticipantStateModels((psm) async {
        psm.activityStopwatch?.start();

        // Stop all injury timers, when bout stop watch is started
        psm.injuryStopwatch.stop();
        psm.isInjuryDisplayedNotifier.value = false;
        psm.bleedingInjuryStopwatch.stop();
        psm.isBleedingInjuryDisplayedNotifier.value = false;

        _updateAthleteBoutState(
          psm,
          (abs) => abs.copyWith(
            activityTime: psm.activityStopwatch?.elapsed,
            injuryTime: psm.injuryStopwatch.elapsed,
            isInjuryTimeRunning: false,
            bleedingInjuryTime: psm.bleedingInjuryStopwatch.elapsed,
            isBleedingInjuryTimeRunning: false,
          ),
        );
      });

      bout = bout.copyWith(isRunning: true);
      // Trigger running on each start
      await (await ref.read(dataManagerProvider)).createOrUpdateSingle(bout);
    });
    mainStopwatch.boutStopwatch.onStop.stream.listen((event) async {
      _doForParticipantStateModels((psm) async {
        psm.activityStopwatch?.stop();

        _updateAthleteBoutState(psm, (abs) => abs.copyWith(activityTime: psm.activityStopwatch?.elapsed));
      });
      bout = bout.copyWith(duration: event, isRunning: false);

      // Save time to database on each stop
      await (await ref.read(dataManagerProvider)).createOrUpdateSingle(bout);
    });
    mainStopwatch.boutStopwatch.onAdd.stream.listen((event) {
      _doForParticipantStateModels((psm) {
        psm.activityStopwatch?.add(event);
      });
    });
    mainStopwatch.boutStopwatch.onChangeSecond.stream.listen((event) {
      if (!mainStopwatch.isBreak.value) {
        bout = bout.copyWith(duration: event);

        // If is above the time of the current period, then trigger the break
        if (bout.duration.compareTo(boutConfig.periodDuration * period) >= 0) {
          // Set to exact period end, as internal duration of stopwatch usually is a few milliseconds ahead of the second listener.
          // Otherwise the timer is displaying a different time (2:59.9) than expected (3:00.0) after a break.
          mainStopwatch.boutStopwatch.stopAt(event);
          _doForParticipantStateModels((psm) {
            if (psm.activityStopwatch != null) {
              psm.activityStopwatch!.dispose();
              psm.activityStopwatchNotifier.value = null;
            }
          });
          handleOrCatchIntent(const BoutScreenActionIntent.horn());
          if (period < boutConfig.periodCount) {
            mainStopwatch.isBreak.value = true;
            mainStopwatch.breakStopwatch.start();
            period++;
          }
        } else if (bout.duration.inSeconds ~/ boutConfig.periodDuration.inSeconds < (period - 1)) {
          // Fix times below round time: e.g. if subtract time
          period -= 1;
        }
      }
    });
    _onEndBreakStopwatchSubscription = mainStopwatch.breakStopwatch.onEnd.stream.listen((event) {
      if (mainStopwatch.isBreak.value) {
        mainStopwatch.breakStopwatch.reset();
        mainStopwatch.isBreak.value = false;
        handleOrCatchIntent(const BoutScreenActionIntent.horn());
      }
    });

    _doForParticipantStateModels((psm) {
      psm.injuryStopwatch.onStartStop.stream.listen((isRunning) {
        _updateAthleteBoutState(
          psm,
          (abs) => abs.copyWith(injuryTime: psm.injuryStopwatch.elapsed, isInjuryTimeRunning: isRunning),
        );
      });
      psm.bleedingInjuryStopwatch.onStartStop.stream.listen((isRunning) {
        _updateAthleteBoutState(
          psm,
          (abs) => abs.copyWith(
            bleedingInjuryTime: psm.bleedingInjuryStopwatch.elapsed,
            isBleedingInjuryTimeRunning: isRunning,
          ),
        );
      });
    });

    if (bout.r != null) {
      _rChangeSub = ref.listenManual(
        singleDataStreamProvider<AthleteBoutState>(
          SingleProviderData<AthleteBoutState>(initialData: bout.r, id: bout.r!.id!),
        ).future,
        (previous, next) async {
          final abs = await next;
          bout = bout.copyWith(r: abs);
          _updateParticipantStateModel(_r, abs);
        },
        fireImmediately: true,
      );
    }

    if (bout.b != null) {
      _bChangeSub = ref.listenManual(
        singleDataStreamProvider<AthleteBoutState>(
          SingleProviderData<AthleteBoutState>(initialData: bout.b, id: bout.b!.id!),
        ).future,
        (previous, next) async {
          final abs = await next;
          bout = bout.copyWith(b: abs);
          _updateParticipantStateModel(_b, abs);
        },
        fireImmediately: true,
      );
    }
  }

  @override
  void didUpdateWidget(covariant BoutScreen oldWidget) {
    if (oldWidget.bout != widget.bout) {
      _initializeBout();
      // Trigger rerendering child not needed, as the values are updated in its own widgets.
      // _child = null;
    }
    super.didUpdateWidget(oldWidget);
  }

  void _initializeBout() {
    bout = widget.bout;
    // Set the current period based on the duration:
    period = (bout.duration.inSeconds ~/ boutConfig.periodDuration.inSeconds) + 1;
    if (!mainStopwatch.boutStopwatch.isDisposed) {
      // We assume, when the isRunning state differs, the client is controlled remotely.
      if (mainStopwatch.boutStopwatch.isRunning != bout.isRunning ||
          (!mainStopwatch.boutStopwatch.isRunning && !bout.isRunning)) {
        // Only update duration on remote clients as on otherwise the timer is lagging behind due to network latency.
        // But also, if non of them are running (otherwise the first initialization is not executed).
        mainStopwatch.boutStopwatch.elapsed = bout.duration;
      }
      if (bout.isRunning) {
        mainStopwatch.boutStopwatch.start();
      } else {
        mainStopwatch.boutStopwatch.stop();
      }
    }
  }

  @override
  void dispose() {
    _onEndBreakStopwatchSubscription.cancel();
    _rChangeSub?.close();
    _bChangeSub?.close();
    super.dispose();
  }

  void handleOrCatchIntent(Intent intent) async {
    await catchAsync(context, () => handleIntent(intent));
  }

  Future<List<BoutAction>> _getActions() async =>
      await ref.readAsync(manyDataStreamProvider(ManyProviderData<BoutAction, Bout>(filterObject: bout)).future);

  Future<void> handleIntent(Intent intent) async {
    Future<void> deleteAction(BoutAction action) async =>
        (await ref.read(dataManagerProvider)).deleteSingle<BoutAction>(action);

    Future<void> createOrUpdateAction(BoutAction action) async =>
        (await ref.read(dataManagerProvider)).createOrUpdateSingle<BoutAction>(action);

    if (intent is BoutScreenActionIntent) {
      return await _handleBoutScreenActionIntent(intent, deleteAction);
    } else if (intent is RoleScreenActionIntent) {
      return await _handleRoleScreenActionIntent(intent, deleteAction, createOrUpdateAction);
    }
  }

  Future<void> _handleRoleScreenActionIntent(
    RoleScreenActionIntent intent,
    Future<void> Function(BoutAction action) deleteAction,
    Future<void> Function(BoutAction action) createOrUpdateAction,
  ) async {
    final useSmartBoutActions = await ref.readAsync(smartBoutActionsProvider);
    List<BoutAction>? prevActions;
    if (useSmartBoutActions) {
      // Smart actions check before the actual action
      prevActions = await _getActions();
      if (!mounted) return;
      if (prevActions.isNotEmpty) {
        if (prevActions.last.actionType == BoutActionType.caution) {
          if (intent is! RolePointBoutActionIntent || intent.points > 2 || intent.role == prevActions.last.role) {
            // A caution must follow one or two points.
            final localizations = context.l10n;
            await showOkDialog(context: context, child: Text(localizations.warningCautionNoPoints));
            return;
          }
        }
      }
      if (intent is RoleBoutActionIntent &&
          intent.boutActionType == BoutActionType.passivity &&
          weightClass?.style == WrestlingStyle.free) {
        final hadVerbal = prevActions.any((la) => la.actionType == BoutActionType.verbal && intent.role == la.role);
        if (!hadVerbal) {
          // A passivity must precede a verbal admonition.
          final localizations = context.l10n;
          final result = await showOkCancelDialog(
            context: context,
            child: Text(localizations.warningFreestyleVerbalPrecedePassivity),
          );
          if (!result) return;
        }
      }
    }
    if (!mounted) return;
    final boutStopwatch = mainStopwatch.boutStopwatch;
    final type = intent.type;
    switch (type) {
      case RoleScreenActionType.roleAction:
        if (intent is! RoleBoutActionIntent) {
          throw StateError('Intent type $type does not match the class RoleBoutActionIntent');
        }
        // NOTE: Do not used bout.duration as time, as it is not up to date.
        final action = BoutAction(
          bout: bout,
          role: intent.role,
          duration: boutStopwatch.elapsed,
          actionType: intent.boutActionType,
          pointCount: intent is RolePointBoutActionIntent ? intent.points : null,
        );
        await createOrUpdateAction(action);
        break;
      case RoleScreenActionType.activityTime:
        final ParticipantStateModel psm = intent.role == BoutRole.red ? _r : _b;
        psm.activityStopwatch?.dispose();
        psm.activityStopwatchNotifier.value =
            psm.activityStopwatch == null ? ObservableStopwatch(limit: boutConfig.activityDuration) : null;
        if (psm.activityStopwatch != null && mainStopwatch.boutStopwatch.isRunning) psm.activityStopwatch!.start();
        psm.activityStopwatch?.onEnd.stream.listen((event) async {
          psm.activityStopwatch?.dispose();
          psm.activityStopwatchNotifier.value = null;
          if (useSmartBoutActions) await handleIntent(RolePointBoutActionIntent(points: 1, role: intent.role.opponent));
        });
        break;
      case RoleScreenActionType.injuryTime:
        final ParticipantStateModel psm = intent.role == BoutRole.red ? _r : _b;

        if (!psm.injuryStopwatch.hasEnded) {
          // If time is set manually after timer has ended, the timer and display flags differ.
          // So we use the displayed flag as the reset option.
          psm.isInjury = !psm.isInjuryDisplayed;
        }
        psm.isInjuryDisplayedNotifier.value = !psm.isInjuryDisplayed;

        if (psm.isInjury) {
          psm.injuryStopwatch.start();
        } else {
          psm.injuryStopwatch.stop();
        }
        break;
      case RoleScreenActionType.bleedingInjuryTime:
        final ParticipantStateModel psm = intent.role == BoutRole.red ? _r : _b;

        if (!psm.bleedingInjuryStopwatch.hasEnded) {
          psm.isBleedingInjury = !psm.isBleedingInjuryDisplayed;
        }
        psm.isBleedingInjuryDisplayedNotifier.value = !psm.isBleedingInjuryDisplayed;

        if (psm.isBleedingInjury) {
          psm.bleedingInjuryStopwatch.start();
        } else {
          psm.bleedingInjuryStopwatch.stop();
        }
        break;
      case RoleScreenActionType.undo:
        final AthleteBoutState? abs = intent.role == BoutRole.red ? bout.r : bout.b;
        if (abs != null) {
          prevActions ??= await _getActions();
          final roleActions = prevActions.where((el) => el.role == intent.role);
          if (roleActions.isNotEmpty) {
            final action = roleActions.last;
            deleteAction(action);
          }
        }
        break;
    }

    if (useSmartBoutActions && mounted) {
      final ParticipantStateModel psm = intent.role == BoutRole.red ? _r : _b;
      if (intent is RoleBoutActionIntent && intent.boutActionType == BoutActionType.passivity) {
        // Smart actions, after the actual action.
        final wrestlingStyle = weightClass?.style ?? WrestlingStyle.free;

        if (wrestlingStyle == WrestlingStyle.free) {
          // In free style, stop the timer and start activity time on passivity (P)
          mainStopwatch.stopwatch.stop();
          // Dispose previous activity times, so it is not toggled off
          psm.activityStopwatch?.dispose();
          psm.activityStopwatchNotifier.value = null;
          await handleIntent(RoleScreenActionIntent(role: intent.role, type: RoleScreenActionType.activityTime));
        } else {
          assert(prevActions != null, 'prevActions should already be initialized');
          Future<bool> includesZeroOrOnePassivity() async {
            // At this moment, the new passivity is not yet updated by the websocket (even if freshly getting the list),
            // so we need to treat them as one less.
            return prevActions!.where((la) => la.actionType == BoutActionType.passivity).length <= 1;
          }

          // In greco, stop the timer (P)
          // Give one point to the opponent at the first and the second (P) (no matter which wrestler).
          mainStopwatch.stopwatch.stop();
          if (!await includesZeroOrOnePassivity()) return;
          await handleIntent(RolePointBoutActionIntent(role: intent.role.opponent, points: 1));
        }
      } else if (intent is RolePointBoutActionIntent) {
        // End activity stop watch, if a point is made.
        if (psm.activityStopwatch != null) {
          psm.activityStopwatch?.dispose();
          psm.activityStopwatchNotifier.value = null;
        }
      }
    }
  }

  Future<void> _handleBoutScreenActionIntent(
    BoutScreenActionIntent intent,
    Future<void> Function(BoutAction action) deleteAction,
  ) async {
    final type = intent.type;
    switch (type) {
      case BoutScreenActionType.startStop:
        mainStopwatch.stopwatch.startStop();
        break;
      case BoutScreenActionType.addOneSec:
        mainStopwatch.stopwatch.add(const Duration(seconds: 1));
        break;
      case BoutScreenActionType.rmOneSec:
        if (mainStopwatch.stopwatch.elapsed > const Duration(seconds: 1)) {
          mainStopwatch.stopwatch.add(-const Duration(seconds: 1));
        } else {
          mainStopwatch.stopwatch.add(-mainStopwatch.stopwatch.elapsed);
        } // Do not reset, as it will may stop the timer
        break;
      case BoutScreenActionType.reset:
        mainStopwatch.stopwatch.reset();
        break;
      case BoutScreenActionType.nextBout:
        final int index = widget.boutIndex + 1;
        if (index < widget.bouts.length) {
          saveAndNavigateToBoutByIndex(context, index);
        }
        break;
      case BoutScreenActionType.previousBout:
        final int index = widget.boutIndex - 1;
        if (index >= 0) {
          saveAndNavigateToBoutByIndex(context, index);
        }
        break;
      case BoutScreenActionType.quit:
        context.pop();
        break;
      case BoutScreenActionType.undo:
        final prevActions = await _getActions();
        if (prevActions.isNotEmpty) {
          final action = prevActions.last;
          deleteAction(action);
        }
        break;
      case BoutScreenActionType.horn:
        ref.read(bellPlayerProvider).then((player) async {
          await player.stop();
          await player.resume();
        });
        break;
    }
  }

  Widget row({required List<Widget> children}) {
    return IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: children));
  }

  @override
  Widget build(BuildContext context) {
    final isBigScreen = context.isMediumScreenOrLarger;
    if (_child == null || _isBigScreen != isBigScreen) {
      _isBigScreen = isBigScreen;
      _child = _buildChild(context, isBigScreen);
    }
    return _child!;
  }

  /// Increase performance by only rerendering child, if the properties in didUpdateWidget change.
  /// https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html#performance-considerations
  Widget _buildChild(BuildContext context, bool isBigScreen) {
    final localizations = context.l10n;
    final double width = MediaQuery.of(context).size.width;
    final double padding = width / 100;

    final pdfAction = DefaultResponsiveScaffoldActionItem(
      label: localizations.print,
      icon: const Icon(Icons.print),
      onTap: () async {
        final isTimeCountDown = await ref.read(timeCountDownProvider);
        final actions = await ref.readAsync(
          manyDataStreamProvider(ManyProviderData<BoutAction, Bout>(filterObject: bout)).future,
        );
        if (context.mounted) {
          final bytes =
              await ScoreSheet(
                bout: bout,
                buildContext: context,
                boutActions: actions,
                wrestlingEvent: widget.wrestlingEvent,
                officials: widget.officials,
                boutConfig: boutConfig,
                boutRules: boutRules,
                isTimeCountDown: isTimeCountDown,
                weightClass: weightClass,
              ).buildPdf();
          await Printing.sharePdf(bytes: bytes, filename: '${bout.getFileBaseName(widget.wrestlingEvent)}.pdf');
        }
      },
    );
    final boutInfo = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (widget.mat != null)
          Center(child: ScaledText('${localizations.mat} ${widget.mat}', fontSize: 22, minFontSize: 10)),
        Row(
          children: [
            Expanded(
              child: Center(
                child: ScaledText('${localizations.bout} ${widget.boutIndex + 1}', fontSize: 14, minFontSize: 10),
              ),
            ),
          ],
        ),
        if (widget.roundDescription != null)
          Center(child: ScaledText(widget.roundDescription!, fontSize: 22, minFontSize: 10)),
        if (widget.ageCategory != null)
          Center(child: ScaledText(widget.ageCategory!.name, fontSize: 22, minFontSize: 10)),
        if (weightClass != null)
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaledText(weightClass!.weight.toString(), fontSize: 26, minFontSize: 10, fontWeight: FontWeight.bold),
                ScaledText(' ${weightClass!.unit.toAbbr()} | ', fontSize: 26, minFontSize: 10),
                ScaledText(
                  weightClass!.style.abbreviation(context),
                  fontSize: 26,
                  minFontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
      ],
    );
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        await save();
      },
      child: BoutActionHandler(
        handleIntent: handleOrCatchIntent,
        child: DisplayTheme(
          child: WindowStateScaffold(
            hideAppBarOnFullscreen: true,
            actions: [...widget.actions, pdfAction],
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  spacing: padding,
                  children: [
                    row(
                      children:
                          widget.headerItems
                              .asMap()
                              .entries
                              .map((entry) => Expanded(flex: flexWidths[entry.key], child: entry.value))
                              .toList(),
                    ),
                    row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: _ParticipantDisplay(
                            bout,
                            BoutRole.red,
                            padding,
                            widget.weightR,
                            widget.weightClass?.style,
                            widget.boutRules,
                          ),
                        ),
                        if (isBigScreen) Expanded(flex: 20, child: boutInfo),
                        Expanded(
                          flex: 50,
                          child: _ParticipantDisplay(
                            bout,
                            BoutRole.blue,
                            padding,
                            widget.weightB,
                            widget.weightClass?.style,
                            widget.boutRules,
                          ),
                        ),
                      ],
                    ),
                    row(
                      children: [
                        ResponsiveTechnicalPoints(
                          pStatusModel: _r,
                          role: BoutRole.red,
                          wrestlingStyle: weightClass?.style,
                          bout: bout,
                          boutConfig: boutConfig,
                          actionCallback: handleOrCatchIntent,
                        ),
                        Expanded(
                          flex: 50,
                          child: Center(
                            child: DelayedTooltip(
                              message: '${localizations.edit} ${localizations.duration} (↑ | ↓)',
                              child: ValueListenableBuilder(
                                valueListenable: mainStopwatch.isBreak,
                                builder: (context, isBreak, _) {
                                  return TimeDisplay(
                                    showDeciSecond: true,
                                    mainStopwatch.stopwatch,
                                    isBreak ? Colors.orange : Theme.of(context).colorScheme.onSurface,
                                    fontSize: 128,
                                    maxDuration: isBreak ? boutConfig.breakDuration : boutConfig.totalPeriodDuration,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        ResponsiveTechnicalPoints(
                          pStatusModel: _b,
                          role: BoutRole.blue,
                          wrestlingStyle: weightClass?.style,
                          bout: bout,
                          boutConfig: boutConfig,
                          actionCallback: handleOrCatchIntent,
                        ),
                      ],
                    ),
                    ManyConsumer<BoutAction, Bout>(
                      filterObject: bout,
                      builder: (context, actions) {
                        return ActionsWidget(
                          actions,
                          boutConfig: boutConfig,
                          onDeleteAction: (action) async => (await ref.read(dataManagerProvider)).deleteSingle(action),
                          onCreateOrUpdateAction:
                              (action) async => (await ref.read(dataManagerProvider)).createOrUpdateSingle(action),
                        );
                      },
                    ),
                    BoutMainControls(handleOrCatchIntent, this),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveAndNavigateToBoutByIndex(BuildContext context, int boutIndex) async {
    await save();
    if (!context.mounted) return;
    widget.navigateToBoutByIndex(context, boutIndex);
  }

  Future<void> save() async {
    mainStopwatch.boutStopwatch.dispose();
    mainStopwatch.breakStopwatch.dispose();

    // Save time to database when dispose
    await (await ref.read(dataManagerProvider)).createOrUpdateSingle(bout);
  }
}

class _ParticipantDisplay extends StatelessWidget {
  final Bout bout;
  final WrestlingStyle? wrestlingStyle;
  final BoutRole role;
  final double padding;
  final double? weight;
  final List<BoutResultRule> rules;

  const _ParticipantDisplay(this.bout, this.role, this.padding, this.weight, this.wrestlingStyle, this.rules);

  @override
  Widget build(BuildContext context) {
    final color = role.color();
    return ThemedContainer(
      color: color,
      child: IntrinsicHeight(
        child: SingleConsumer<Bout>(
          id: bout.id,
          initialData: bout,
          builder: (context, bout) {
            final athleteBoutState = role == BoutRole.red ? bout.r : bout.b;
            return NullableSingleConsumer<AthleteBoutState>(
              id: athleteBoutState?.id,
              initialData: athleteBoutState,
              builder: (context, pStatus) {
                List<Widget> items = [
                  Expanded(child: _NameDisplay(pStatus: pStatus, padding: padding, weight: weight)),
                  ManyConsumer<BoutAction, Bout>(
                    filterObject: bout,
                    builder: (context, actions) {
                      int? getPredictedPoints() {
                        // TODO: may can optimize by not calculating for each athlete separately.
                        // Also:
                        // - Take cautions (VCA) into consideration
                        // - Use VFO, if not show up on the mat or is excluded before (too heavy, disqualified, etc.)
                        final technicalPointsRed = AthleteBoutState.getTechnicalPoints(actions, BoutRole.red);
                        final technicalPointsBlue = AthleteBoutState.getTechnicalPoints(actions, BoutRole.blue);
                        BoutRole? predictedWinnerRole;
                        if (technicalPointsBlue == technicalPointsRed) {
                          // 1. Highest score / value of holds
                          final pointActions = actions.where((e) => e.actionType == BoutActionType.points);
                          for (int i = 5; i > 0; i--) {
                            predictedWinnerRole = _getRoleWithMostActions(
                              pointActions.where((element) => element.pointCount == i),
                            );
                            if (predictedWinnerRole != null) break;
                          }

                          // 2. Least amount of cautions
                          predictedWinnerRole ??=
                              _getRoleWithMostActions(
                                actions.where((element) => element.actionType == BoutActionType.caution),
                              )?.opponent;

                          // 3. Last technical point scored
                          predictedWinnerRole ??=
                              actions.lastWhereOrNull((e) => e.actionType == BoutActionType.points)?.role;
                        } else {
                          predictedWinnerRole = technicalPointsRed > technicalPointsBlue ? BoutRole.red : BoutRole.blue;
                        }
                        if (predictedWinnerRole == null) return null;
                        var predictedResultRule = BoutConfig.resultRule(
                          result: BoutResult.vsu,
                          style: wrestlingStyle ?? WrestlingStyle.free,
                          technicalPointsWinner:
                              predictedWinnerRole == BoutRole.red ? technicalPointsRed : technicalPointsBlue,
                          technicalPointsLoser:
                              predictedWinnerRole == BoutRole.red ? technicalPointsBlue : technicalPointsRed,
                          rules: rules,
                        );
                        predictedResultRule ??= BoutConfig.resultRule(
                          result: BoutResult.vpo,
                          style: wrestlingStyle ?? WrestlingStyle.free,
                          technicalPointsWinner:
                              predictedWinnerRole == BoutRole.red ? technicalPointsRed : technicalPointsBlue,
                          technicalPointsLoser:
                              predictedWinnerRole == BoutRole.red ? technicalPointsBlue : technicalPointsRed,
                          rules: rules,
                        );
                        if (predictedResultRule == null) return null;

                        return predictedWinnerRole == role
                            ? predictedResultRule.winnerClassificationPoints
                            : predictedResultRule.loserClassificationPoints;
                      }

                      return displayClassificationPoints(pStatus, color, padding, getPredictedPoints);
                    },
                  ),
                ];
                if (role == BoutRole.blue) items = List.from(items.reversed);
                return Row(children: items);
              },
            );
          },
        ),
      ),
    );
  }

  BoutRole? _getRoleWithMostActions(Iterable<BoutAction> actions) {
    final byRole = actions.groupSetsBy((element) => element.role);
    final countRed = byRole[BoutRole.red]?.length ?? 0;
    final countBlue = byRole[BoutRole.blue]?.length ?? 0;
    if (countRed > countBlue) {
      return BoutRole.red;
    } else if (countRed < countBlue) {
      return BoutRole.blue;
    }
    return null;
  }

  Widget displayClassificationPoints(
    AthleteBoutState? pStatus,
    MaterialColor color,
    double padding,
    int? Function() predictedPoints,
  ) {
    final classificationPoints = pStatus?.classificationPoints ?? predictedPoints();
    if (classificationPoints == null) return Container();
    return ThemedContainer(
      color: color.shade800,
      padding: EdgeInsets.symmetric(vertical: padding * 3, horizontal: padding * 2),
      child: Center(
        child: ScaledText(
          classificationPoints.toString(),
          fontSize: 54,
          minFontSize: 30,
          color: pStatus?.classificationPoints == null ? Colors.white38 : null,
        ),
      ),
    );
  }
}

class _NameDisplay extends StatelessWidget {
  final AthleteBoutState? pStatus;
  final double padding;
  final double? weight;

  const _NameDisplay({required this.pStatus, required this.padding, required this.weight});

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.all(padding),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ScaledText(
                  pStatus?.prename ?? localizations.participantVacant,
                  color: pStatus == null ? Colors.white30 : Colors.white,
                  fontSize: 30,
                  minFontSize: 20,
                  textAlign: TextAlign.center,
                ),
                if (pStatus != null)
                  ScaledText(
                    pStatus!.surname,
                    color: Colors.white,
                    fontSize: 40,
                    minFontSize: 20,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                  ),
              ],
            ),
          ),
        ),
        if (weight != null)
          Center(child: ScaledText('${weight!.toStringAsFixed(1)} $weightUnit', color: Colors.white70, fontSize: 22)),
      ],
    );
  }
}
