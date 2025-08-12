import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/weight_class.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/components/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/card.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamLineupEdit extends ConsumerStatefulWidget {
  final TeamLineup lineup;
  final List<WeightClass> weightClasses;
  final List<TeamLineupParticipation> participations;
  final Membership? initialLeader;
  final Membership? initialCoach;
  final List<TeamLineupParticipation>? initialParticipations;

  final Future<void> Function()? onSubmitGenerate;

  const TeamLineupEdit({
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

class LineupEditState extends ConsumerState<TeamLineupEdit> {
  final _formKey = GlobalKey<FormState>();

  Iterable<Membership>? _memberships;

  Membership? _leader;
  Membership? _coach;
  late Map<WeightClass, TeamLineupParticipation?> _participations;
  final HashSet<TeamLineupParticipation> _deleteParticipations = HashSet();
  final HashSet<TeamLineupParticipation> _createOrUpdateParticipations = HashSet();

  @override
  void initState() {
    super.initState();
    _leader = widget.lineup.leader;
    _coach = widget.lineup.coach;

    if (widget.participations.isNotEmpty) {
      _participations = Map.fromEntries(
        widget.weightClasses.map((e) {
          final participation =
              widget.participations.where((participation) => participation.weightClass == e).zeroOrOne;
          return MapEntry(e, participation);
        }),
      );
    } else {
      // Copy participations from an old match.
      _participations = Map.fromEntries(
        widget.weightClasses.map((e) {
          var participation =
              widget.initialParticipations?.where((participation) => participation.weightClass == e).zeroOrOne;
          if (participation != null) {
            participation = participation.copyWith(id: null, lineup: widget.lineup);
          }
          return MapEntry(e, participation);
        }),
      );
    }
  }

  Future<void> handleSubmit(NavigatorState navigator, {Future<void> Function()? onSubmitGenerate}) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(
        TeamLineup(id: widget.lineup.id, team: widget.lineup.team, leader: _leader, coach: _coach),
      );
      await Future.forEach(_deleteParticipations, (TeamLineupParticipation element) async {
        await (await ref.read(dataManagerNotifierProvider)).deleteSingle<TeamLineupParticipation>(element);
      });
      await Future.forEach(_createOrUpdateParticipations, (TeamLineupParticipation participation) async {
        // Create missing membership and person, if not present in database yet. This means, that the data was fetched from an API provider.
        if (participation.membership.id == null) {
          if (participation.membership.person.id == null) {
            final personId = await (await ref.read(
              dataManagerNotifierProvider,
            )).createOrUpdateSingle<Person>(participation.membership.person);
            participation = participation.copyWith(
              membership: participation.membership.copyWith(
                person: participation.membership.person.copyWithId(personId),
              ),
            );
          }
          final membershipId = await (await ref.read(
            dataManagerNotifierProvider,
          )).createOrUpdateSingle<Membership>(participation.membership);
          participation = participation.copyWith(membership: participation.membership.copyWithId(membershipId));
        }
        await (await ref.read(
          dataManagerNotifierProvider,
        )).createOrUpdateSingle<TeamLineupParticipation>(participation);
      });
      if (onSubmitGenerate != null) await onSubmitGenerate();
      navigator.pop();
    }
  }

  List<ResponsiveScaffoldActionItem> _buildActions(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);
    return [
      ResponsiveScaffoldActionItem(
        style: ResponsiveScaffoldActionItemStyle.elevatedIconAndText,
        icon: const Icon(Icons.save),
        label: localizations.save,
        onTap: () => handleSubmit(navigator),
      ),
      ResponsiveScaffoldActionItem(
        style: ResponsiveScaffoldActionItemStyle.elevatedIconAndText,
        icon: const Icon(Icons.autorenew),
        label: localizations.saveAndGenerate,
        onTap: () async {
          final hasConfirmed = await showOkCancelDialog(
            context: context,
            child: Text(localizations.warningBoutGenerate),
          );
          if (hasConfirmed && context.mounted) {
            await catchAsync(context, () => handleSubmit(navigator, onSubmitGenerate: widget.onSubmitGenerate));
          }
        },
      ),
    ];
  }

  Future<Iterable<Membership>> _getMemberships() async {
    if (_memberships == null) {
      final clubs = await ref.readAsync(
        manyDataStreamProvider<Club, Team>(ManyProviderData<Club, Team>(filterObject: widget.lineup.team)).future,
      );

      final clubMemberships = await Future.wait(
        clubs.map((club) async {
          return await ref.readAsync(
            manyDataStreamProvider<Membership, Club>(ManyProviderData<Membership, Club>(filterObject: club)).future,
          );
        }),
      );

      _memberships = clubMemberships.expand((membership) => membership);
    }
    return _memberships!;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return Form(
      key: _formKey,
      child: CustomizableEditWidget(
        typeLocalization: localizations.lineup,
        id: widget.lineup.id,
        buildActions: _buildActions,
        items: [
          ListTile(title: HeadingText(widget.lineup.team.name)),
          if (widget.participations.isEmpty && (widget.initialParticipations?.isNotEmpty ?? false))
            IconCard(icon: const Icon(Icons.warning), child: Text(localizations.warningPrefilledLineup)),
          ListTile(
            leading: Icon(Icons.person),
            title: MembershipDropdown(
              label: localizations.leader,
              getOrSetMemberships: _getMemberships,
              organization: widget.lineup.team.organization,
              selectedItem: _leader,
              onSave:
                  (Membership? value) => setState(() {
                    _leader = value;
                  }),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: MembershipDropdown(
              label: localizations.coach,
              getOrSetMemberships: _getMemberships,
              organization: widget.lineup.team.organization,
              selectedItem: _coach,
              onSave:
                  (Membership? value) => setState(() {
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
  final TeamLineupParticipation? participation;
  final WeightClass weightClass;
  final TeamLineup lineup;
  final void Function(TeamLineupParticipation participation) deleteParticipation;
  final void Function(TeamLineupParticipation participation) createOrUpdateParticipation;
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
        widget.participation?.weight == _curWeight) {
      return;
    }

    // Delete old participation, if membership is null
    if (_curMembership == null) {
      if (widget.participation?.id != null) {
        widget.deleteParticipation(widget.participation!);
      }
    } else {
      TeamLineupParticipation curParticipation;
      if (widget.participation?.id != null) {
        // Reuse old participation if present
        curParticipation = widget.participation!.copyWith(
          membership: _curMembership!,
          lineup: widget.lineup,
          weightClass: widget.weightClass,
          weight: _curWeight,
        );
      } else {
        curParticipation = TeamLineupParticipation(
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
    final localizations = context.l10n;
    return ListTile(
      // TODO replace with image of person
      leading: Icon(Icons.person_2),
      title: Row(
        children: [
          Expanded(
            flex: 80,
            child: Container(
              padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
              child: MembershipDropdown(
                label: '${localizations.weightClass} ${widget.weightClass.abbreviation(context)}',
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
                decoration: CustomInputDecoration(
                  isMandatory: false,
                  label: localizations.weight,
                  localizations: localizations,
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
