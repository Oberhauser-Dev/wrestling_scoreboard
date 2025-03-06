import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamEdit extends ConsumerStatefulWidget {
  final Team? team;
  final Organization? initialOrganization;
  final Future<void> Function(Team team)? onCreated;

  const TeamEdit({this.team, this.initialOrganization, this.onCreated, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TeamEditState();
}

class TeamEditState extends ConsumerState<TeamEdit> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _description;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      ListTile(
        leading: const Icon(Icons.short_text),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.name,
          ),
          initialValue: widget.team?.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.mandatoryField;
            }
            return null;
          },
          onSaved: (newValue) => _name = newValue,
        ),
      ),
      ListTile(
        leading: const Icon(Icons.subject),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.description,
          ),
          initialValue: widget.team?.description,
          onSaved: (newValue) => _description = newValue,
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.team,
        id: widget.team?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Team team = Team(
        id: widget.team?.id,
        orgSyncId: widget.team?.orgSyncId,
        organization: widget.team?.organization ?? widget.initialOrganization,
        name: _name!,
        description: _description,
      );
      team = team.copyWithId(await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(team));
      if (widget.onCreated != null) {
        await widget.onCreated!(team);
      }
      navigator.pop();
    }
  }
}
