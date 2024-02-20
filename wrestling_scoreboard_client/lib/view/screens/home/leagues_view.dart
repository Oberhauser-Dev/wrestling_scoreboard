import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/club_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/club_overview.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class LeaguesView extends StatelessWidget {
  const LeaguesView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ResponsiveScrollView(
      child: ManyConsumer<Club, Null>(
        builder: (BuildContext context, List<Club> clubs) {
          return ListGroup(
            header: HeadingItem(
              title: localizations.clubs,
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ClubEdit())),
              ),
            ),
            items: clubs.map(
              (e) => SingleConsumer<Club>(
                id: e.id!,
                initialData: e,
                builder: (context, data) {
                  return ContentItem(
                    title: data.name,
                    icon: Icons.foundation,
                    onTap: () => handleSelectedClub(data, context),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  handleSelectedClub(Club club, BuildContext context) {
    context.push('/${ClubOverview.route}/${club.id}');
  }
}
