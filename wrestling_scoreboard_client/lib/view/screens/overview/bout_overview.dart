import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class BoutOverview extends ConsumerWidget implements AbstractOverview<Bout> {
  static const route = 'bout';

  const BoutOverview({super.key});

  @override
  Widget buildOverview(
    BuildContext context,
    WidgetRef ref, {
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
          onDelete: () async {
            onDelete();
            (await ref.read(dataManagerNotifierProvider)).deleteSingle<Bout>(data);
          },
          classLocale: classLocale,
          children: [
            ...tiles,
            ContentItem(
              title: data.r?.fullName(context) ?? localizations.participantVacant,
              subtitle: localizations.red,
              icon: Icons.person,
            ),
            ContentItem(
              title: data.b?.fullName(context) ?? localizations.participantVacant,
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
            TooltipVisibility(
              visible: data.result != null,
              child: Tooltip(
                message: data.result?.description(context) ?? '-',
                child: ContentItem(
                  title: data.result?.abbreviation(context) ?? '-',
                  subtitle: localizations.result,
                  icon: Icons.label,
                ),
              ),
            ),
            ContentItem(
              title: data.duration.formatMinutesAndSeconds(),
              subtitle: localizations.duration,
              icon: Icons.timer,
            ),
          ],
        );
        return OverviewScaffold<Bout>(
          dataObject: data,
          label: classLocale,
          details: data.title(context),
          body: GroupedList(items: [
            description,
          ]),
        );
      },
    );
  }
}
