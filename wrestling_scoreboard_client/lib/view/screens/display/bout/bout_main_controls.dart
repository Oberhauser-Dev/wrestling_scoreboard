import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_shortcuts.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tooltip.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class BoutMainControls extends ConsumerStatefulWidget {
  final Function(BoutScreenActionIntent) callback;
  final BoutState boutState;

  const BoutMainControls(this.callback, this.boutState, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BoutMainControlsState();
}

class BoutMainControlsState extends ConsumerState<BoutMainControls> {
  bool _isRunning = false;

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    widget.boutState.stopwatch.onStartStop.stream.listen((isRunning) {
      if (mounted) {
        setState(() {
          _isRunning = isRunning;
        });
      }
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(flex: 35, child: displayDropDown(BoutRole.red)),
        Expanded(
            flex: 50,
            child: Row(
              children: [
                Expanded(
                    child: widget.boutState.widget.bouts.first == widget.boutState.bout
                        ? IconButton(
                            color: Theme.of(context).disabledColor,
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              widget.callback(const BoutScreenActionIntent.quit());
                            },
                          )
                        : DelayedTooltip(
                            message: '${localizations.previous} (←)',
                            child: IconButton(
                              color: Theme.of(context).disabledColor,
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                widget.callback(const BoutScreenActionIntent.previousBout());
                              },
                            ),
                          )),
                Expanded(
                    child: DelayedTooltip(
                  message: '${_isRunning ? localizations.pause : localizations.start} (Space)',
                  child: IconButton(
                      onPressed: () => widget.callback(const BoutScreenActionIntent.startStop()),
                      icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow)),
                )),
                Expanded(
                    child: IconButton(
                        onPressed: () => widget.callback(const BoutScreenActionIntent.horn()),
                        icon: const Icon(Icons.campaign))),
                Expanded(
                    child: widget.boutState.widget.bouts.last == widget.boutState.bout
                        ? IconButton(
                            color: Theme.of(context).disabledColor,
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              widget.callback(const BoutScreenActionIntent.quit());
                            },
                          )
                        : DelayedTooltip(
                            message: '${localizations.next} (→)',
                            child: IconButton(
                              color: Theme.of(context).disabledColor,
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () {
                                widget.callback(const BoutScreenActionIntent.nextBout());
                              },
                            ),
                          )),
              ],
            )),
        Expanded(flex: 35, child: displayDropDown(BoutRole.blue)),
      ],
    );
  }

  displayDropDown(BoutRole role) {
    AthleteBoutState? pStatus = role == BoutRole.red ? widget.boutState.bout.r : widget.boutState.bout.b;
    AthleteBoutState? pStatusOpponent = role == BoutRole.blue ? widget.boutState.bout.r : widget.boutState.bout.b;

    return ThemedContainer(
      color: role == widget.boutState.bout.winnerRole ? role.color() : null,
      child: ButtonTheme(
          alignedDropdown: true,
          child: ManyConsumer<BoutAction, Bout>(
            filterObject: widget.boutState.bout,
            builder: (context, actions) {
              // Empty List, if pStatus is empty
              final List<DropdownMenuItem<BoutResult>> boutResultOptions = [];
              if (pStatus != null) {
                final boutResultValues = List.of(BoutResult.values);
                if (pStatusOpponent == null) {
                  // Cannot select this option, as there is no opponent
                  boutResultValues.remove(BoutResult.bothDsq);
                  boutResultValues.remove(BoutResult.bothVin);
                  // Theoretically the other one does not show up or fails in weigh in, so don't remove the option:
                  // boutResultValues.remove(BoutResult.bothVfo);
                }
                boutResultOptions.addAll(boutResultValues.map(
                  (BoutResult boutResult) {
                    final resultRule = BoutConfig.resultRule(
                      result: boutResult,
                      style: widget.boutState.weightClass?.style ?? WrestlingStyle.free,
                      technicalPointsWinner: AthleteBoutState.getTechnicalPoints(actions, role),
                      technicalPointsLoser: AthleteBoutState.getTechnicalPoints(
                          actions, role == BoutRole.red ? BoutRole.blue : BoutRole.red),
                      rules: widget.boutState.boutRules,
                    );
                    final isEnabled = resultRule != null;
                    return DropdownMenuItem(
                      // Only allow to select option, if current state and resultRules allow it.
                      enabled: isEnabled,
                      value: boutResult,
                      child: Tooltip(
                        message: boutResult.description(context),
                        child: Text(boutResult.abbreviation(context),
                            style: isEnabled ? null : TextStyle(color: Theme.of(context).disabledColor)),
                      ),
                    );
                  },
                ));
              }

              return CustomDropdown<BoutResult>(
                isNullable: true,
                selected:
                    role == widget.boutState.bout.winnerRole || (widget.boutState.bout.result?.affectsBoth() ?? false)
                        ? widget.boutState.bout.result
                        : null,
                options: boutResultOptions,
                onChange: (BoutResult? val) async {
                  final dataManager = await ref.read(dataManagerNotifierProvider);
                  var bout = widget.boutState.bout.copyWith(
                    winnerRole: val != null && !val.affectsBoth() ? role : null,
                    result: val,
                  );
                  bout = bout.updateClassificationPoints(actions,
                      rules: widget.boutState.boutRules,
                      style: widget.boutState.weightClass?.style ?? WrestlingStyle.free);
                  dataManager.createOrUpdateSingle(bout);
                  if (bout.r != null) dataManager.createOrUpdateSingle(bout.r!);
                  if (bout.b != null) dataManager.createOrUpdateSingle(bout.b!);

                  setState(() {
                    widget.boutState.bout = bout;
                  });
                },
              );
            },
          )),
    );
  }
}
