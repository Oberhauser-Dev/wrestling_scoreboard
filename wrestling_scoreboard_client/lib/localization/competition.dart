import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension CompetitionBoutLocalization on CompetitionBout {
  String roundDescription(BuildContext context) =>
      [roundType.localize(context), if (rank != null) displayRanks, '(R$displayRound)'].join(' ');
}

extension RoundTypeLocalization on RoundType {
  String localize(BuildContext context) {
    final localizations = context.l10n;
    return switch (this) {
      RoundType.elimination => localizations.elimination,
      RoundType.repechage => localizations.repechage,
      RoundType.semiFinals => localizations.semiFinals,
      RoundType.finals => localizations.finals,
    };
  }

  String short(BuildContext context) {
    final l = localize(context);
    return l.substring(0, math.min(l.length, 4));
  }
}

extension CompetitionSystemPhaseLocalization on CompetitionSystemPhase {
  String localize(BuildContext context, {required int phasesCount}) {
    final localizations = context.l10n;
    return switch (phasesCount - pos) {
      3 => localizations.qualification,
      2 => localizations.pool,
      1 => localizations.finals,
      int() => '?',
    };
  }

  String abbreviation(BuildContext context, {required int phasesCount}) {
    return switch (phasesCount - pos) {
      3 => 'Qual',
      2 => 'Pool',
      1 => 'Final',
      int() => '?',
    };
  }
}

extension CompetitionSystemLocalization on CompetitionSystem {
  String localize(BuildContext context) {
    final localizations = context.l10n;
    return switch (this) {
      CompetitionSystem.finals => localizations.finals,
      CompetitionSystem.bestOfThree => localizations.bestOfThree,
      CompetitionSystem.singleElimination => localizations.singleElimination,
      CompetitionSystem.doubleElimination => localizations.doubleElimination,
      CompetitionSystem.nordic => localizations.nordic,
      CompetitionSystem.nordicDoubleElimination => localizations.nordicDoubleElimination,
    };
  }

  String short(BuildContext context) {
    final l = localize(context);
    return l.substring(0, math.min(l.length, 4));
  }
}

extension CompetitionLocalization on Competition {
  String? missingAttributes(
    BuildContext context,
    Iterable<CompetitionLineup> lineups,
    Iterable<CompetitionBout> competitionBouts,
    Map<Person, PersonRole> personsWithRoles,
  ) {
    final missingAttr = <String>[];
    final localizations = context.l10n;
    for (final lineup in lineups) {
      final missingLineupAttributes = _missingLineupAttributes(localizations, lineup);
      if (missingLineupAttributes != null) missingAttr.add(missingLineupAttributes);
    }

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
      missingAttr.add(localizations.competitionNumber);
    }
    if (competitionBouts.isEmpty) {
      missingAttr.add('${localizations.bouts} (${localizations.noItems})');
    }
    if (competitionBouts.any((cb) => cb.bout.result == null)) {
      missingAttr.add(
        '${localizations.boutResult} (${competitionBouts.where((cb) => cb.bout.result == null).map((cb) => cb.id).join(', ')})',
      );
    }

    if (missingAttr.isEmpty) return null;
    return missingAttr.map((e) => '• $e').join('\n');
  }

  String? _missingLineupAttributes(AppLocalizations localizations, CompetitionLineup lineup) {
    final missingAttr = <String>[];
    if (lineup.coach == null) {
      missingAttr.add(localizations.coach);
    }
    if (lineup.leader == null) {
      missingAttr.add(localizations.leader);
    }

    if (missingAttr.isEmpty) return null;
    return '${lineup.club.name} (${missingAttr.join(', ')})';
  }
}

extension CompetitionSystemAffiliationLocalization on CompetitionSystemAffiliation {
  String localize(BuildContext context) {
    final localizations = context.l10n;
    return '${localizations.participations} (${localizations.maximum}): ${maxContestants ?? '∞'}';
  }
}
