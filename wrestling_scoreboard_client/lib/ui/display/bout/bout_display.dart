import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard_client/data/bout_role.dart';
import 'package:wrestling_scoreboard_client/data/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/exception.dart';
import 'package:wrestling_scoreboard_client/ui/components/scaled_text.dart';
import 'package:wrestling_scoreboard_client/ui/display/bout/bout_action_controls.dart';
import 'package:wrestling_scoreboard_client/ui/display/bout/bout_actions.dart';
import 'package:wrestling_scoreboard_client/ui/display/bout/bout_main_controls.dart';
import 'package:wrestling_scoreboard_client/ui/display/bout/bout_shortcuts.dart';
import 'package:wrestling_scoreboard_client/ui/display/bout/technical_points.dart';
import 'package:wrestling_scoreboard_client/ui/display/bout/time_display.dart';
import 'package:wrestling_scoreboard_client/ui/display/common.dart';
import 'package:wrestling_scoreboard_client/ui/models/participant_state_model.dart';
import 'package:wrestling_scoreboard_client/ui/overview/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/ui/utils.dart';
import 'package:wrestling_scoreboard_client/util/audio/audio.dart';
import 'package:wrestling_scoreboard_client/util/colors.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_client/util/print/pdf/score_sheet.dart';
import 'package:wrestling_scoreboard_client/util/units.dart';
import 'package:wrestling_scoreboard_common/common.dart';

void navigateToBoutScreen(BuildContext context, TeamMatch match, Bout bout) async {
  context.push('/${TeamMatchOverview.route}/${match.id}/${BoutDisplay.route}/${bout.id}');
}

/// Class to load a single bout, while also consider the previous and the next bout.
/// So must load the whole list of bouts to keep track of what comes next.
/// TODO: This may can be done server side with its own request in the future.
class BoutDisplay extends StatelessWidget {
  static const route = 'bout';
  final int matchId;
  final int boutId;
  final TeamMatch? initialMatch;

  const BoutDisplay({
    required this.matchId,
    required this.boutId,
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
          if (match == null) return ExceptionWidget(localizations.notFoundException);
          return ManyConsumer<Bout, TeamMatch>(
              filterObject: match,
              builder: (context, bouts) {
                if (bouts.isEmpty) {
                  return Center(
                    child: Text(
                      localizations.noItems,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }
                final currentBout = bouts.singleWhere((element) => element.id == boutId);
                final currentBoutIndex = bouts.indexOf(currentBout);
                return ManyConsumer<BoutAction, Bout>(
                    filterObject: currentBout,
                    builder: (context, actions) {
                      return BoutScreen(match, bouts, actions, currentBoutIndex);
                    });
              });
        });
  }
}

/// Initialize with default values, but do not synchronize with live data, as during a bout the connection could be interrupted. So the client always sends data, but never should receive any.
/// If closing and reopening screen, data should be updated though.
class BoutScreen extends StatefulWidget {
  final TeamMatch match;
  final List<Bout> bouts;
  final List<BoutAction> actions;
  final int boutIndex;

  const BoutScreen(this.match, this.bouts, this.actions, this.boutIndex, {super.key});

  @override
  State<StatefulWidget> createState() => BoutState();
}

class BoutState extends State<BoutScreen> {
  static const flexWidths = [50, 30, 50];

  final StreamController<List<BoutAction>> _onChangeActions = StreamController.broadcast();
  late TeamMatch match;
  late Bout bout;
  late List<Bout> bouts;
  late List<BoutAction> actions;
  late int boutIndex;
  late ObservableStopwatch stopwatch;
  late ObservableStopwatch _boutStopwatch;
  late ObservableStopwatch _breakStopwatch;
  late ParticipantStateModel _r;
  late ParticipantStateModel _b;
  late BoutConfig boutConfig;
  int period = 1;
  late Function(BoutScreenActionIntent) handleAction;

  List<BoutAction> getActions() => actions;

  setActions(List<BoutAction> actions) {
    _onChangeActions.add(List.of(actions));
  }

  @override
  initState() {
    super.initState();
    HornSound();
    match = widget.match;
    bouts = widget.bouts;
    // TODO: may overwrite in settings to be more flexible
    boutConfig = match.league?.boutConfig ?? const BoutConfig();
    actions = widget.actions;
    boutIndex = widget.boutIndex;
    bout = widget.bouts[boutIndex];
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
    _boutStopwatch.onStop.stream.listen((event) {
      _r.activityStopwatch?.stop();
      _b.activityStopwatch?.stop();

      // Save time to database on each stop
      dataProvider.createOrUpdateSingle(bout);
    });
    _boutStopwatch.onAdd.stream.listen((event) {
      _r.activityStopwatch?.addDuration(event);
      _b.activityStopwatch?.addDuration(event);
    });
    _boutStopwatch.onChangeSecond.stream.listen(
      (event) {
        if (stopwatch == _boutStopwatch) {
          bout = bout.copyWith(duration: event);

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
    _onChangeActions.stream.listen((actions) {
      this.actions = actions;
    });
    setActions(actions);
    handleAction = (BoutScreenActionIntent intent) {
      BoutActionHandler.handleIntentStatic(intent, stopwatch, match, bouts, getActions, setActions, boutIndex, doAction,
          context: context);
    };
  }

  displayName(ParticipantState? pStatus, double padding) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              padding: EdgeInsets.all(padding),
              child: Center(
                child: ScaledText(
                  pStatus?.participation.membership.person.fullName ?? AppLocalizations.of(context)!.participantVacant,
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
    return Consumer<ParticipantState?>(
      builder: (context, data, child) => pStatus?.classificationPoints != null
          ? Container(
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
          : Container(),
    );
  }

  displayTechnicalPoints(ParticipantStateModel pStatus, BoutRole role) {
    return Expanded(
      flex: 33,
      child: TechnicalPoints(
        pStatusModel: pStatus,
        role: role,
      ),
    );
  }

  displayParticipant(ParticipantState? pStatus, BoutRole role, double padding) {
    var color = getColorFromBoutRole(role);

    return Container(
      color: color,
      child: IntrinsicHeight(
        child: SingleConsumer<ParticipantState>(
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
          handleAction(const BoutScreenActionIntent.horn());
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

    MaterialColor stopwatchColor = stopwatch == _breakStopwatch ? Colors.orange : white;

    final shareAction = IconButton(
      icon: const Icon(Icons.share),
      onPressed: () async {
        final bytes = await generateScoreSheet(this, localizations: localizations);
        Printing.sharePdf(bytes: bytes);
      },
    );
    return BoutActionHandler(
      stopwatch: stopwatch,
      match: match,
      getActions: getActions,
      setActions: setActions,
      bouts: bouts,
      boutIndex: boutIndex,
      doAction: doAction,
      child: Scaffold(
        appBar: isMobile ? AppBar(actions: [shareAction]) : null,
        bottomNavigationBar: isMobile
            ? null
            : BottomAppBar(
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                  shareAction,
                ]),
              ),
        body: StreamProvider<List<BoutAction>>(
          initialData: actions,
          create: (context) => _onChangeActions.stream,
          child: SingleChildScrollView(
            child: Column(
              children: [
                row(
                    padding: bottomPadding,
                    children: CommonElements.getTeamHeader(match, bouts, context)
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
                            '${AppLocalizations.of(context)!.bout} ${boutIndex + 1}',
                            minFontSize: 10,
                          ))),
                        ]),
                        Center(
                            child: ScaledText(
                          '${styleToString(bout.weightClass.style, context)}',
                          minFontSize: 10,
                        )),
                        Center(
                            child: ScaledText(
                          bout.weightClass.name,
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
                    Expanded(flex: 50, child: Center(child: TimeDisplay(stopwatch, stopwatchColor, fontSize: 100))),
                    BoutActionControls(BoutRole.blue, bout.b == null ? null : handleAction),
                    displayTechnicalPoints(_b, BoutRole.blue),
                  ],
                ),
                Container(
                  padding: bottomPadding,
                  child: Consumer<List<BoutAction>>(
                    builder: (context, actions, child) => ActionsWidget(actions),
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

  @override
  void dispose() async {
    super.dispose();
    _boutStopwatch.dispose();
    _breakStopwatch.dispose();
  }
}
