import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/organization_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/division_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/matches_widget.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/division_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class OrganizationOverview extends ConsumerWidget {
  static const route = 'organization';

  final int id;
  final Organization? organization;

  const OrganizationOverview({super.key, required this.id, this.organization});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<Organization>(
      id: id,
      initialData: organization,
      builder: (context, data) {
        final description = InfoWidget(
          obj: data,
          editPage: OrganizationEdit(
            organization: data,
          ),
          onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<Organization>(data),
          classLocale: localizations.organization,
          children: [
            ContentItem(
              title: data.name,
              subtitle: localizations.name,
              icon: Icons.label,
            ),
          ],
        );
        return Scaffold(
          appBar: AppBar(
            title: AppBarTitle(label: localizations.organization, details: data.name),
          ),
          body: GroupedList(items: [
            description,
            ManyConsumer<Division, Organization>(
              filterObject: data,
              builder: (BuildContext context, List<Division> teamParticipations) {
                return ListGroup(
                  header: HeadingItem(
                    title: localizations.participatingTeams,
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DivisionEdit(
                            initialOrganization: data,
                          ),
                        ),
                      ),
                    ),
                  ),
                  items: teamParticipations.map(
                    (e) => SingleConsumer<Division>(
                        id: e.id,
                        initialData: e,
                        builder: (context, data) {
                          return ContentItem(
                            title: data.fullname,
                            icon: Icons.group,
                            onTap: () => handleSelectedTeam(data, context),
                          );
                        }),
                  ),
                );
              },
            ),
            MatchesWidget<Organization>(filterObject: data),
            ManyConsumer<Competition, Organization>(
              filterObject: data,
              builder: (BuildContext context, List<Competition> competitions) {
                return ListGroup(
                  header: HeadingItem(
                    title: localizations.competitions,
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => CompetitionEdit(initialOrganization: data),
                        //   ),
                        // );
                      },
                    ),
                  ),
                  items: competitions.map((e) {
                    return SingleConsumer<Competition>(
                      id: e.id,
                      initialData: e,
                      builder: (context, data) {
                        return ContentItem(
                            title: e.name,
                            icon: Icons.leaderboard,
                            onTap: () => handleSelectedCompetition(data, context));
                      },
                    );
                  }),
                );
              },
            ),
          ]),
        );
      },
    );
  }

  handleSelectedTeam(Division division, BuildContext context) {
    context.push('/${DivisionOverview.route}/${division.id}');
  }

  handleSelectedCompetition(Competition competition, BuildContext context) {
    // context.push('/${CompetitionOverview.route}/${competition.id}');
  }
}
