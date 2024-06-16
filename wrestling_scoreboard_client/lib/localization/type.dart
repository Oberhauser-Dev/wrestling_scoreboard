import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_common/common.dart';

String localizeType(BuildContext context, Type type) {
  final localizations = AppLocalizations.of(context)!;
  return switch (type) {
    const (Bout) => localizations.bouts,
    const (Club) => localizations.clubs,
    const (Organization) => localizations.organizations,
    const (Division) => localizations.divisions,
    const (League) => localizations.leagues,
    const (DivisionWeightClass) => localizations.weightClasses,
    const (LeagueTeamParticipation) => localizations.participatingTeam,
    const (Membership) => localizations.memberships,
    const (Person) => localizations.persons,
    const (Team) => localizations.teams,
    const (TeamMatch) => localizations.matches,
    const (TeamMatchBout) => localizations.bouts,
    const (WeightClass) => localizations.weightClasses,
    const (BoutAction) => localizations.actions,
    const (Participation) => localizations.participations,
    const (Competition) => localizations.competitions,
    const (Lineup) => localizations.lineups,
    const (BoutConfig) => localizations.boutConfig,
    _ => throw Exception('Localization not defined for $type'),
  };
}
