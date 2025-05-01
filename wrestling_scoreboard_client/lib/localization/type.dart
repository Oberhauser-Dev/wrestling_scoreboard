import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_common/common.dart';

String localizeType(BuildContext context, Type type) {
  final localizations = context.l10n;
  return switch (type) {
    const (Bout) => localizations.bouts,
    const (CompetitionBout) => '${localizations.bouts} (${localizations.competition})',
    const (Club) => localizations.clubs,
    const (Organization) => localizations.organizations,
    const (Division) => localizations.divisions,
    const (League) => localizations.leagues,
    const (DivisionWeightClass) => '${localizations.weightClasses} (${localizations.division})',
    const (LeagueTeamParticipation) => localizations.participatingTeam,
    const (LeagueWeightClass) => '${localizations.weightClasses} (${localizations.league})',
    const (Membership) => localizations.memberships,
    const (Person) => localizations.persons,
    const (Team) => localizations.teams,
    const (TeamMatch) => localizations.matches,
    const (TeamMatchBout) => '${localizations.bouts} (${localizations.league})',
    const (WeightClass) => localizations.weightClasses,
    const (BoutAction) => localizations.actions,
    const (TeamLineupParticipation) => localizations.participations,
    const (Competition) => localizations.competitions,
    const (TeamLineup) => localizations.lineups,
    const (BoutConfig) => localizations.boutConfig,
    _ => throw Exception('Localization not defined for $type'),
  };
}
