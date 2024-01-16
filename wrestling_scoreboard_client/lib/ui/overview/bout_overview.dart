import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/data/bout_result.dart';
import 'package:wrestling_scoreboard_client/data/bout_utils.dart';
import 'package:wrestling_scoreboard_client/data/time.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard_client/ui/components/info.dart';
import 'package:wrestling_scoreboard_client/ui/overview/common.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class BoutOverview extends StatelessWidget implements AbstractOverview<Bout> {
  const BoutOverview({super.key});

  @override
  Widget buildOverview(
    BuildContext context, {
    required String classLocale,
    required Widget editPage,
    required VoidCallback onDelete,
    required List<Widget> tiles,
    required int dataId,
    Bout? initialData,
  }) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<Bout>(
      id: dataId,
      initialData: initialData,
      builder: (context, data) {
        final description = InfoWidget(
          obj: data,
          editPage: editPage,
          onDelete: () {
            onDelete();
            dataProvider.deleteSingle<Bout>(data);
          },
          classLocale: classLocale,
          children: [
            ...tiles,
            ContentItem(
              title: getParticipationStateName(context, data.r),
              subtitle: localizations.red,
              icon: Icons.person,
            ),
            ContentItem(
              title: getParticipationStateName(context, data.b),
              subtitle: localizations.blue,
              icon: Icons.person,
            ),
            ContentItem(
              title: data.weightClass?.name ?? '-',
              subtitle: localizations.weight,
              icon: Icons.fitness_center,
            ),
            ContentItem(
              title: data.winnerRole?.name ?? '-',
              subtitle: localizations.winner,
              icon: Icons.emoji_events,
            ),
            Tooltip(
              message: getDescriptionFromBoutResult(data.result, context),
              child: ContentItem(
                title: getAbbreviationFromBoutResult(data.result, context),
                subtitle: localizations.result,
                icon: Icons.label,
              ),
            ),
            ContentItem(
              title: formatTime(data.duration),
              subtitle: localizations.duration,
              icon: Icons.timelapse,
            ),
          ],
        );
        return Scaffold(
          appBar: AppBar(
            title: AppBarTitle(label: classLocale, details: getBoutTitle(context, data)),
          ),
          body: GroupedList(items: [
            description,
          ]),
        );
      },
    );
  }
}
