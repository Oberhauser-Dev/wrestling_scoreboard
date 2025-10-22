import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_shortcuts.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
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
    widget.boutState.mainStopwatch.stopwatch.onStartStop.stream.listen((isRunning) {
      if (mounted) {
        setState(() {
          _isRunning = isRunning;
        });
      }
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 35,
          child: _MainControlDropDown(
            role: BoutRole.red,
            bout: widget.boutState.bout,
            wrestlingStyle: widget.boutState.weightClass?.style,
            boutRules: widget.boutState.boutRules,
          ),
        ),
        Expanded(
          flex: 50,
          child: Row(
            children: [
              Expanded(
                child:
                    widget.boutState.widget.bouts.first.id == widget.boutState.bout.id
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
                        ),
              ),
              Expanded(
                child: DelayedTooltip(
                  message: localizations.comment,
                  child: IconButton(
                    onPressed: () async {
                      String text = '';
                      final result = await showOkCancelDialog(
                        context: context,
                        child: CustomTextInput(
                          iconData: Icons.comment,
                          isMultiline: true,
                          label: localizations.comment,
                          initialValue: widget.boutState.bout.comment,
                          isMandatory: false,
                          onChanged: (value) => text = value,
                        ),
                      );
                      if (result) {
                        widget.boutState.bout = widget.boutState.bout.copyWith(comment: text);
                        await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(widget.boutState.bout);
                      }
                    },
                    icon: const Icon(Icons.comment),
                  ),
                ),
              ),
              Expanded(
                child: DelayedTooltip(
                  message: '${_isRunning ? localizations.pause : localizations.start} (Space)',
                  child: IconButton(
                    onPressed: () => widget.callback(const BoutScreenActionIntent.startStop()),
                    icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () => widget.callback(const BoutScreenActionIntent.horn()),
                  icon: const Icon(Icons.campaign),
                ),
              ),
              Expanded(
                child:
                    widget.boutState.widget.bouts.last.id == widget.boutState.bout.id
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
                        ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 35,
          child: _MainControlDropDown(
            role: BoutRole.blue,
            bout: widget.boutState.bout,
            wrestlingStyle: widget.boutState.weightClass?.style,
            boutRules: widget.boutState.boutRules,
          ),
        ),
      ],
    );
  }
}

class _MainControlDropDown extends ConsumerWidget {
  final BoutRole role;
  final Bout bout;
  final WrestlingStyle? wrestlingStyle;
  final List<BoutResultRule> boutRules;

  const _MainControlDropDown({
    required this.role,
    required this.bout,
    required this.wrestlingStyle,
    required this.boutRules,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleConsumer<Bout>(
      id: bout.id,
      initialData: bout,
      builder: (context, bout) {
        final AthleteBoutState? pStatus = role == BoutRole.red ? bout.r : bout.b;
        final AthleteBoutState? pStatusOpponent = role == BoutRole.blue ? bout.r : bout.b;
        return ThemedContainer(
          color: role == bout.winnerRole ? role.color() : null,
          child: ButtonTheme(
            alignedDropdown: true,
            child: ManyConsumer<BoutAction, Bout>(
              filterObject: bout,
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
                  boutResultOptions.addAll(
                    boutResultValues.map((BoutResult boutResult) {
                      final resultRule = BoutConfig.resultRule(
                        result: boutResult,
                        style: wrestlingStyle ?? WrestlingStyle.free,
                        technicalPointsWinner: AthleteBoutState.getTechnicalPoints(actions, role),
                        technicalPointsLoser: AthleteBoutState.getTechnicalPoints(
                          actions,
                          role == BoutRole.red ? BoutRole.blue : BoutRole.red,
                        ),
                        rules: boutRules,
                      );
                      final isEnabled = resultRule != null;
                      return DropdownMenuItem(
                        // Only allow to select option, if current state and resultRules allow it.
                        enabled: isEnabled,
                        value: boutResult,
                        child: Tooltip(
                          message: boutResult.description(context),
                          child: Text(
                            boutResult.abbreviation(context),
                            style: isEnabled ? null : TextStyle(color: Theme.of(context).disabledColor),
                          ),
                        ),
                      );
                    }),
                  );
                }

                return CustomDropdown<BoutResult>(
                  isNullable: true,
                  selected: role == bout.winnerRole || (bout.result?.affectsBoth() ?? false) ? bout.result : null,
                  options: boutResultOptions,
                  onChange: (BoutResult? val) async {
                    final dataManager = await ref.read(dataManagerNotifierProvider);
                    var updatedBout = bout.copyWith(
                      winnerRole: val != null && !val.affectsBoth() ? role : null,
                      result: val,
                    );
                    updatedBout = updatedBout.updateClassificationPoints(
                      actions,
                      rules: boutRules,
                      style: wrestlingStyle ?? WrestlingStyle.free,
                    );
                    await dataManager.createOrUpdateSingle(updatedBout);
                    // Need to await saving, otherwise a read of the AthleteBoutState list happens on old values within createOrUpdateSingle (e.g. for local running local bouts).
                    if (updatedBout.r != null) await dataManager.createOrUpdateSingle(updatedBout.r!);
                    if (updatedBout.b != null) await dataManager.createOrUpdateSingle(updatedBout.b!);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
