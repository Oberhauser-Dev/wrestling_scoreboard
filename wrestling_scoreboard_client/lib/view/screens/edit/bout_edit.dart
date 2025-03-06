import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/duration.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/common.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/duration_picker.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class BoutEdit extends ConsumerStatefulWidget {
  final Bout? bout;
  final BoutConfig boutConfig;
  final Lineup lineupRed;
  final Lineup lineupBlue;

  const BoutEdit({
    super.key,
    this.bout,
    required this.boutConfig,
    required this.lineupRed,
    required this.lineupBlue,
  });
}

abstract class BoutEditState<T extends BoutEdit> extends ConsumerState<T> implements AbstractEditState<Bout> {
  final _formKey = GlobalKey<FormState>();

  BoutRole? _winnerRole;
  BoutResult? _boutResult;
  WeightClass? _weightClass;
  Participation? _redParticipation;
  Participation? _blueParticipation;
  Duration? _boutDuration;

  Future<List<WeightClass>> get availableWeightClasses;

  @override
  void initState() {
    super.initState();
    _boutDuration = widget.bout?.duration;
    _winnerRole = widget.bout?.winnerRole;
    _boutResult = widget.bout?.result;
    _weightClass = widget.bout?.weightClass;
    _redParticipation = widget.bout?.r?.participation;
    _blueParticipation = widget.bout?.b?.participation;
  }

  @override
  Widget buildEdit(
    BuildContext context, {
    required String classLocale,
    required int? id,
    required List<Widget> fields,
  }) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      ...fields,
      ParticipantSelectTile(
        label: localizations.red,
        lineup: widget.lineupRed,
        participation: widget.bout?.r?.participation,
        createOrUpdateParticipantState: (participation) => _redParticipation = participation,
        deleteParticipantState: (participation) => _redParticipation = null,
      ),
      ParticipantSelectTile(
        label: localizations.blue,
        lineup: widget.lineupBlue,
        participation: widget.bout?.b?.participation,
        createOrUpdateParticipantState: (participation) => _blueParticipation = participation,
        deleteParticipantState: (participation) => _blueParticipation = null,
      ),
      ListTile(
        title: SearchableDropdown<WeightClass>(
          icon: const Icon(Icons.fitness_center),
          selectedItem: _weightClass,
          label: context.l10n.weightClass,
          context: context,
          onSaved: (WeightClass? value) => setState(() {
            _weightClass = value;
          }),
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async {
            final boutWeightClasses = await availableWeightClasses;
            return boutWeightClasses.toList();
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.emoji_events),
        title: ButtonTheme(
          alignedDropdown: true,
          child: SimpleDropdown<BoutRole>(
            hint: localizations.winner,
            isNullable: true,
            selected: _winnerRole,
            options: BoutRole.values.map(
              (BoutRole value) => MapEntry(
                value,
                Text(
                  value.name,
                ),
              ),
            ),
            onChange: (BoutRole? newValue) => setState(() {
              _winnerRole = newValue;
            }),
          ),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.label),
        title: ButtonTheme(
          alignedDropdown: true,
          child: SimpleDropdown<BoutResult>(
            hint: localizations.result,
            isNullable: true,
            selected: _boutResult,
            options: BoutResult.values.map(
              (BoutResult boutResult) => MapEntry(boutResult,
                  Tooltip(message: boutResult.description(context), child: Text(boutResult.abbreviation(context)))),
            ),
            onChange: (BoutResult? newValue) => setState(() {
              _boutResult = newValue;
            }),
          ),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.timer),
        subtitle: Text(localizations.duration),
        title: LoadingBuilder<bool>(
            future: ref.watch(timeCountDownNotifierProvider),
            builder: (context, isTimeCountDown) {
              return DurationFormField(
                initialValue: _boutDuration?.invertIf(isTimeCountDown, max: widget.boutConfig.totalPeriodDuration),
                maxValue: widget.boutConfig.totalPeriodDuration,
                onSaved: (Duration? value) {
                  _boutDuration = value?.invertIf(isTimeCountDown, max: widget.boutConfig.totalPeriodDuration);
                },
              );
            }),
      ),
    ];

    return Form(
        key: _formKey,
        child: EditWidget(
            typeLocalization: classLocale, id: widget.bout?.id, onSubmit: () => handleSubmit(navigator), items: items));
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Future<ParticipantState?> updateParticipantState(
          Participation? newParticipation, ParticipantState? oldParticipantState) async {
        if (newParticipation != oldParticipantState?.participation) {
          if (oldParticipantState != null) {
            await (await ref.read(dataManagerNotifierProvider)).deleteSingle<ParticipantState>(oldParticipantState);
          }
          if (newParticipation != null) {
            final newParticipantState = ParticipantState(participation: newParticipation);
            return newParticipantState.copyWithId(await (await ref.read(dataManagerNotifierProvider))
                .createOrUpdateSingle<ParticipantState>(newParticipantState));
          } else {
            return null;
          }
        } else {
          return oldParticipantState;
        }
      }

      var bout = Bout(
        id: widget.bout?.id,
        weightClass: _weightClass,
        result: _boutResult,
        winnerRole: _winnerRole,
        r: await updateParticipantState(_redParticipation, widget.bout?.r),
        b: await updateParticipantState(_blueParticipation, widget.bout?.b),
        duration: _boutDuration ?? Duration.zero,
        pool: widget.bout?.pool,
      );

      bout = bout.copyWithId(await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(bout));
      await handleNested(bout);
      navigator.pop();
    }
  }
}

class ParticipantSelectTile extends ConsumerWidget {
  final String label;
  final Participation? participation;
  final Lineup lineup;
  final void Function(Participation participation) deleteParticipantState;
  final void Function(Participation participation) createOrUpdateParticipantState;

  const ParticipantSelectTile({
    super.key,
    required this.label,
    this.participation,
    required this.lineup,
    required this.deleteParticipantState,
    required this.createOrUpdateParticipantState,
  });

  Future<List<Participation>> _filterParticipants(
    WidgetRef ref,
    String? filter,
    Lineup lineup,
  ) async {
    final participations = await _getParticipations(ref, lineup: lineup);
    return (filter == null
            ? participations
            : participations.where((element) => element.membership.person.fullName.contains(filter)))
        .toList();
  }

  Future<List<Participation>> _getParticipations(WidgetRef ref, {required Lineup lineup}) async {
    return ref.watch(manyDataStreamProvider<Participation, Lineup>(ManyProviderData(filterObject: lineup)).future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Row(
        children: [
          Expanded(
            flex: 80,
            child: Container(
              padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
              child: SearchableDropdown<Participation>(
                selectedItem: participation,
                label: label,
                context: context,
                onSaved: (Participation? newParticipation) {
                  if (participation == newParticipation) return;

                  // Delete old participation, if not null
                  if (participation?.id != null) {
                    deleteParticipantState(participation!);
                  }

                  if (newParticipation != null) {
                    createOrUpdateParticipantState(newParticipation);
                  }
                },
                itemAsString: (u) => u.membership.person.fullName,
                asyncItems: (String filter) => _filterParticipants(ref, filter, lineup),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
