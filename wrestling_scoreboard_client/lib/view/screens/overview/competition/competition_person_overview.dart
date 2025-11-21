import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/person_role.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_person_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/person_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/image.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionPersonOverview extends ConsumerWidget {
  static const route = 'competition_person';

  static void navigateTo(BuildContext context, CompetitionPerson dataObject) {
    context.push('/$route/${dataObject.id}');
  }

  final int id;
  final CompetitionPerson? competitionPerson;

  const CompetitionPersonOverview({super.key, required this.id, this.competitionPerson});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<CompetitionPerson>(
      id: id,
      initialData: competitionPerson,
      builder: (context, competitionPerson) {
        final description = InfoWidget(
          obj: competitionPerson,
          editPage: CompetitionPersonEdit(
            initialOrganization: competitionPerson.competition.organization!,
            competitionPerson: competitionPerson,
          ),
          onDelete:
              () async => (await ref.read(dataManagerProvider)).deleteSingle<CompetitionPerson>(competitionPerson),
          classLocale: localizations.official,
          children: [
            ContentItem(
              title: competitionPerson.person.fullName,
              subtitle: localizations.person,
              icon:
                  competitionPerson.person.imageUri == null
                      ? Icon(Icons.person)
                      : CircularImage(imageUri: competitionPerson.person.imageUri!),
              onTap: () => PersonOverview.navigateTo(context, competitionPerson.person),
            ),
            ContentItem.icon(
              title: competitionPerson.competition.name,
              subtitle: localizations.competition,
              iconData: Icons.leaderboard,
              onTap: () => CompetitionOverview.navigateTo(context, competitionPerson.competition),
            ),
            ContentItem.icon(
              title: competitionPerson.role.localize(context),
              subtitle: localizations.role,
              iconData: Icons.label,
            ),
          ],
        );
        return OverviewScaffold(
          label: '${localizations.official} (${localizations.competition})',
          details: '${competitionPerson.person.fullName} | ${competitionPerson.role.localize(context)}',
          tabs: [Tab(child: HeadingText(localizations.info))],
          body: TabGroup(items: [description]),
        );
      },
    );
  }
}
