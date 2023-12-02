import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard_client/ui/components/info.dart';
import 'package:wrestling_scoreboard_client/ui/edit/team_edit.dart';
import 'package:wrestling_scoreboard_client/ui/overview/common.dart';
import 'package:wrestling_scoreboard_client/ui/overview/shared/matches_widget.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamOverview<T extends DataObject> extends StatelessWidget {
  static const route = 'team';

  final int id;
  final Team? team;

  const TeamOverview({Key? key, required this.id, this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              onDelete: () => dataProvider.deleteSingle(data),
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
