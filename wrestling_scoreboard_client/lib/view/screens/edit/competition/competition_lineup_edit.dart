import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/components/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
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
  Iterable<Membership>? _memberships;

  Membership? _leader;
  Membership? _coach;
  Club? _club;

  @override
  void initState() {
    super.initState();
    _leader = widget.competitionLineup?.leader;
    _coach = widget.competitionLineup?.coach;
    _club = widget.competitionLineup?.club;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      ListTile(
        title: SearchableDropdown<Club>(
          allowEmpty: false,
          icon: const Icon(Icons.foundation),
          selectedItem: _club,
          label: localizations.club,
          context: context,
          onSaved:
              (Club? value) => setState(() {
                _club = value;
              }),
          onChanged: (club) async {
            final memberships = await ref.readAsync(
              manyDataStreamProvider<Membership, Club>(ManyProviderData<Membership, Club>(filterObject: club)).future,
            );
            setState(() {
              // Reset memberships, if changing the club.
              _leader = null;
              _coach = null;
              _memberships = memberships;
            });
          },
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async {
            _availableClubs ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Club, Null>();
            return _availableClubs!.toList();
          },
        ),
      ),
      ListTile(
        title: MembershipDropdown(
          label: localizations.leader,
          getOrSetMemberships: () async => _memberships ?? [],
          organization: widget.initialCompetition.organization,
          selectedItem: _leader,
          onSave:
              (value) => setState(() {
                _leader = value;
              }),
        ),
      ),
      ListTile(
        title: MembershipDropdown(
          label: localizations.coach,
          getOrSetMemberships: () async => _memberships ?? [],
          organization: widget.initialCompetition.organization,
          selectedItem: _coach,
          onSave:
              (value) => setState(() {
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

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      CompetitionLineup cLineup = CompetitionLineup(
        id: widget.competitionLineup?.id,
        competition: widget.competitionLineup?.competition ?? widget.initialCompetition,
        club: _club!,
        leader: _leader,
        coach: _coach,
      );
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(cLineup);
      navigator.pop();
    }
  }
}
