import 'dart:async';

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
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_action_controls.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_actions.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_main_controls.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_shortcuts.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/technical_points.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/time_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
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
  final Future<double?> Function(Bout bout)? getWeightR;
  final Future<double?> Function(Bout bout)? getWeightB;
  final WeightClass? weightClass;
  final AgeCategory? ageCategory;
  final String? roundDescription;
  final int? mat;

  // TODO: may overwrite in settings to be more flexible
  final BoutConfig boutConfig;
  final List<BoutResultRule> boutRules;
  final List<Widget> headerItems;
  final int boutIndex;
  final List<ResponsiveScaffoldActionItem> actions;
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
    // Use getter so we don't need to update the whole screen
    this.getWeightR,
    this.getWeightB,
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

  late final ProviderSubscription<Future<Bout>> _boutSubscription;
  late final StreamSubscription<Duration> _onEndBreakStopwatchSubscription;
  late final MainStopwatch mainStopwatch;

  @override
  initState() {
    super.initState();
    boutConfig = widget.boutConfig;
    boutRules = widget.boutRules;
    bout = widget.bout;
    // Set the initial current period based on the duration (to avoid wrong trigger of wrong stopwatch):
    period = (bout.duration.inSeconds ~/ boutConfig.periodDuration.inSeconds) + 1;
    // Update bout state with events from other clients:
    _boutSubscription = ref.listenManual(
      singleDataStreamProvider<Bout>(SingleProviderData(id: bout.id!, initialData: bout)).future,
      (previous, next) async {
        bout = await next;
        // Set the current period based on the duration:
        period = (bout.duration.inSeconds ~/ boutConfig.periodDuration.inSeconds) + 1;
        if (!mainStopwatch.boutStopwatch.isDisposed) {
          mainStopwatch.boutStopwatch.elapsed = bout.duration;
        }
      },
      // Ensure the bout is updated immediately (e.g. after leaving and entering the display)
      // This happens, as the bout object is not refreshed in the underlaying screens to avoid reload animations.
      fireImmediately: true,
    );

    weightClass = widget.weightClass;
    _r = ParticipantStateModel();
    _b = ParticipantStateModel();

    // Regular injury
    _r.injuryStopwatch.limit = boutConfig.injuryDuration;
    _r.injuryStopwatch.onEnd.stream.listen((event) {
      _r.isInjury = false;
      _r.isInjuryDisplayedNotifier.value = false;

      handleOrCatchIntent(const BoutScreenActionIntent.horn());
    });
    _b.injuryStopwatch.limit = boutConfig.injuryDuration;
    _b.injuryStopwatch.onEnd.stream.listen((event) {
      _b.isInjury = false;
      _b.isInjuryDisplayedNotifier.value = false;

      handleOrCatchIntent(const BoutScreenActionIntent.horn());
    });

    // Bleeding injury
    _r.bleedingInjuryStopwatch.limit = boutConfig.bleedingInjuryDuration;
    _r.bleedingInjuryStopwatch.onEnd.stream.listen((event) {
      _r.isBleedingInjury = false;
      _r.isBleedingInjuryDisplayedNotifier.value = false;

      handleOrCatchIntent(const BoutScreenActionIntent.horn());
    });
    _b.bleedingInjuryStopwatch.limit = boutConfig.bleedingInjuryDuration;
    _b.bleedingInjuryStopwatch.onEnd.stream.listen((event) {
      _b.isBleedingInjury = false;
      _b.isBleedingInjuryDisplayedNotifier.value = false;

      handleOrCatchIntent(const BoutScreenActionIntent.horn());
    });

    mainStopwatch = MainStopwatch(
      boutStopwatch: ObservableStopwatch(limit: boutConfig.totalPeriodDuration),
      breakStopwatch: ObservableStopwatch(limit: boutConfig.breakDuration),
    );
    mainStopwatch.boutStopwatch.onStart.stream.listen((event) {
      _r.activityStopwatch?.start();
      _b.activityStopwatch?.start();

      // Stop all injury timers, when bout stop watch is started
      _r.injuryStopwatch.stop();
      _r.isInjuryDisplayedNotifier.value = false;
      _r.bleedingInjuryStopwatch.stop();
      _r.isBleedingInjuryDisplayedNotifier.value = false;

      _b.injuryStopwatch.stop();
      _b.isInjuryDisplayedNotifier.value = false;
      _b.bleedingInjuryStopwatch.stop();
      _b.isBleedingInjuryDisplayedNotifier.value = false;
    });
    mainStopwatch.boutStopwatch.onStop.stream.listen((event) async {
      _r.activityStopwatch?.stop();
      _b.activityStopwatch?.stop();
      bout = bout.copyWith(duration: event);

      // Save time to database on each stop
      await (await ref.read(dataManagerProvider)).createOrUpdateSingle(bout);
    });
    mainStopwatch.boutStopwatch.onAdd.stream.listen((event) {
      _r.activityStopwatch?.add(event);
      _b.activityStopwatch?.add(event);
    });
    mainStopwatch.boutStopwatch.onChangeSecond.stream.listen((event) {
      if (!mainStopwatch.isBreak.value) {
        bout = bout.copyWith(duration: event);

        // If is above the time of the current period, then trigger the break
        if (bout.duration.compareTo(boutConfig.periodDuration * period) >= 0) {
          // Set to exact period end, as internal duration of stopwatch usually is a few milliseconds ahead of the second listener.
          // Otherwise the timer is displaying a different time (2:59.9) than expected (3:00.0) after a break.
          mainStopwatch.boutStopwatch.stopAt(event);
          if (_r.activityStopwatch != null) {
            _r.activityStopwatch!.dispose();
            _r.activityStopwatchNotifier.value = null;
          }
          if (_b.activityStopwatch != null) {
            _b.activityStopwatch!.dispose();
            _b.activityStopwatchNotifier.value = null;
          }
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
  }

  @override
  void dispose() {
    _boutSubscription.close();
    _onEndBreakStopwatchSubscription.cancel();
    super.dispose();
  }

  Widget displayTechnicalPoints(ParticipantStateModel pStatus, BoutRole role) {
    return Expanded(
      flex: 33,
      child: TechnicalPoints(pStatusModel: pStatus, role: role, bout: bout, boutConfig: boutConfig),
    );
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

          await handleIntent(const BoutScreenActionIntent.horn());
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

    if (useSmartBoutActions) {
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
          Future<bool> hadZeroOrOnePassivity(BoutRole role) async {
            // At this moment, the new passivity is not yet updated by the websocket (even if freshly getting the list),
            // so we need to treat them as one less.
            return prevActions!.where((la) => la.role == role && la.actionType == BoutActionType.passivity).length <= 1;
          }

          // In greco, stop the timer (P)
          // Give one point to the opponent at the first and the second (P).
          mainStopwatch.stopwatch.stop();
          if (!await hadZeroOrOnePassivity(BoutRole.red)) return;
          await handleIntent(RolePointBoutActionIntent(role: intent.role.opponent, points: 1));
        }
      } else if (intent is RolePointBoutActionIntent) {
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

  Widget row({required List<Widget> children, EdgeInsets? padding}) {
    return Container(
      padding: padding,
      child: IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: children)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final double width = MediaQuery.of(context).size.width;
    final double padding = width / 100;
    final bottomPadding = EdgeInsets.only(bottom: padding);

    final pdfAction = ResponsiveScaffoldActionItem(
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
          Printing.sharePdf(bytes: bytes, filename: '${bout.getFileBaseName(widget.wrestlingEvent)}.pdf');
        }
      },
    );
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        await save();
      },
      child: BoutActionHandler(
        handleIntent: handleOrCatchIntent,
        child: WindowStateScaffold(
          hideAppBarOnFullscreen: true,
          actions: [...widget.actions, pdfAction],
          body: SingleChildScrollView(
            child: Column(
              children: [
                row(
                  padding: bottomPadding,
                  children:
                      widget.headerItems
                          .asMap()
                          .entries
                          .map((entry) => Expanded(flex: flexWidths[entry.key], child: entry.value))
                          .toList(),
                ),
                row(
                  padding: bottomPadding,
                  children: [
                    Expanded(flex: 50, child: _ParticipantDisplay(bout, BoutRole.red, padding, widget.getWeightR)),
                    Expanded(
                      flex: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (widget.mat != null)
                            Center(
                              child: ScaledText('${localizations.mat} ${widget.mat}', fontSize: 22, minFontSize: 10),
                            ),
                          Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: ScaledText(
                                    '${localizations.bout} ${widget.boutIndex + 1}',
                                    fontSize: 14,
                                    minFontSize: 10,
                                  ),
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
                              child: ScaledText(
                                '${weightClass!.name} | ${weightClass!.style.abbreviation(context)}',
                                fontSize: 26,
                                minFontSize: 10,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(flex: 50, child: _ParticipantDisplay(bout, BoutRole.blue, padding, widget.getWeightB)),
                  ],
                ),
                row(
                  padding: bottomPadding,
                  children: [
                    displayTechnicalPoints(_r, BoutRole.red),
                    BoutActionControls(
                      BoutRole.red,
                      boutConfig,
                      bout.r == null ? null : handleOrCatchIntent,
                      wrestlingStyle: weightClass?.style,
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
                    BoutActionControls(
                      BoutRole.blue,
                      boutConfig,
                      bout.b == null ? null : handleOrCatchIntent,
                      wrestlingStyle: weightClass?.style,
                    ),
                    displayTechnicalPoints(_b, BoutRole.blue),
                  ],
                ),
                Container(
                  padding: bottomPadding,
                  child: ManyConsumer<BoutAction, Bout>(
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
                ),
                Container(padding: bottomPadding, child: BoutMainControls(handleOrCatchIntent, this)),
              ],
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
  final BoutRole role;
  final double padding;
  final Future<double?> Function(Bout bout)? getWeight;

  const _ParticipantDisplay(this.bout, this.role, this.padding, this.getWeight);

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
                  LoadingBuilder(
                    future: getWeight?.call(bout) ?? Future.value(null),
                    builder: (context, weight) {
                      return _NameDisplay(pStatus: pStatus, padding: padding, weight: weight);
                    },
                  ),
                  displayClassificationPoints(pStatus, color, padding),
                ];
                if (role == BoutRole.blue) items = List.from(items.reversed);
                return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: items);
              },
            );
          },
        ),
      ),
    );
  }

  Widget displayClassificationPoints(AthleteBoutState? pStatus, MaterialColor color, double padding) {
    return pStatus?.classificationPoints != null
        ? ThemedContainer(
          color: color.shade800,
          padding: EdgeInsets.symmetric(vertical: padding * 3, horizontal: padding * 2),
          child: Center(child: ScaledText(pStatus!.classificationPoints.toString(), fontSize: 54, minFontSize: 30)),
        )
        : Container();
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
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.all(padding),
            child: Center(
              child: ScaledText(
                pStatus?.fullName(context) ?? localizations.participantVacant,
                color: pStatus == null ? Colors.white30 : Colors.white,
                fontSize: 40,
                minFontSize: 20,
              ),
            ),
          ),
          SizedBox(
            child: Center(
              child: ScaledText(
                (weight != null ? '${weight!.toStringAsFixed(1)} $weightUnit' : localizations.participantUnknownWeight),
                color: weight == null ? Colors.white30 : Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
