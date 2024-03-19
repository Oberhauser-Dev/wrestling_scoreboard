import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/matches_widget.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamOverview<T extends DataObject> extends ConsumerWidget {
  static const route = 'team';

  final int id;
  final Team? team;

  const TeamOverview({super.key, required this.id, this.team});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<Team>(
        id: id,
        initialData: team,
        builder: (context, data) {
          final description = InfoWidget(
              obj: data,
              editPage: TeamEdit(
                team: data,
              ),
              onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<Team>(data),
              classLocale: localizations.team,
              children: [
                ContentItem(
                  title: data.description ?? '-',
                  subtitle: localizations.description,
                  icon: Icons.subject,
                ),
                ContentItem(
                  title: data.club.name,
                  subtitle: localizations.club,
                  icon: Icons.foundation,
                ),
              ]);
          return Scaffold(
            appBar: AppBar(
              title: AppBarTitle(label: localizations.team, details: data.name),
            ),
            body: GroupedList(items: [
              description,
              MatchesWidget<Team>(filterObject: data),
            ]),
          );
        });
  }
}
