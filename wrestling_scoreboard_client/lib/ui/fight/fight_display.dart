import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard_client/data/fight_role.dart';
import 'package:wrestling_scoreboard_client/data/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/exception.dart';
import 'package:wrestling_scoreboard_client/ui/components/scaled_text.dart';
import 'package:wrestling_scoreboard_client/ui/fight/fight_action_controls.dart';
import 'package:wrestling_scoreboard_client/ui/fight/fight_shortcuts.dart';
import 'package:wrestling_scoreboard_client/ui/fight/technical_points.dart';
import 'package:wrestling_scoreboard_client/ui/fight/time_display.dart';
import 'package:wrestling_scoreboard_client/ui/match/common_elements.dart';
import 'package:wrestling_scoreboard_client/ui/models/participant_state_model.dart';
import 'package:wrestling_scoreboard_client/ui/overview/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/ui/utils.dart';
import 'package:wrestling_scoreboard_client/util/audio/audio.dart';
import 'package:wrestling_scoreboard_client/util/colors.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_client/util/print/pdf/score_sheet.dart';
import 'package:wrestling_scoreboard_client/util/units.dart';
import 'package:wrestling_scoreboard_common/common.dart';

import 'fight_actions.dart';
import 'fight_main_controls.dart';

void navigateToFightScreen(BuildContext context, TeamMatch match, Fight fight) async {
  context.push('/${TeamMatchOverview.route}/${match.id}/${FightDisplay.route}/${fight.id}');
}

/// Class to load a single fight, while also consider the previous and the next fight.
/// So must load the whole list of fights to keep track of what comes next.
/// TODO: This may can be done server side with its own request in the future.
class FightDisplay extends StatelessWidget {
  static const route = 'fight';
  final int matchId;
  final int fightId;
  final TeamMatch? initialMatch;

  const FightDisplay({
    required this.matchId,
    required this.fightId,
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
          return ManyConsumer<Fight, TeamMatch>(
              filterObject: match,
              builder: (context, fights) {
                if (fights.isEmpty) {
                  return Center(
                    child: Text(
                      localizations.noItems,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }
                final currentFight = fights.singleWhere((element) => element.id == fightId);
                final currentFightIndex = fights.indexOf(currentFight);
                return ManyConsumer<FightAction, Fight>(
                    filterObject: currentFight,
                    builder: (context, actions) {
                      return FightScreen(match, fights, actions, currentFightIndex);
                    });
              });
        });
  }
}

/// Initialize with default values, but do not synchronize with live data, as during a fight the connection could be interrupted. So the client always sends data, but never should receive any.
/// If closing and reopening screen, data should be updated though.
class FightScreen extends StatefulWidget {
  final TeamMatch match;
  final List<Fight> fights;
  final List<FightAction> actions;
  final int fightIndex;

  const FightScreen(this.match, this.fights, this.actions, this.fightIndex, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FightState();
}

class FightState extends State<FightScreen> {
  static const flexWidths = [50, 30, 50];

  final StreamController<List<FightAction>> _onChangeActions = StreamController.broadcast();
  late TeamMatch match;
  late Fight fight;
  late List<Fight> fights;
  late List<FightAction> actions;
  late int fightIndex;
  late ObservableStopwatch stopwatch;
  late ObservableStopwatch _fightStopwatch;
  late ObservableStopwatch _breakStopwatch;
  late ParticipantStateModel _r;
  late ParticipantStateModel _b;
  late BoutConfig boutConfig;
  int period = 1;
  late Function(FightScreenActionIntent) handleAction;

  List<FightAction> getActions() => actions;

  setActions(List<FightAction> actions) {
    _onChangeActions.add(List.of(actions));
  }

  @override
  initState() {
    super.initState();
    HornSound();
    match = widget.match;
    fights = widget.fights;
    // TODO: may overwrite in settings to be more flexible
    boutConfig = match.league?.boutConfig ?? const BoutConfig();
    actions = widget.actions;
    fightIndex = widget.fightIndex;
    fight = widget.fights[fightIndex];
    _r = ParticipantStateModel(fight.r);
    _b = ParticipantStateModel(fight.b);
    _r.injuryStopwatch.limit = boutConfig.injuryDuration;
    _r.injuryStopwatch.onEnd.stream.listen((event) {
      setState(() {
        _r.isInjury = false;
      });
      handleAction(const FightScreenActionIntent.horn());
    });
    _b.injuryStopwatch.limit = boutConfig.injuryDuration;
    _b.injuryStopwatch.onEnd.stream.listen((event) {
      setState(() {
        _b.isInjury = false;
      });
      handleAction(const FightScreenActionIntent.horn());
    });

    stopwatch = _fightStopwatch = ObservableStopwatch(
      limit: boutConfig.periodDuration * boutConfig.periodCount,
    );
    _fightStopwatch.onStart.stream.listen((event) {
      _r.activityStopwatch?.start();
      _b.activityStopwatch?.start();
    });
    _fightStopwatch.onStop.stream.listen((event) {
      _r.activityStopwatch?.stop();
      _b.activityStopwatch?.stop();

      // Save time to database on each stop
      dataProvider.createOrUpdateSingle(fight);
    });
    _fightStopwatch.onAdd.stream.listen((event) {
      _r.activityStopwatch?.addDuration(event);
      _b.activityStopwatch?.addDuration(event);
    });
    _fightStopwatch.onChangeSecond.stream.listen(
      (event) {
        if (stopwatch == _fightStopwatch) {
          fight = fight.copyWith(duration: event);

          if (fight.duration.compareTo(boutConfig.periodDuration * period) >= 0) {
            _fightStopwatch.stop();
            if (_r.activityStopwatch != null) {
              _r.activityStopwatch!.dispose();
              _r.activityStopwatch = null;
            }
            if (_b.activityStopwatch != null) {
              _b.activityStopwatch!.dispose();
              _b.activityStopwatch = null;
            }
            handleAction(const FightScreenActionIntent.horn());
            if (period < boutConfig.periodCount) {
              setState(() {
                stopwatch = _breakStopwatch;
              });
              _breakStopwatch.start();
              period++;
            }
          } else if (fight.duration.inSeconds ~/ boutConfig.periodDuration.inSeconds < (period - 1)) {
            // Fix times below round time: e.g. if subtract time
            period -= 1;
          }
        }
      },
    );
    stopwatch.addDuration(fight.duration);
    _breakStopwatch = ObservableStopwatch(
      limit: boutConfig.breakDuration,
    );
    _breakStopwatch.onEnd.stream.listen((event) {
      if (stopwatch == _breakStopwatch) {
        _breakStopwatch.reset();
        setState(() {
          stopwatch = _fightStopwatch;
        });
        handleAction(const FightScreenActionIntent.horn());
      }
    });
    _onChangeActions.stream.listen((actions) {
      this.actions = actions;
    });
    setActions(actions);
    handleAction = (FightScreenActionIntent intent) {
      FightActionHandler.handleIntentStatic(
          intent, stopwatch, match, fights, getActions, setActions, fightIndex, doAction,
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

  displayTechnicalPoints(ParticipantStateModel pStatus, FightRole role) {
    return Expanded(
      flex: 33,
      child: TechnicalPoints(
        pStatusModel: pStatus,
        role: role,
      ),
    );
  }

  displayParticipant(ParticipantState? pStatus, FightRole role, double padding) {
    var color = getColorFromFightRole(role);

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
            if (role == FightRole.blue) items = List.from(items.reversed);
            return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: items);
          },
        ),
      ),
    );
  }

  doAction(FightScreenActions action) {
    switch (action) {
      case FightScreenActions.redActivityTime:
        ParticipantStateModel psm = _r;
        psm.activityStopwatch?.dispose();
        setState(() {
          psm.activityStopwatch =
              psm.activityStopwatch == null ? ObservableStopwatch(limit: boutConfig.activityDuration) : null;
        });
        if (psm.activityStopwatch != null && _fightStopwatch.isRunning) psm.activityStopwatch!.start();
        psm.activityStopwatch?.onEnd.stream.listen((event) {
          handleAction(const FightScreenActionIntent.horn());
          psm.activityStopwatch?.dispose();
          setState(() {
            psm.activityStopwatch = null;
          });
          handleAction(const FightScreenActionIntent.horn());
        });
        break;
      case FightScreenActions.redInjuryTime:
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
      case FightScreenActions.blueActivityTime:
        ParticipantStateModel psm = _b;
        psm.activityStopwatch?.dispose();
        setState(() {
          psm.activityStopwatch =
              psm.activityStopwatch == null ? ObservableStopwatch(limit: boutConfig.activityDuration) : null;
        });
        if (psm.activityStopwatch != null && _fightStopwatch.isRunning) psm.activityStopwatch!.start();
        psm.activityStopwatch?.onEnd.stream.listen((event) {
          psm.activityStopwatch?.dispose();
          setState(() {
            psm.activityStopwatch = null;
          });
          handleAction(const FightScreenActionIntent.horn());
        });
        break;
      case FightScreenActions.blueInjuryTime:
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
    return FightActionHandler(
      stopwatch: stopwatch,
      match: match,
      getActions: getActions,
      setActions: setActions,
      fights: fights,
      fightIndex: fightIndex,
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
        body: StreamProvider<List<FightAction>>(
          initialData: actions,
          create: (context) => _onChangeActions.stream,
          child: SingleChildScrollView(
            child: Column(
              children: [
                row(
                    padding: bottomPadding,
                    children: CommonElements.getTeamHeader(match, fights, context)
                        .asMap()
                        .entries
                        .map((entry) => Expanded(flex: flexWidths[entry.key], child: entry.value))
                        .toList()),
                row(padding: bottomPadding, children: [
                  Expanded(
                    flex: 50,
                    child: displayParticipant(fight.r, FightRole.red, padding),
                  ),
                  Expanded(
                      flex: 20,
                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        Row(children: [
                          Expanded(
                              child: Center(
                                  child: ScaledText(
                            '${AppLocalizations.of(context)!.fight} ${fightIndex + 1}',
                            minFontSize: 10,
                          ))),
                        ]),
                        Center(
                            child: ScaledText(
                          '${styleToString(fight.weightClass.style, context)}',
                          minFontSize: 10,
                        )),
                        Center(
                            child: ScaledText(
                          fight.weightClass.name,
                          minFontSize: 10,
                        )),
                      ])),
                  Expanded(
                    flex: 50,
                    child: displayParticipant(fight.b, FightRole.blue, padding),
                  ),
                ]),
                row(
                  padding: bottomPadding,
                  children: [
                    displayTechnicalPoints(_r, FightRole.red),
                    Expanded(flex: 2, child: FightActionControls(FightRole.red, fight.r == null ? null : handleAction)),
                    Expanded(flex: 50, child: Center(child: TimeDisplay(stopwatch, stopwatchColor, fontSize: 100))),
                    Expanded(
                        flex: 2, child: FightActionControls(FightRole.blue, fight.b == null ? null : handleAction)),
                    displayTechnicalPoints(_b, FightRole.blue),
                  ],
                ),
                Container(
                  padding: bottomPadding,
                  child: Consumer<List<FightAction>>(
                    builder: (context, actions, child) => ActionsWidget(actions),
                  ),
                ),
                Container(padding: bottomPadding, child: FightMainControls(handleAction, this)),
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
    _fightStopwatch.dispose();
    _breakStopwatch.dispose();
  }
}
