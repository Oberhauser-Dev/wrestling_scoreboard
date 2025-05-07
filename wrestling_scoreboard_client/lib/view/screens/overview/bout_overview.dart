import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/duration.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class BoutOverview<T extends DataObject> extends ConsumerWidget implements AbstractOverview<Bout, T> {
  static const route = 'bout';
  final BoutConfig boutConfig;

  const BoutOverview({super.key, required this.boutConfig});

  @override
  Widget buildOverview(
    BuildContext context,
    WidgetRef ref, {
    required String classLocale,
    String? details,
    required Widget editPage,
    required VoidCallback onDelete,
    required List<Widget> tiles,
    List<Widget> actions = const [],
    required int dataId,
    Bout? initialData,
    Map<Tab, Widget> Function(Bout data)? buildRelations,
    required T subClassData,
  }) {
    final localizations = context.l10n;
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
            ContentItem(title: data.winnerRole?.name ?? '-', subtitle: localizations.winner, icon: Icons.emoji_events),
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
            LoadingBuilder<bool>(
              future: ref.watch(timeCountDownNotifierProvider),
              builder: (context, isTimeCountDown) {
                return ContentItem(
                  title:
                      data.duration
                          .invertIf(isTimeCountDown, max: boutConfig.totalPeriodDuration)
                          .formatMinutesAndSeconds(),
                  subtitle: localizations.duration,
                  icon: Icons.timer,
                );
              },
            ),
          ],
        );
        return FavoriteScaffold<T>(
          dataObject: subClassData,
          label: classLocale,
          details: details ?? data.title(context),
          tabs: [Tab(child: HeadingText(localizations.info))],
          actions: actions,
          body: TabGroup(items: [description]),
        );
      },
    );
  }
}
