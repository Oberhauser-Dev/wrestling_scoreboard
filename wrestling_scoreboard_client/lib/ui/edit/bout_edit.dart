import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/ui/components/dropdown.dart';
import 'package:wrestling_scoreboard_client/ui/components/edit.dart';
import 'package:wrestling_scoreboard_client/ui/edit/common.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class BoutEdit extends StatefulWidget {
  final Bout? bout;
  final Lineup lineupRed;
  final Lineup lineupBlue;

  const BoutEdit({
    super.key,
    this.bout,
    required this.lineupRed,
    required this.lineupBlue,
  });
}

abstract class BoutEditState<T extends BoutEdit> extends State<T> implements AbstractEditState<Bout> {
  final _formKey = GlobalKey<FormState>();

  late WeightClass _weightClass;
  Participation? _redParticipation;
  Participation? _blueParticipation;

  @override
  void initState() {
    super.initState();
    _weightClass = widget.bout!.weightClass;
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
    final localizations = AppLocalizations.of(context)!;
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
      // TODO: remove the need for a weight class.
      // TODO: select from existing weight classes.
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
            await dataProvider.deleteSingle<ParticipantState>(oldParticipantState);
          }
          if (newParticipation != null) {
            final newParticipantState = ParticipantState(participation: newParticipation);
            return newParticipantState
                .copyWithId(await dataProvider.createOrUpdateSingle<ParticipantState>(newParticipantState));
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
        result: widget.bout?.result,
        winnerRole: widget.bout?.winnerRole,
        r: await updateParticipantState(_redParticipation, widget.bout?.r),
        b: await updateParticipantState(_blueParticipation, widget.bout?.b),
        duration: widget.bout?.duration ?? Duration.zero,
        pool: widget.bout?.pool,
      );

      bout = bout.copyWithId(await dataProvider.createOrUpdateSingle(bout));
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
    final localizations = AppLocalizations.of(context)!;
    return ListTile(
      title: Row(
        children: [
          Expanded(
            flex: 80,
            child: Container(
              padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
              child: getDropdown<Participation>(
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
                onFind: (String? filter) => _filterParticipants(ref, filter, lineup),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
