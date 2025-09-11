import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/person_role.dart';
import 'package:wrestling_scoreboard_client/localization/team_match.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/team_match_person_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchPersonOverview extends ConsumerWidget {
  static const route = 'team_match_person';

  static void navigateTo(BuildContext context, TeamMatchPerson dataObject) {
    context.push('/$route/${dataObject.id}');
  }

  final int id;
  final TeamMatchPerson? teamMatchPerson;

  const TeamMatchPersonOverview({super.key, required this.id, this.teamMatchPerson});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<TeamMatchPerson>(
      id: id,
      initialData: teamMatchPerson,
      builder: (context, teamMatchPerson) {
        final description = InfoWidget(
          obj: teamMatchPerson,
          editPage: TeamMatchPersonEdit(
            initialOrganization: teamMatchPerson.teamMatch.organization!,
            teamMatchPerson: teamMatchPerson,
          ),
          onDelete:
              () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<TeamMatchPerson>(teamMatchPerson),
          classLocale: localizations.official,
          children: [
            ContentItem(title: teamMatchPerson.person.fullName, subtitle: localizations.person, icon: Icons.person),
            ContentItem(
              title: teamMatchPerson.teamMatch.localize(context),
              subtitle: localizations.match,
              icon: Icons.event,
            ),
            ContentItem(title: teamMatchPerson.role.localize(context), subtitle: localizations.role, icon: Icons.label),
          ],
        );
        return OverviewScaffold(
          label: '${localizations.official} (${localizations.match})',
          details: '${teamMatchPerson.person.fullName} | ${teamMatchPerson.role.localize(context)}',
          tabs: [Tab(child: HeadingText(localizations.info))],
          body: TabGroup(items: [description]),
        );
      },
    );
  }
}
