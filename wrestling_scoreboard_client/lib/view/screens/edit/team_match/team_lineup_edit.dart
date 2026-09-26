import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/components/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/membership_edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/card.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamLineupEdit extends ConsumerStatefulWidget {
  final TeamMatch teamMatch;
  final TeamLineup lineup;
  final List<WeightClass> weightClasses;
  final List<TeamLineupParticipation> participations;
  final List<TeamLineupMembership> lineupMemberships;
  final Membership? initialLeader;
  final Membership? initialCoach;
  final List<TeamLineupParticipation>? initialParticipations;

  const TeamLineupEdit({
    super.key,
    required this.teamMatch,
    required this.lineup,
    required this.weightClasses,
    required this.participations,
    required this.lineupMemberships,
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
  Iterable<Club>? _clubs;

  Membership? _leader;
  Membership? _coach;
  late Map<WeightClass, TeamLineupParticipation?> _participations;
  late Map<WeightClass, TeamLineupParticipation?> _substitutes;

  /// The weight classes, for which a substitute can be edited.
  late final Set<WeightClass> _substituteWeightClasses;
  final HashSet<TeamLineupParticipation> _deleteParticipations = HashSet();
  final HashSet<TeamLineupParticipation> _createOrUpdateParticipations = HashSet();

  @override
  void initState() {
    super.initState();
    // Only one leader and coach can be edited, even if there are multiple in the background.
    _leader = widget.lineupMemberships.firstOfRole(LineupRole.leader)?.membership ?? widget.initialLeader;
    _coach = widget.lineupMemberships.firstOfRole(LineupRole.coach)?.membership ?? widget.initialCoach;

    _participations = _getInitialParticipations(isSubstitute: false);
    _substitutes = _getInitialParticipations(isSubstitute: true);
    _substituteWeightClasses = _substitutes.entries.where((e) => e.value != null).map((e) => e.key).toSet();
  }

  Map<WeightClass, TeamLineupParticipation?> _getInitialParticipations({required bool isSubstitute}) {
    if (widget.participations.isNotEmpty) {
      return Map.fromEntries(
        widget.weightClasses.map((e) {
          final participation = TeamLineupParticipation.fromParticipationsAndWeightClass(
            participations: widget.participations,
            weightClass: e,
            isSubstitute: isSubstitute,
          );
          return MapEntry(e, participation);
        }),
      );
    } else {
      // Copy participations from an old match.
      return Map.fromEntries(
        widget.weightClasses.map((e) {
          var participation = TeamLineupParticipation.fromParticipationsAndWeightClass(
            participations: widget.initialParticipations ?? const [],
            weightClass: e,
            isSubstitute: isSubstitute,
          );
          if (participation != null) {
            participation = participation.copyWith(id: null, lineup: widget.lineup);
          }
          return MapEntry(e, participation);
        }),
      );
    }
  }

  void _addSubstitute(WeightClass weightClass) {
    setState(() {
      _substituteWeightClasses.add(weightClass);
      final substitute = _substitutes[weightClass];
      if (substitute != null) _deleteParticipations.remove(substitute);
    });
  }

  void _removeSubstitute(WeightClass weightClass) {
    setState(() {
      _substituteWeightClasses.remove(weightClass);
      // The tile is not part of the form anymore, so an existing substitute needs to be deleted here.
      final substitute = _substitutes[weightClass];
      if (substitute?.id != null) _deleteParticipations.add(substitute!);
    });
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Ask to generate bouts, if opponent also has saved their participants
      final opponentLineup = widget.teamMatch.home == widget.lineup ? widget.teamMatch.guest : widget.teamMatch.home;
      final opponentParticipations = await ref.readAsync(
        manyDataStreamProvider<TeamLineupParticipation, TeamLineup>(
          ManyProviderData<TeamLineupParticipation, TeamLineup>(filterObject: opponentLineup),
        ).future,
      );
      final bool isPairBouts;
      if (opponentParticipations.isNotEmpty && mounted) {
        final localizations = context.l10n;
        isPairBouts = await showOkCancelDialog(
          context: context,
          title: Text(localizations.pairBouts),
          child: Text(localizations.warningBoutGenerate),
          okText: localizations.saveAndPairBouts,
          cancelText: localizations.save,
        );
      } else {
        // Do not pair, if opponent is not ready yet.
        isPairBouts = false;
      }

      final dataManager = await ref.read(dataManagerProvider);
      await _saveLineupMembership(dataManager, LineupRole.leader, _leader);
      await _saveLineupMembership(dataManager, LineupRole.coach, _coach);
      await Future.forEach(_deleteParticipations, (TeamLineupParticipation element) async {
        await dataManager.deleteSingle<TeamLineupParticipation>(element);
      });
      // Save created memberships and persons (from API), so the don't get created twice / run in an error.
      final Set<Membership> createdApiMemberships = {};
      final Set<Person> createdApiPersons = {};
      // Need to be called sequentially, so duplicate API memberships can be recognized.
      for (TeamLineupParticipation participation in _createOrUpdateParticipations) {
        // Create missing membership and person, if not present in database yet.
        // This means, that the data was fetched from an API provider.
        if (participation.membership.id == null) {
          if (participation.membership.person.id == null) {
            Person? apiPerson = createdApiPersons.singleWhereOrNull(
              (person) => person.orgSyncId == participation.membership.person.orgSyncId,
            );
            if (apiPerson == null) {
              final personId = await dataManager.createOrUpdateSingle<Person>(participation.membership.person);
              apiPerson = participation.membership.person.copyWithId(personId);
              createdApiPersons.add(apiPerson);
            }
            participation = participation.copyWith(membership: participation.membership.copyWith(person: apiPerson));
          }
          Membership? apiMembership = createdApiMemberships.singleWhereOrNull(
            (membership) => membership.orgSyncId == participation.membership.orgSyncId,
          );
          if (apiMembership == null) {
            final membershipId = await dataManager.createOrUpdateSingle<Membership>(participation.membership);
            apiMembership = participation.membership.copyWithId(membershipId);
            createdApiMemberships.add(apiMembership);
          }
          participation = participation.copyWith(membership: apiMembership);
        }
        await dataManager.createOrUpdateSingle<TeamLineupParticipation>(participation);
      }

      // Should also pair bouts
      if (isPairBouts) {
        await dataManager.generateBouts<TeamMatch>(widget.teamMatch, false);
      }

      navigator.pop();
    }
  }

  /// Creates, updates or deletes the (first) lineup membership of the given [role].
  Future<void> _saveLineupMembership(DataManager dataManager, LineupRole role, Membership? membership) async {
    final lineupMembership = widget.lineupMemberships.firstOfRole(role);
    if (lineupMembership?.membership == membership) return;
    if (membership == null) {
      await dataManager.deleteSingle<TeamLineupMembership>(lineupMembership!);
    } else if (lineupMembership != null) {
      await dataManager.createOrUpdateSingle<TeamLineupMembership>(lineupMembership.copyWith(membership: membership));
    } else {
      await dataManager.createOrUpdateSingle<TeamLineupMembership>(
        TeamLineupMembership(lineup: widget.lineup, membership: membership, role: role),
      );
    }
  }

  List<ResponsiveScaffoldActionItemBuilder> _buildActions(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);
    return [
      DefaultResponsiveScaffoldActionItem(
        style: ResponsiveScaffoldActionItemStyle.elevatedIconAndText,
        icon: const Icon(Icons.save),
        label: localizations.save,
        onTap: () => catchAsync(context, () => handleSubmit(navigator)),
      ),
    ];
  }

  Future<Iterable<Club>> _getClubs() async {
    _clubs ??= await ref.readAsync(
      manyDataStreamProvider<Club, Team>(ManyProviderData<Club, Team>(filterObject: widget.lineup.team)).future,
    );
    return _clubs!;
  }

  Future<Iterable<Membership>> _getMemberships() async {
    if (_memberships == null) {
      final clubs = await _getClubs();
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
      child: LoadingBuilder(
        future: _getClubs(),
        builder: (context, clubs) {
          if (clubs.isEmpty) return SizedBox.shrink();
          return CustomizableEditWidget(
            typeLocalization: localizations.lineup,
            id: widget.lineup.id,
            buildActions: _buildActions,
            items: [
              ListTile(
                title: HeadingText(widget.lineup.team.name),
                trailing: AddOrCreateButton(
                  addPageBuilder: (context) =>
                      MembershipEdit(initialOrganization: widget.lineup.team.organization!, initialClub: clubs.first),
                  createPageBuilder: (context) => MembershipPersonEdit(initialClub: clubs.first),
                ),
              ),
              if (widget.participations.isEmpty && (widget.initialParticipations?.isNotEmpty ?? false))
                IconCard(icon: const Icon(Icons.warning), child: Text(localizations.warningPrefilledLineup)),
              ListTile(
                leading: Icon(Icons.person),
                title: MembershipDropdown(
                  label: localizations.leader,
                  getOrSetMemberships: _getMemberships,
                  organization: widget.lineup.team.organization,
                  selectedItem: _leader,
                  onSave: (Membership? value) => _leader = value,
                  clubFilter: clubs,
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: MembershipDropdown(
                  label: localizations.coach,
                  getOrSetMemberships: _getMemberships,
                  organization: widget.lineup.team.organization,
                  selectedItem: _coach,
                  onSave: (Membership? value) => _coach = value,
                  clubFilter: clubs,
                ),
              ),
              ListTile(title: HeadingText(localizations.athletes)),
              ..._participations.entries.expand((mapEntry) {
                final weightClass = mapEntry.key;
                final hasSubstitute = _substituteWeightClasses.contains(weightClass);
                return [
                  ParticipationEditTile(
                    key: ValueKey((weightClass, false)),
                    getOrSetMemberships: _getMemberships,
                    lineup: widget.lineup,
                    participation: mapEntry.value,
                    weightClass: weightClass,
                    createOrUpdateParticipation: (participation) => _createOrUpdateParticipations.add(participation),
                    deleteParticipation: (participation) => _deleteParticipations.add(participation),
                    clubFilter: clubs,
                    trailing: hasSubstitute
                        ? null
                        : IconButton(
                            tooltip: localizations.substitute,
                            icon: const Icon(Icons.person_add_alt),
                            onPressed: () => _addSubstitute(weightClass),
                          ),
                  ),
                  if (hasSubstitute)
                    ParticipationEditTile(
                      key: ValueKey((weightClass, true)),
                      getOrSetMemberships: _getMemberships,
                      lineup: widget.lineup,
                      participation: _substitutes[weightClass],
                      weightClass: weightClass,
                      isSubstitute: true,
                      createOrUpdateParticipation: (participation) => _createOrUpdateParticipations.add(participation),
                      deleteParticipation: (participation) => _deleteParticipations.add(participation),
                      clubFilter: clubs,
                      trailing: IconButton(
                        tooltip: localizations.remove,
                        icon: const Icon(Icons.person_remove_alt_1),
                        onPressed: () => _removeSubstitute(weightClass),
                      ),
                    ),
                ];
              }),
            ],
          );
        },
      ),
    );
  }
}

class AddOrCreateButton extends StatelessWidget {
  final Widget Function(BuildContext context) addPageBuilder;
  final Widget Function(BuildContext context) createPageBuilder;

  const AddOrCreateButton({super.key, required this.addPageBuilder, required this.createPageBuilder});

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: addPageBuilder)),
          child: Text(localizations.addExisting),
        ),
        MenuItemButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: createPageBuilder)),
          child: Text(localizations.createAndAdd),
        ),
      ],
      builder: (context, controller, child) => TextButton.icon(
        icon: const Icon(Icons.add),
        label: Text(localizations.membership),
        onPressed: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            controller.open();
          }
        },
      ),
    );
  }
}

class ParticipationEditTile extends ConsumerStatefulWidget {
  final TeamLineupParticipation? participation;
  final WeightClass weightClass;
  final TeamLineup lineup;
  final bool isSubstitute;
  final Widget? trailing;
  final void Function(TeamLineupParticipation participation) deleteParticipation;
  final void Function(TeamLineupParticipation participation) createOrUpdateParticipation;
  final Future<Iterable<Membership>> Function() getOrSetMemberships;
  final Iterable<Club>? clubFilter;

  const ParticipationEditTile({
    super.key,
    this.participation,
    required this.weightClass,
    required this.lineup,
    this.isSubstitute = false,
    this.trailing,
    required this.deleteParticipation,
    required this.createOrUpdateParticipation,
    required this.getOrSetMemberships,
    this.clubFilter,
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
          isSubstitute: widget.isSubstitute,
        );
      } else {
        curParticipation = TeamLineupParticipation(
          membership: _curMembership!,
          lineup: widget.lineup,
          weightClass: widget.weightClass,
          weight: _curWeight,
          isSubstitute: widget.isSubstitute,
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
      leading: Icon(widget.isSubstitute ? Icons.person_outline : Icons.person_2),
      trailing: widget.trailing,
      title: Row(
        spacing: 16,
        children: [
          Text.rich(
            TextSpan(
              text: '${widget.weightClass.weight} ',
              children: [
                TextSpan(
                  text: widget.weightClass.style.abbreviation(context),
                  style: TextStyle(color: widget.weightClass.style.color),
                ),
              ],
            ),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Expanded(
            flex: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: MembershipDropdown(
                label: widget.isSubstitute ? localizations.substitute : null,
                getOrSetMemberships: widget.getOrSetMemberships,
                onChange: (Membership? newMembership) {
                  _curMembership = newMembership;
                },
                organization: widget.lineup.team.organization,
                selectedItem: widget.participation?.membership,
                onSave: (_) => onSave(),
                clubFilter: widget.clubFilter,
              ),
            ),
          ),
          Expanded(
            flex: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                initialValue: widget.participation?.weight?.toString() ?? '',
                keyboardType: TextInputType.number,
                decoration: CustomInputDecoration(
                  isMandatory: false,
                  label: localizations.weight,
                  localizations: localizations,
                  suffixIcon: (_curWeight ?? 0) > widget.weightClass.weight
                      ? Tooltip(
                          message: localizations.warningOverweight,
                          child: Icon(Icons.warning, color: Colors.yellow),
                        )
                      : null,
                ),
                inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 1, max: 1000)],
                onChanged: (String? value) {
                  final newValue = (value == null || value.isEmpty) ? null : double.parse(value);
                  setState(() {
                    _curWeight = newValue;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
