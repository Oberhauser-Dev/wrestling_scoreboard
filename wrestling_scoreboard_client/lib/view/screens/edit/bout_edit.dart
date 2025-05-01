import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/duration.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/components/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/duration_picker.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class BoutEdit extends ConsumerStatefulWidget {
  final Bout? bout;
  final BoutConfig boutConfig;

  const BoutEdit({
    super.key,
    this.bout,
    required this.boutConfig,
  });
}

abstract class BoutEditState<T extends BoutEdit> extends ConsumerState<T> implements AbstractEditState<Bout> {
  final _formKey = GlobalKey<FormState>();

  BoutRole? _winnerRole;
  BoutResult? _boutResult;
  Membership? _redMembership;
  Membership? _blueMembership;
  Duration? _boutDuration;

  @override
  void initState() {
    super.initState();
    _boutDuration = widget.bout?.duration;
    _winnerRole = widget.bout?.winnerRole;
    _boutResult = widget.bout?.result;
    _redMembership = widget.bout?.r?.membership;
    _blueMembership = widget.bout?.b?.membership;
  }

  @override
  Widget buildEdit(
    BuildContext context, {
    required String classLocale,
    required int? id,
    required List<Widget> fields,
    Future<Iterable<Membership>> Function()? getRedMemberships,
    Future<Iterable<Membership>> Function()? getBlueMemberships,
  }) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      ...fields,
      MembershipSelectTile(
        label: localizations.red,
        getMemberships: getRedMemberships!,
        membership: widget.bout?.r?.membership,
        createOrUpdateAtheleteBoutState: (membership) => _redMembership = membership,
        deleteAtheleteBoutState: (membership) => _redMembership = null,
        organization: widget.bout?.organization,
      ),
      MembershipSelectTile(
        label: localizations.blue,
        getMemberships: getBlueMemberships!,
        membership: widget.bout?.b?.membership,
        createOrUpdateAtheleteBoutState: (membership) => _blueMembership = membership,
        deleteAtheleteBoutState: (membership) => _blueMembership = null,
        organization: widget.bout?.organization,
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

      Future<AthleteBoutState?> updateAthleteBoutState(
        Membership? newMembership,
        AthleteBoutState? oldAthleteBoutState,
      ) async {
        if (newMembership != oldAthleteBoutState?.membership) {
          if (oldAthleteBoutState != null) {
            await (await ref.read(dataManagerNotifierProvider)).deleteSingle<AthleteBoutState>(oldAthleteBoutState);
          }
          if (newMembership != null) {
            final newAthleteBoutState = AthleteBoutState(membership: newMembership);
            return newAthleteBoutState.copyWithId(await (await ref.read(dataManagerNotifierProvider))
                .createOrUpdateSingle<AthleteBoutState>(newAthleteBoutState));
          } else {
            return null;
          }
        } else {
          return oldAthleteBoutState;
        }
      }

      var bout = (widget.bout ?? Bout()).copyWith(
        result: _boutResult,
        winnerRole: _winnerRole,
        r: await updateAthleteBoutState(_redMembership, widget.bout?.r),
        b: await updateAthleteBoutState(_blueMembership, widget.bout?.b),
        duration: _boutDuration ?? Duration.zero,
      );

      bout = bout.copyWithId(await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(bout));
      await handleNested(bout);
      navigator.pop();
    }
  }
}

class MembershipSelectTile extends ConsumerWidget {
  final String label;
  final Membership? membership;
  final Organization? organization;
  final void Function(Membership membership) deleteAtheleteBoutState;
  final void Function(Membership membership) createOrUpdateAtheleteBoutState;
  final Future<Iterable<Membership>> Function() getMemberships;

  const MembershipSelectTile({
    super.key,
    required this.label,
    this.membership,
    required this.organization,
    required this.getMemberships,
    required this.deleteAtheleteBoutState,
    required this.createOrUpdateAtheleteBoutState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: MembershipDropdown(
        selectedItem: membership,
        organization: organization,
        label: label,
        getOrSetMemberships: getMemberships,
        onSave: (Membership? newMembership) {
          if (membership == newMembership) return;

          // Delete old membership, if not null
          if (membership?.id != null) {
            deleteAtheleteBoutState(membership!);
          }

          if (newMembership != null) {
            createOrUpdateAtheleteBoutState(newMembership);
          }
        },
      ),
    );
  }
}
