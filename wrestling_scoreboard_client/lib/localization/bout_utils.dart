import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_common/common.dart';

MaterialColor getColorFromBoutRole(BoutRole role) {
  return role == BoutRole.red ? Colors.red : Colors.blue;
}

String getBoutTitle(BuildContext context, Bout bout) {
  final weightClass = bout.weightClass;
  return '${weightClass == null ? '' : '${weightClass.name}, ${styleToAbbr(weightClass.style, context)} | '}'
      '${getParticipationStateName(context, bout.r)} vs. ${getParticipationStateName(context, bout.b)}';
}

String getParticipationStateName(BuildContext context, ParticipantState? participantState) {
  return participantState?.participation.membership.person.fullName ?? AppLocalizations.of(context)!.participantVacant;
}
