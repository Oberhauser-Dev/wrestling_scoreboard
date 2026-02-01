import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionSystemAffiliationEdit extends ConsumerStatefulWidget {
  final CompetitionSystemAffiliation? competitionSystemAffiliation;
  final Competition initialCompetition;

  const CompetitionSystemAffiliationEdit({
    this.competitionSystemAffiliation,
    required this.initialCompetition,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CompetitionSystemAffiliationEditState();
}

class CompetitionSystemAffiliationEditState extends ConsumerState<CompetitionSystemAffiliationEdit> {
  final _formKey = GlobalKey<FormState>();
  int? _maxContestants;

  @override
  void initState() {
    super.initState();
    _maxContestants = widget.competitionSystemAffiliation?.maxContestants;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      NumericalInput(
        iconData: Icons.vertical_align_top,
        initialValue: _maxContestants,
        label: '${localizations.participations} (${localizations.maximum})',
        inputFormatter: NumericalRangeFormatter(min: 1, max: 1000),
        isMandatory: false,
        onSaved: (int? value) => _maxContestants = value,
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.competitionSystem,
        id: widget.competitionSystemAffiliation?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final CompetitionSystemAffiliation csa = CompetitionSystemAffiliation(
        id: widget.competitionSystemAffiliation?.id,
        competition: widget.competitionSystemAffiliation?.competition ?? widget.initialCompetition,
        maxContestants: _maxContestants,
      );
      await (await ref.read(dataManagerProvider)).createOrUpdateSingle(csa);
      navigator.pop();
    }
  }
}
