import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/app_state_provider.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/audio/audio.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/score_sheet.dart';
import 'package:wrestling_scoreboard_client/utils/units.dart';
import 'package:wrestling_scoreboard_client/view/models/participant_state_model.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_action_controls.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_actions.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_main_controls.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_shortcuts.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/technical_points.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/time_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';
import 'package:wrestling_scoreboard_common/common.dart';

void navigateToTeamMatchBoutScreen(BuildContext context, TeamMatch match, TeamMatchBout bout) {
  context.push('/${TeamMatchOverview.route}/${match.id}/${TeamMatchBoutDisplay.route}/${bout.id}');
}

/// Class to load a single bout, while also consider the previous and the next bout.
/// So must load the whole list of bouts to keep track of what comes next.
/// TODO: This may can be done server side with its own request in the future.
class TeamMatchBoutDisplay extends StatelessWidget {
  static const route = 'team_match_bout';
  final int matchId;
  final int teamMatchBoutId;
  final TeamMatch? initialMatch;

  const TeamMatchBoutDisplay({
    required this.matchId,
    required this.teamMatchBoutId,
    this.initialMatch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<TeamMatch>(
        id: matchId,
        initialData: initialMatch,
        builder: (context, match) {
          return ManyConsumer<TeamMatchBout, TeamMatch>(
              filterObject: match,
              builder: (context, teamMatchBouts) {
                if (teamMatchBouts.isEmpty) {
                  return Center(
                    child: Text(
                      localizations.noItems,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }
                final teamMatchBout = teamMatchBouts.singleWhere((element) => element.id == teamMatchBoutId);
                final teamMatchBoutIndex = teamMatchBouts.indexOf(teamMatchBout);
                // Use bout to get the actual state, but use teamMatchBout for navigation.
                return SingleConsumer<Bout>(
                    id: teamMatchBout.bout.id,
                    initialData: teamMatchBout.bout,
                    builder: (context, bout) {
                      return BoutScreen(
                        wrestlingEvent: match,
                        boutConfig: match.league?.boutConfig ?? const BoutConfig(),
                        bouts: teamMatchBouts.map((e) => e.bout).toList(),
                        boutIndex: teamMatchBoutIndex,
                        bout: bout,
                        onPressBoutInfo: (BuildContext context) {
                          context.push('/${TeamMatchBoutOverview.route}/${teamMatchBout.id}');
                        },
                        navigateToBoutByIndex: (context, index) {
                          context.pop();
                          navigateToTeamMatchBoutScreen(context, match, teamMatchBouts[index]);
                        },
                        home: match.home.team,
                        guest: match.guest.team,
                      );
                    });
              });
        });
  }
}

/// Initialize with default values, but do not synchronize with live data, as during a bout the connection could be interrupted. So the client always sends data, but never should receive any.
/// If closing and reopening screen, data should be updated though.
class BoutScreen extends ConsumerStatefulWidget {
  final WrestlingEvent wrestlingEvent;
  final List<Bout> bouts;
  final Bout bout;

  // TODO: may overwrite in settings to be more flexible
  final BoutConfig boutConfig;
  final Team home;
  final Team guest;
  final int boutIndex;
  final void Function(BuildContext context) onPressBoutInfo;
  final void Function(BuildContext context, int boutIndex) navigateToBoutByIndex;

  const BoutScreen({
    required this.bouts,
    required this.bout,
    required this.boutIndex,
    required this.home,
    required this.guest,
    required this.onPressBoutInfo,
    required this.navigateToBoutByIndex,
    required this.boutConfig,
    required this.wrestlingEvent,
    super.key,
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

  late Bout bout;
  int period = 1;

  @override
  initState() {
    super.initState();
    HornSound();
    boutConfig = widget.boutConfig;
    bout = widget.bout;
    // Set the current period based on the duration:
    period = (bout.duration.inSeconds ~/ boutConfig.periodDuration.inSeconds) + 1;
    _r = ParticipantStateModel(bout.r);
    _b = ParticipantStateModel(bout.b);
    _r.injuryStopwatch.limit = boutConfig.injuryDuration;
    _r.injuryStopwatch.onEnd.stream.listen((event) {
      setState(() {
        _r.isInjury = false;
      });
      handleAction(const BoutScreenActionIntent.horn());
    });
    _b.injuryStopwatch.limit = boutConfig.injuryDuration;
    _b.injuryStopwatch.onEnd.stream.listen((event) {
      setState(() {
        _b.isInjury = false;
      });
      handleAction(const BoutScreenActionIntent.horn());
    });

    stopwatch = _boutStopwatch = ObservableStopwatch(
      limit: boutConfig.periodDuration * boutConfig.periodCount,
    );
    _boutStopwatch.onStart.stream.listen((event) {
      _r.activityStopwatch?.start();
      _b.activityStopwatch?.start();
    });
    _boutStopwatch.onStop.stream.listen((event) async {
      _r.activityStopwatch?.stop();
      _b.activityStopwatch?.stop();

      // Save time to database on each stop
      (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(bout);
    });
    _boutStopwatch.onAdd.stream.listen((event) {
      _r.activityStopwatch?.addDuration(event);
      _b.activityStopwatch?.addDuration(event);
    });
    _boutStopwatch.onChangeSecond.stream.listen(
      (event) {
        if (stopwatch == _boutStopwatch) {
          bout = bout.copyWith(duration: event);

          // If is above the time of the current period, then trigger the break
          if (bout.duration.compareTo(boutConfig.periodDuration * period) >= 0) {
            _boutStopwatch.stop();
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
      },
    );
    stopwatch.addDuration(bout.duration);
    _breakStopwatch = ObservableStopwatch(
      limit: boutConfig.breakDuration,
    );
    _breakStopwatch.onEnd.stream.listen((event) {
      if (stopwatch == _breakStopwatch) {
        _breakStopwatch.reset();
        setState(() {
          stopwatch = _boutStopwatch;
        });
        handleAction(const BoutScreenActionIntent.horn());
      }
    });
  }

  void handleAction(BoutScreenActionIntent intent) async {
    final tmpContext = context;
    final dataManager = await ref.read(dataManagerNotifierProvider);
    if (tmpContext.mounted) {
      try {
        await intent.handle(
          dataManager,
          stopwatch,
          widget.bouts,
          getActions,
          widget.boutIndex,
          doAction,
          context: tmpContext,
          navigateToBoutByIndex: saveAndNavigateToBoutByIndex,
        );
      } on Exception catch (e) {
        if (context.mounted) {
          await showExceptionDialog(
            context: tmpContext,
            exception: e,
          );
        }
      }
    }
  }

  Future<List<BoutAction>> getActions() =>
      ref.read(manyDataStreamProvider<BoutAction, Bout>(ManyProviderData<BoutAction, Bout>(filterObject: bout)).future);

  displayName(ParticipantState? pStatus, double padding) {
    final localizations = AppLocalizations.of(context)!;
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
                  fontSize: 28,
                  minFontSize: 20,
                ),
              )),
          SizedBox(
              child: Center(
                  child: ScaledText(
                      (pStatus?.participation.weight != null
                          ? '${pStatus?.participation.weight!.toStringAsFixed(1)} $weightUnit'
                          : AppLocalizations.of(context)!.participantUnknownWeight),
                      color: pStatus?.participation.weight == null ? Colors.white30 : Colors.white))),
        ],
      ),
    );
  }

  displayClassificationPoints(ParticipantState? pStatus, MaterialColor color, double padding) {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(manyDataStreamProvider<BoutAction, Bout>(
            ManyProviderData<BoutAction, Bout>(filterObject: bout))); // TODO: replace by participantNotifierProvider
        return pStatus?.classificationPoints != null
            ? ThemedContainer(
                color: color.shade800,
                padding: EdgeInsets.symmetric(vertical: padding * 3, horizontal: padding * 2),
                child: Center(
                  child: ScaledText(
                    pStatus!.classificationPoints.toString(),
                    fontSize: 46,
                    minFontSize: 30,
                  ),
                ),
              )
            : Container();
      },
    );
  }

  displayTechnicalPoints(ParticipantStateModel pStatus, BoutRole role) {
    return Expanded(
      flex: 33,
      child: TechnicalPoints(
        pStatusModel: pStatus,
        role: role,
        bout: bout,
      ),
    );
  }

  displayParticipant(ParticipantState? pStatus, BoutRole role, double padding) {
    var color = role.color();

    return ThemedContainer(
      color: color,
      child: IntrinsicHeight(
        child: NullableSingleConsumer<ParticipantState>(
          id: pStatus?.id,
          initialData: pStatus,
          builder: (context, pStatus) {
            List<Widget> items = [
              displayName(pStatus, padding),
              displayClassificationPoints(pStatus, color, padding),
            ];
            if (role == BoutRole.blue) items = List.from(items.reversed);
            return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: items);
          },
        ),
      ),
    );
  }

  doAction(BoutScreenActions action) {
    switch (action) {
      case BoutScreenActions.redActivityTime:
        ParticipantStateModel psm = _r;
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
        ParticipantStateModel psm = _r;
        setState(() {
          psm.isInjury = !psm.isInjury;
        });
        if (psm.isInjury) {
          psm.injuryStopwatch.start();
        } else {
          psm.injuryStopwatch.stop();
        }
        break;
      case BoutScreenActions.blueActivityTime:
        ParticipantStateModel psm = _b;
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
        ParticipantStateModel psm = _b;
        setState(() {
          psm.isInjury = !psm.isInjury;
        });
        if (psm.isInjury) {
          psm.injuryStopwatch.start();
        } else {
          psm.injuryStopwatch.stop();
        }
        break;
      default:
        break;
    }
  }

  row({required List<Widget> children, EdgeInsets? padding}) {
    return Container(
        padding: padding,
        child: IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: children)));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    double width = MediaQuery.of(context).size.width;
    double padding = width / 100;
    final bottomPadding = EdgeInsets.only(bottom: padding);

    Color stopwatchColor = stopwatch == _breakStopwatch ? Colors.orange : Theme.of(context).colorScheme.onBackground;

    final shareAction = IconButton(
      icon: const Icon(Icons.share),
      onPressed: () async {
        final bytes = await generateScoreSheet(this, localizations: localizations);
        Printing.sharePdf(bytes: bytes);
      },
    );
    final infoAction = IconButton(
      icon: const Icon(Icons.info),
      onPressed: () => widget.onPressBoutInfo(context),
    );
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        await save();
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      child: ManyConsumer<BoutAction, Bout>(
          filterObject: bout,
          builder: (context, actions) {
            return BoutActionHandler(
              stopwatch: stopwatch,
              getActions: () async => actions,
              bouts: widget.bouts,
              boutIndex: widget.boutIndex,
              doAction: doAction,
              navigateToBoutByIndex: saveAndNavigateToBoutByIndex,
              child: Consumer(builder: (context, ref, child) {
                return LoadingBuilder<WindowState>(
                  future: ref.watch(windowStateNotifierProvider),
                  builder: (BuildContext context, WindowState data) {
                    final isFullScreen = data == WindowState.fullscreen;
                    return Scaffold(
                      appBar: isFullScreen
                          ? null
                          : AppBar(
                              actions: [infoAction, shareAction, CommonElements.getFullScreenAction(context, ref)]),
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            row(
                                padding: bottomPadding,
                                children: CommonElements.getTeamHeader(widget.home, widget.guest, widget.bouts, context)
                                    .asMap()
                                    .entries
                                    .map((entry) => Expanded(flex: flexWidths[entry.key], child: entry.value))
                                    .toList()),
                            row(padding: bottomPadding, children: [
                              Expanded(
                                flex: 50,
                                child: displayParticipant(bout.r, BoutRole.red, padding),
                              ),
                              Expanded(
                                  flex: 20,
                                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                    Row(children: [
                                      Expanded(
                                          child: Center(
                                              child: ScaledText(
                                        '${AppLocalizations.of(context)!.bout} ${widget.boutIndex + 1}',
                                        minFontSize: 10,
                                      ))),
                                    ]),
                                    if (bout.weightClass != null)
                                      Center(
                                          child: ScaledText(
                                        '${bout.weightClass!.style.localize(context)}',
                                        minFontSize: 10,
                                      )),
                                    if (bout.weightClass != null)
                                      Center(
                                          child: ScaledText(
                                        bout.weightClass!.name,
                                        minFontSize: 10,
                                      )),
                                  ])),
                              Expanded(
                                flex: 50,
                                child: displayParticipant(bout.b, BoutRole.blue, padding),
                              ),
                            ]),
                            row(
                              padding: bottomPadding,
                              children: [
                                displayTechnicalPoints(_r, BoutRole.red),
                                BoutActionControls(BoutRole.red, bout.r == null ? null : handleAction),
                                Expanded(
                                  flex: 50,
                                  child: Center(child: TimeDisplay(stopwatch, stopwatchColor, fontSize: 100)),
                                ),
                                BoutActionControls(BoutRole.blue, bout.b == null ? null : handleAction),
                                displayTechnicalPoints(_b, BoutRole.blue),
                              ],
                            ),
                            Container(
                              padding: bottomPadding,
                              child: ActionsWidget(actions),
                            ),
                            Container(padding: bottomPadding, child: BoutMainControls(handleAction, this)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            );
          }),
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
