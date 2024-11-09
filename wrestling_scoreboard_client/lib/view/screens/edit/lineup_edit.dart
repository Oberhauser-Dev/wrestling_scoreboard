import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/card.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_common/common.dart';

// TODO: dynamically add or remove participants without weight class
class LineupEdit extends ConsumerStatefulWidget {
  final Lineup lineup;
  final List<WeightClass> weightClasses;
  final List<Participation> participations;
  final Membership? initialLeader;
  final Membership? initialCoach;
  final List<Participation>? initialParticipations;

  final Future<void> Function()? onSubmitGenerate;

  const LineupEdit({
    super.key,
    required this.lineup,
    required this.weightClasses,
    required this.participations,
    this.onSubmitGenerate,
    this.initialLeader,
    this.initialCoach,
    this.initialParticipations,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LineupEditState();
}

class LineupEditState extends ConsumerState<LineupEdit> {
  final _formKey = GlobalKey<FormState>();

  Iterable<Membership>? _memberships;

  Membership? _leader;
  Membership? _coach;
  late Map<WeightClass, Participation?> _participations;
  final HashSet<Participation> _deleteParticipations = HashSet();
  final HashSet<Participation> _createOrUpdateParticipations = HashSet();

  @override
  void initState() {
    super.initState();
    _leader = widget.lineup.leader;
    _coach = widget.lineup.coach;

    if (widget.participations.isNotEmpty) {
      _participations = Map.fromEntries(widget.weightClasses.map((e) {
        final participation =
            widget.participations.singleWhereOrNull((participation) => participation.weightClass == e);
        return MapEntry(e, participation);
      }));
    } else {
      // Copy participations from an old match.
      _participations = Map.fromEntries(widget.weightClasses.map((e) {
        var participation =
            widget.initialParticipations?.singleWhereOrNull((participation) => participation.weightClass == e);
        if (participation != null) {
          participation = participation.copyWith(id: null, lineup: widget.lineup);
        }
        return MapEntry(e, participation);
      }));
    }
  }

  Future<void> handleSubmit(NavigatorState navigator, {Future<void> Function()? onSubmitGenerate}) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(Lineup(
        id: widget.lineup.id,
        team: widget.lineup.team,
        leader: _leader,
        coach: _coach,
      ));
      await Future.forEach(_deleteParticipations, (Participation element) async {
        await (await ref.read(dataManagerNotifierProvider)).deleteSingle<Participation>(element);
      });
      await Future.forEach(_createOrUpdateParticipations, (Participation participation) async {
        // Create missing membership and person, if not present in database yet. This means, that the data was fetched from an API provider.
        if (participation.membership.id == null) {
          if (participation.membership.person.id == null) {
            final personId = await (await ref.read(dataManagerNotifierProvider))
                .createOrUpdateSingle<Person>(participation.membership.person);
            participation = participation.copyWith(
                membership:
                    participation.membership.copyWith(person: participation.membership.person.copyWithId(personId)));
          }
          final membershipId = await (await ref.read(dataManagerNotifierProvider))
              .createOrUpdateSingle<Membership>(participation.membership);
          participation = participation.copyWith(membership: participation.membership.copyWithId(membershipId));
        }
        await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle<Participation>(participation);
      });
      if (onSubmitGenerate != null) await onSubmitGenerate();
      navigator.pop();
    }
  }

  List<Widget> _buildActions(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);
    return [
      EditAction(
        icon: const Icon(Icons.save),
        label: Text(localizations.save),
        onSubmit: () => handleSubmit(navigator),
      ),
      EditAction(
        icon: const Icon(Icons.autorenew),
        label: Text(localizations.saveAndGenerate),
        onSubmit: () async {
          final hasConfirmed = await showOkCancelDialog(
            context: context,
            getResult: () => true,
            child: Text(localizations.warningBoutGenerate),
          );
          if (hasConfirmed == true && context.mounted) {
            await catchAsync(context, () => handleSubmit(navigator, onSubmitGenerate: widget.onSubmitGenerate));
          }
        },
      ),
    ];
  }

  Future<Iterable<Membership>> _getMemberships() async {
    final clubs = await ref.read(manyDataStreamProvider<Club, Team>(
      ManyProviderData<Club, Team>(filterObject: widget.lineup.team),
    ).future);

    final clubMemeberships = await Future.wait(clubs.map((club) async {
      return await ref.read(manyDataStreamProvider<Membership, Club>(
        ManyProviderData<Membership, Club>(filterObject: club),
      ).future);
    }));

    _memberships ??= clubMemeberships.expand((membership) => membership);
    return _memberships!;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: CustomizableEditWidget(
        typeLocalization: localizations.lineup,
        id: widget.lineup.id,
        buildActions: _buildActions,
        items: [
          ListTile(title: HeadingText(widget.lineup.team.name)),
          if (widget.participations.isEmpty && (widget.initialParticipations?.isNotEmpty ?? false))
            IconCard(icon: const Icon(Icons.warning), text: localizations.warningPrefilledLineup),
          ListTile(
            title: _MembershipDropdown(
              label: localizations.leader,
              getOrSetMemberships: _getMemberships,
              organization: widget.lineup.team.organization,
              selectedItem: _leader,
              onSave: (Membership? value) => setState(() {
                _leader = value;
              }),
            ),
          ),
          ListTile(
            title: _MembershipDropdown(
              label: localizations.coach,
              getOrSetMemberships: _getMemberships,
              organization: widget.lineup.team.organization,
              selectedItem: _coach,
              onSave: (Membership? value) => setState(() {
                _coach = value;
              }),
            ),
          ),
          ..._participations.entries.map((mapEntry) {
            return ParticipationEditTile(
              getOrSetMemberships: _getMemberships,
              lineup: widget.lineup,
              participation: mapEntry.value,
              weightClass: mapEntry.key,
              createOrUpdateParticipation: (participation) => _createOrUpdateParticipations.add(participation),
              deleteParticipation: (participation) => _deleteParticipations.add(participation),
            );
          }),
        ],
      ),
    );
  }
}

class ParticipationEditTile extends ConsumerStatefulWidget {
  final Participation? participation;
  final WeightClass weightClass;
  final Lineup lineup;
  final void Function(Participation participation) deleteParticipation;
  final void Function(Participation participation) createOrUpdateParticipation;
  final Future<Iterable<Membership>> Function() getOrSetMemberships;

  const ParticipationEditTile({
    super.key,
    this.participation,
    required this.weightClass,
    required this.lineup,
    required this.deleteParticipation,
    required this.createOrUpdateParticipation,
    required this.getOrSetMemberships,
  });

  @override
  ConsumerState<ParticipationEditTile> createState() => _ParticipationEditTileState();
}

class _ParticipationEditTileState extends ConsumerState<ParticipationEditTile> {
  Membership? _curMembership;
  double? _curWeight;

  @override
  void initState() {
    super.initState();
    _curMembership = widget.participation?.membership;
    _curWeight = widget.participation?.weight;
  }

  void onSave() {
    // Preloaded new participations (without id) should also be saved.
    if (widget.participation?.id != null &&
        widget.participation?.membership == _curMembership &&
        widget.participation?.weight == _curWeight) return;

    // Delete old participation, if membership is null
    if (_curMembership == null) {
      if (widget.participation?.id != null) {
        widget.deleteParticipation(widget.participation!);
      }
    } else {
      Participation curParticipation;
      if (widget.participation?.id != null) {
        // Reuse old participation if present
        curParticipation = widget.participation!.copyWith(
          membership: _curMembership!,
          lineup: widget.lineup,
          weightClass: widget.weightClass,
          weight: _curWeight,
        );
      } else {
        curParticipation = Participation(
          membership: _curMembership!,
          lineup: widget.lineup,
          weightClass: widget.weightClass,
          weight: _curWeight,
        );
      }
      widget.createOrUpdateParticipation(curParticipation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ListTile(
      title: Row(
        children: [
          Expanded(
            flex: 80,
            child: Container(
              padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
              child: _MembershipDropdown(
                label:
                    '${localizations.weightClass} ${widget.weightClass.name} ${widget.weightClass.style.abbreviation(context)}',
                getOrSetMemberships: widget.getOrSetMemberships,
                onChange: (Membership? newMembership) {
                  _curMembership = newMembership;
                },
                organization: widget.lineup.team.organization,
                selectedItem: widget.participation?.membership,
                onSave: (_) => onSave(),
              ),
            ),
          ),
          Expanded(
            flex: 20,
            child: Container(
              padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
              child: TextFormField(
                initialValue: widget.participation?.weight?.toString() ?? '',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  labelText: localizations.weight,
                ),
                inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 1, max: 1000)],
                onChanged: (String? value) {
                  final newValue = (value == null || value.isEmpty) ? null : double.parse(value);
                  _curWeight = newValue;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MembershipDropdown extends ConsumerWidget {
  final Future<Iterable<Membership>> Function() getOrSetMemberships;
  final void Function(Membership? membership)? onChange;
  final void Function(Membership? membership)? onSave;
  final Membership? selectedItem;
  final String label;
  final Organization? organization;

  const _MembershipDropdown({
    required this.getOrSetMemberships,
    this.selectedItem,
    required this.label,
    this.organization,
    this.onChange,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoadingBuilder<Map<int, AuthService>>(
      future: ref.watch(orgAuthNotifierProvider),
      builder: (context, authServiceMap) {
        return SearchableDropdown<Membership>(
          selectedItem: selectedItem,
          label: label,
          context: context,
          onChanged: onChange,
          onSaved: onSave,
          itemAsString: (u) => u.info + (u.id == null ? ' (API)' : ''),
          asyncItems: (String filter) async {
            return _filterMemberships(ref, filter, organization, await getOrSetMemberships());
          },
          isFilterOnline: true,
          containerBuilder: (context, popupWidget) {
            return Column(
              children: [
                if (authServiceMap[organization?.id] == null)
                  const PaddedCard(
                    child: Text(
                        "⚠ You have not specified any credentials for this organization, therefore you can't search for sensitive data."),
                  ),
                Expanded(child: popupWidget),
              ],
            );
          },
        );
      },
    );
  }

  Future<List<Membership>> _filterMemberships(
    WidgetRef ref,
    String filter,
    Organization? organization,
    Iterable<Membership> memberships,
  ) async {
    filter = filter.trim().toLowerCase();
    if (filter.isEmpty) {
      return memberships.toList();
    }
    final number = int.tryParse(filter);
    if (number == null) {
      return memberships.where((item) => item.person.fullName.toLowerCase().contains(filter)).toList();
    }

    // If filter string is a number, search for membership no or at API provider, if present.
    filter = number.toString();
    final filteredMemberships = memberships
        .where((item) => (item.orgSyncId?.contains(filter) ?? false) || (item.no?.contains(filter) ?? false))
        .toList();

    const enableApiProviderSearch = true;
    if (enableApiProviderSearch) {
      final authService = (await ref.read(orgAuthNotifierProvider))[organization?.id];
      if (authService != null) {
        final providerResults = await (await ref.read(dataManagerNotifierProvider)).search(
          searchTerm: filter,
          type: Membership,
          organizationId: organization?.id,
          authService: authService,
          includeApiProviderResults: true,
        );
        final providerMemberships =
            providerResults[getTableNameFromType(Membership)]?.map((membership) => membership as Membership) ?? [];
        filteredMemberships.addAll(providerMemberships);
      }
    }

    return filteredMemberships;
  }
}
