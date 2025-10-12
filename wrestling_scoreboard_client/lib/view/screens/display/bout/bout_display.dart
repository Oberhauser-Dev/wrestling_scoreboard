import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

// TODO: check if comment is still valid.
/// Initialize with default values, but do not synchronize with live data, as during a bout the connection could be interrupted. So the client always sends data, but never should receive any.
/// If closing and reopening screen, data should be updated though.
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

  late ObservableStopwatch stopwatch;
  late ObservableStopwatch _boutStopwatch;
  late ObservableStopwatch _breakStopwatch;
  late ParticipantStateModel _r;
  late ParticipantStateModel _b;
  late BoutConfig boutConfig;
  late List<BoutResultRule> boutRules;
  late WeightClass? weightClass;

  late Bout bout;
  int period = 1;

  late final ProviderSubscription<Future<Bout>> _boutSubscription;
  late final StreamSubscription<Duration> _onEndBreakStopwatchSubscription;

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
        if (!_boutStopwatch.isDisposed) {
          _boutStopwatch.elapsed = bout.duration;
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
      setState(() {
        _r.isInjury = false;
        _r.isInjuryDisplayed = false;
      });
      handleAction(const BoutScreenActionIntent.horn());
    });
    _b.injuryStopwatch.limit = boutConfig.injuryDuration;
    _b.injuryStopwatch.onEnd.stream.listen((event) {
      setState(() {
        _b.isInjury = false;
        _b.isInjuryDisplayed = false;
      });
      handleAction(const BoutScreenActionIntent.horn());
    });

    // Bleeding injury
    _r.bleedingInjuryStopwatch.limit = boutConfig.bleedingInjuryDuration;
    _r.bleedingInjuryStopwatch.onEnd.stream.listen((event) {
      setState(() {
        _r.isBleedingInjury = false;
        _r.isBleedingInjuryDisplayed = false;
      });
      handleAction(const BoutScreenActionIntent.horn());
    });
    _b.bleedingInjuryStopwatch.limit = boutConfig.bleedingInjuryDuration;
    _b.bleedingInjuryStopwatch.onEnd.stream.listen((event) {
      setState(() {
        _b.isBleedingInjury = false;
        _b.isBleedingInjuryDisplayed = false;
      });
      handleAction(const BoutScreenActionIntent.horn());
    });

    stopwatch = _boutStopwatch = ObservableStopwatch(limit: boutConfig.totalPeriodDuration);
    _boutStopwatch.onStart.stream.listen((event) {
      _r.activityStopwatch?.start();
      _b.activityStopwatch?.start();
    });
    _boutStopwatch.onStop.stream.listen((event) async {
      _r.activityStopwatch?.stop();
      _b.activityStopwatch?.stop();
      bout = bout.copyWith(duration: event);

      // Save time to database on each stop
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(bout);
    });
    _boutStopwatch.onAdd.stream.listen((event) {
      _r.activityStopwatch?.add(event);
      _b.activityStopwatch?.add(event);
    });
    _boutStopwatch.onChangeSecond.stream.listen((event) {
      if (stopwatch == _boutStopwatch) {
        bout = bout.copyWith(duration: event);

        // If is above the time of the current period, then trigger the break
        if (bout.duration.compareTo(boutConfig.periodDuration * period) >= 0) {
          // Set to exact period end, as internal duration of stopwatch usually is a few milliseconds ahead of the second listener.
          // Otherwise the timer is displaying a different time (2:59.9) than expected (3:00.0) after a break.
          _boutStopwatch.stopAt(event);
          if (_r.activityStopwatch != null) {
            _r.activityStopwatch!.dispose();
            _r.activityStopwatch = null;
          }
          if (_b.activityStopwatch != null) {
            _b.activityStopwatch!.dispose();
            _b.activityStopwatch = null;
          }
          handleAction(const BoutScreenActionIntent.horn());
          if (period < boutConfig.periodCount) {
            setState(() {
              stopwatch = _breakStopwatch;
            });
            _breakStopwatch.start();
            period++;
          }
        } else if (bout.duration.inSeconds ~/ boutConfig.periodDuration.inSeconds < (period - 1)) {
          // Fix times below round time: e.g. if subtract time
          period -= 1;
        }
      }
    });
    stopwatch.add(bout.duration);
    _breakStopwatch = ObservableStopwatch(limit: boutConfig.breakDuration);
    _onEndBreakStopwatchSubscription = _breakStopwatch.onEnd.stream.listen((event) {
      if (stopwatch == _breakStopwatch) {
        _breakStopwatch.reset();
        setState(() {
          stopwatch = _boutStopwatch;
        });
        handleAction(const BoutScreenActionIntent.horn());
      }
    });
  }

  @override
  void dispose() {
    _boutSubscription.close();
    _onEndBreakStopwatchSubscription.cancel();
    super.dispose();
  }

  void handleAction(BoutScreenActionIntent intent) async {
    final tmpContext = context;
    if (tmpContext.mounted) {
      await catchAsync(
        tmpContext,
        () => intent.handle(
          widget.bouts,
          () async => await ref.readAsync(
            manyDataStreamProvider(ManyProviderData<BoutAction, Bout>(filterObject: bout)).future,
          ),
          widget.boutIndex,
          doAction,
          context: tmpContext,
          currentStopwatch: stopwatch,
          boutStopwatch: _boutStopwatch,
          navigateToBoutByIndex: saveAndNavigateToBoutByIndex,
          createOrUpdateAction:
              (action) async => (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(action),
          deleteAction: (action) async => (await ref.read(dataManagerNotifierProvider)).deleteSingle(action),
        ),
      );
    }
  }

  Widget displayTechnicalPoints(ParticipantStateModel pStatus, BoutRole role) {
    return Expanded(
      flex: 33,
      child: TechnicalPoints(pStatusModel: pStatus, role: role, bout: bout, boutConfig: boutConfig),
    );
  }

  void doAction(BoutScreenActions action) {
    switch (action) {
      case BoutScreenActions.redActivityTime:
        final ParticipantStateModel psm = _r;
        psm.activityStopwatch?.dispose();
        setState(() {
          psm.activityStopwatch =
              psm.activityStopwatch == null ? ObservableStopwatch(limit: boutConfig.activityDuration) : null;
        });
        if (psm.activityStopwatch != null && _boutStopwatch.isRunning) psm.activityStopwatch!.start();
        psm.activityStopwatch?.onEnd.stream.listen((event) {
          handleAction(const BoutScreenActionIntent.horn());
          psm.activityStopwatch?.dispose();
          setState(() {
            psm.activityStopwatch = null;
          });
        });
        break;
      case BoutScreenActions.redInjuryTime:
        final ParticipantStateModel psm = _r;
        setState(() {
          if (!_r.injuryStopwatch.hasEnded) {
            // If time is set manually after timer has ended, the timer and display flags differ.
            // So we use the displayed flag as the reset option.
            psm.isInjury = !psm.isInjuryDisplayed;
          }
          psm.isInjuryDisplayed = !psm.isInjuryDisplayed;
        });
        if (psm.isInjury) {
          psm.injuryStopwatch.start();
        } else {
          psm.injuryStopwatch.stop();
        }
        break;
      case BoutScreenActions.redBleedingInjuryTime:
        final ParticipantStateModel psm = _r;
        setState(() {
          if (!_r.bleedingInjuryStopwatch.hasEnded) {
            psm.isBleedingInjury = !psm.isBleedingInjuryDisplayed;
          }
          psm.isBleedingInjuryDisplayed = !psm.isBleedingInjuryDisplayed;
        });
        if (psm.isBleedingInjury) {
          psm.bleedingInjuryStopwatch.start();
        } else {
          psm.bleedingInjuryStopwatch.stop();
        }
        break;
      case BoutScreenActions.blueActivityTime:
        final ParticipantStateModel psm = _b;
        psm.activityStopwatch?.dispose();
        setState(() {
          psm.activityStopwatch =
              psm.activityStopwatch == null ? ObservableStopwatch(limit: boutConfig.activityDuration) : null;
        });
        if (psm.activityStopwatch != null && _boutStopwatch.isRunning) psm.activityStopwatch!.start();
        psm.activityStopwatch?.onEnd.stream.listen((event) {
          psm.activityStopwatch?.dispose();
          setState(() {
            psm.activityStopwatch = null;
          });
          handleAction(const BoutScreenActionIntent.horn());
        });
        break;
      case BoutScreenActions.blueInjuryTime:
        final ParticipantStateModel psm = _b;
        setState(() {
          if (!_b.injuryStopwatch.hasEnded) {
            psm.isInjury = !psm.isInjuryDisplayed;
          }
          psm.isInjuryDisplayed = !psm.isInjuryDisplayed;
        });
        if (psm.isInjury) {
          psm.injuryStopwatch.start();
        } else {
          psm.injuryStopwatch.stop();
        }
        break;
      case BoutScreenActions.blueBleedingInjuryTime:
        final ParticipantStateModel psm = _b;
        setState(() {
          if (!_b.bleedingInjuryStopwatch.hasEnded) {
            psm.isBleedingInjury = !psm.isBleedingInjuryDisplayed;
          }
          psm.isBleedingInjuryDisplayed = !psm.isBleedingInjuryDisplayed;
        });
        if (psm.isBleedingInjury) {
          psm.bleedingInjuryStopwatch.start();
        } else {
          psm.bleedingInjuryStopwatch.stop();
        }
        break;
      case BoutScreenActions.horn:
        ref.read(bellPlayerNotifierProvider).then((player) async {
          await player.stop();
          await player.resume();
        });
        break;
      default:
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

    final Color stopwatchColor = stopwatch == _breakStopwatch ? Colors.orange : Theme.of(context).colorScheme.onSurface;

    final pdfAction = ResponsiveScaffoldActionItem(
      label: localizations.print,
      icon: const Icon(Icons.print),
      onTap: () async {
        final isTimeCountDown = await ref.read(timeCountDownNotifierProvider);
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
        createOrUpdateAction:
            (action) async => (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(action),
        deleteAction: (action) async => (await ref.read(dataManagerNotifierProvider)).deleteSingle(action),
        getCurrentStopwatch: () => stopwatch,
        boutStopwatch: _boutStopwatch,
        getActions:
            () async => await ref.readAsync(
              manyDataStreamProvider(ManyProviderData<BoutAction, Bout>(filterObject: bout)).future,
            ),
        bouts: widget.bouts,
        boutIndex: widget.boutIndex,
        doAction: doAction,
        navigateToBoutByIndex: saveAndNavigateToBoutByIndex,
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
                    BoutActionControls(BoutRole.red, boutConfig, bout.r == null ? null : handleAction),
                    Expanded(
                      flex: 50,
                      child: Center(
                        child: DelayedTooltip(
                          message: '${localizations.edit} ${localizations.duration} (↑ | ↓)',
                          child: TimeDisplay(
                            showDeciSecond: true,
                            stopwatch,
                            stopwatchColor,
                            fontSize: 128,
                            maxDuration:
                                stopwatch == _breakStopwatch
                                    ? boutConfig.breakDuration
                                    : boutConfig.totalPeriodDuration,
                          ),
                        ),
                      ),
                    ),
                    BoutActionControls(BoutRole.blue, boutConfig, bout.b == null ? null : handleAction),
                    displayTechnicalPoints(_b, BoutRole.blue),
                  ],
                ),
                Container(
                  padding: bottomPadding,
                  child: ManyConsumer<BoutAction, Bout>(
                    filterObject: widget.bout,
                    builder: (context, actions) {
                      return ActionsWidget(
                        actions,
                        boutConfig: boutConfig,
                        onDeleteAction:
                            (action) async => (await ref.read(dataManagerNotifierProvider)).deleteSingle(action),
                        onCreateOrUpdateAction:
                            (action) async =>
                                (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(action),
                      );
                    },
                  ),
                ),
                Container(padding: bottomPadding, child: BoutMainControls(handleAction, this)),
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
    _boutStopwatch.dispose();
    _breakStopwatch.dispose();

    // Save time to database when dispose
    await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(bout);
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
