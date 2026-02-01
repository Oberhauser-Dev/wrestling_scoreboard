import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/weight_class.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension TeamMatchLocalization on TeamMatch {
  String localize(BuildContext context) {
    return '${date.toDateString(context)}, ${no ?? 'no ID'}, ${home.team.name} - ${guest.team.name}';
  }

  String? missingAttributes(
    BuildContext context,
    Map<Person, PersonRole> personsWithRoles,
    Iterable<TeamMatchBout> teamMatchBouts,
  ) {
    final missingAttr = <String>[];
    final localizations = context.l10n;
    if (home.classificationPoints == 0 && guest.classificationPoints == 0) {
      missingAttr.add(localizations.classificationPoints);
    }
    missingAttr.addAll(_missingLineupAttributes(localizations, home, localizations.home));
    missingAttr.addAll(_missingLineupAttributes(localizations, guest, localizations.guest));

    final roles = personsWithRoles.values;
    if (!roles.any((role) => role == PersonRole.referee)) {
      missingAttr.add(localizations.referee);
    }
    if (!roles.any((role) => role == PersonRole.steward)) {
      missingAttr.add(localizations.steward);
    }
    if (!roles.any((role) => role == PersonRole.transcriptWriter)) {
      missingAttr.add(localizations.transcriptionWriter);
    }
    if (endDate == null) {
      missingAttr.add(localizations.endDate);
    }
    if (location == null) {
      missingAttr.add(localizations.place);
    }
    if (visitorsCount == null) {
      missingAttr.add(localizations.visitors);
    }
    if (no == null) {
      missingAttr.add(localizations.matchNumber);
    }
    if (teamMatchBouts.isEmpty) {
      missingAttr.add('${localizations.bouts} (${localizations.noItems})');
    }
    if (teamMatchBouts.any((tmb) => tmb.bout.result == null)) {
      missingAttr.add(
        '${localizations.boutResult} (${teamMatchBouts.where((tmb) => tmb.bout.result == null).map((tmb) => tmb.weightClass?.abbreviation(context)).join(', ')})',
      );
    }

    if (missingAttr.isEmpty) return null;
    return missingAttr.map((e) => '• $e').join('\n');
  }

  List<String> _missingLineupAttributes(AppLocalizations localizations, TeamLineup lineup, String lineupLocalization) {
    final missingAttr = <String>[];
    if (lineup.classificationPoints == null) {
      missingAttr.add('${localizations.classificationPoints} ($lineupLocalization)');
    }
    if (lineup.coach == null) {
      missingAttr.add('${localizations.coach} ($lineupLocalization)');
    }
    if (lineup.leader == null) {
      missingAttr.add('${localizations.leader} ($lineupLocalization)');
    }
    return missingAttr;
  }
}
