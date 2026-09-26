import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/components/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionLineupEdit extends ConsumerStatefulWidget {
  final CompetitionLineup? competitionLineup;
  final Competition initialCompetition;

  const CompetitionLineupEdit({this.competitionLineup, required this.initialCompetition, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CompetitionLineupEditState();
}

class CompetitionLineupEditState extends ConsumerState<CompetitionLineupEdit> {
  final _formKey = GlobalKey<FormState>();

  Iterable<Club>? _availableClubs;
  Iterable<Membership>? _availableMemberships;

  late final Future<List<CompetitionLineupMembership>> _lineupMembershipsFuture;
  List<CompetitionLineupMembership> _lineupMemberships = [];

  Membership? _leader;
  Membership? _coach;
  Club? _club;

  @override
  void initState() {
    super.initState();
    _club = widget.competitionLineup?.club;
    _lineupMembershipsFuture = _loadLineupMemberships();
  }

  Future<List<CompetitionLineupMembership>> _loadLineupMemberships() async {
    final competitionLineup = widget.competitionLineup;
    if (competitionLineup?.id != null) {
      _lineupMemberships = await ref.readAsync(
        manyDataStreamProvider<CompetitionLineupMembership, CompetitionLineup>(
          ManyProviderData<CompetitionLineupMembership, CompetitionLineup>(filterObject: competitionLineup),
        ).future,
      );
    }
    // Only one leader and coach can be edited, even if there are multiple in the background.
    _leader = _lineupMemberships.firstOfRole(LineupRole.leader)?.membership;
    _coach = _lineupMemberships.firstOfRole(LineupRole.coach)?.membership;
    return _lineupMemberships;
  }

  Future<Iterable<Membership>> _getMemberships() async {
    if (_availableMemberships == null && _club != null) {
      _availableMemberships = await ref.readAsync(
        manyDataStreamProvider<Membership, Club>(ManyProviderData<Membership, Club>(filterObject: _club)).future,
      );
    }
    return _availableMemberships ?? [];
  }

  Widget _buildForm(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      ListTile(
        title: SearchableDropdown<Club>.stringItems(
          allowEmpty: false,
          icon: const Icon(Icons.foundation),
          selectedItem: _club,
          label: localizations.club,
          context: context,
          onSaved: (Club? value) => setState(() {
            _club = value;
          }),
          onChanged: (club) async {
            _club = club;
            setState(() {
              // Reset memberships, if changing the club.
              _leader = null;
              _coach = null;
              _availableMemberships = null;
            });
          },
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async {
            _availableClubs ??= await (await ref.read(dataManagerProvider)).readMany<Club, Null>();
            return _availableClubs!.toList();
          },
        ),
      ),
      ListTile(
        title: MembershipDropdown(
          label: localizations.leader,
          getOrSetMemberships: () async => _getMemberships(),
          organization: widget.initialCompetition.organization,
          selectedItem: _leader,
          onSave: (value) => setState(() {
            _leader = value;
          }),
          clubFilter: [?_club],
        ),
      ),
      ListTile(
        title: MembershipDropdown(
          label: localizations.coach,
          getOrSetMemberships: () async => _getMemberships(),
          organization: widget.initialCompetition.organization,
          selectedItem: _coach,
          onSave: (value) => setState(() {
            _coach = value;
          }),
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.lineup,
        id: widget.competitionLineup?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(future: _lineupMembershipsFuture, builder: (context, _) => _buildForm(context));
  }

  /// Creates, updates or deletes the (first) lineup membership of the given [role].
  Future<void> _saveLineupMembership(
    DataManager dataManager,
    CompetitionLineup lineup,
    LineupRole role,
    Membership? membership,
  ) async {
    final lineupMembership = _lineupMemberships.firstOfRole(role);
    if (lineupMembership?.membership == membership) return;
    if (membership == null) {
      await dataManager.deleteSingle<CompetitionLineupMembership>(lineupMembership!);
    } else if (lineupMembership != null) {
      await dataManager.createOrUpdateSingle<CompetitionLineupMembership>(
        lineupMembership.copyWith(membership: membership),
      );
    } else {
      await dataManager.createOrUpdateSingle<CompetitionLineupMembership>(
        CompetitionLineupMembership(lineup: lineup, membership: membership, role: role),
      );
    }
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      CompetitionLineup cLineup = CompetitionLineup(
        id: widget.competitionLineup?.id,
        competition: widget.competitionLineup?.competition ?? widget.initialCompetition,
        club: _club!,
      );
      final dataManager = await ref.read(dataManagerProvider);
      cLineup = cLineup.copyWithId(await dataManager.createOrUpdateSingle(cLineup));
      await _saveLineupMembership(dataManager, cLineup, LineupRole.leader, _leader);
      await _saveLineupMembership(dataManager, cLineup, LineupRole.coach, _coach);
      navigator.pop();
    }
  }
}
