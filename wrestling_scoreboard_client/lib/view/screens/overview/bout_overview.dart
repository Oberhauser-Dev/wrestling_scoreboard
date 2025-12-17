import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/duration.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/membership_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/image.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

mixin BoutOverview<T extends DataObject> implements AbstractOverview<Bout, T> {
  @override
  Widget buildOverview(
    BuildContext context,
    WidgetRef ref, {
    required String classLocale,
    String? details,
    required Widget editPage,
    required VoidCallback onDelete,
    required List<Widget> tiles,
    List<DefaultResponsiveScaffoldActionItem> actions = const [],
    required int dataId,
    Bout? initialData,
    Map<Tab, Widget> Function(Bout data)? buildRelations,
    required T subClassData,
    BoutConfig? boutConfig,
  }) {
    final localizations = context.l10n;
    return SingleConsumer<Bout>(
      id: dataId,
      initialData: initialData,
      builder: (context, bout) {
        final description = InfoWidget(
          obj: bout,
          editPage: editPage,
          onDelete: () async {
            onDelete();
            (await ref.read(dataManagerProvider)).deleteSingle<Bout>(bout);
          },
          classLocale: classLocale,
          children: [
            ...tiles,
            ContentItem(
              title: bout.r?.fullName(context) ?? localizations.participantVacant,
              subtitle: localizations.red,
              icon:
                  bout.r?.membership.person.imageUri == null
                      ? Icon(Icons.person)
                      : CircularImage(imageUri: bout.r!.membership.person.imageUri!),
              onTap: bout.r == null ? null : () => MembershipOverview.navigateTo(context, bout.r!.membership),
            ),
            ContentItem(
              title: bout.b?.fullName(context) ?? localizations.participantVacant,
              subtitle: localizations.blue,
              icon:
                  bout.b?.membership.person.imageUri == null
                      ? Icon(Icons.person)
                      : CircularImage(imageUri: bout.b!.membership.person.imageUri!),
              onTap: bout.b == null ? null : () => MembershipOverview.navigateTo(context, bout.b!.membership),
            ),
            ContentItem.icon(
              title: bout.winnerRole?.name ?? '-',
              subtitle: localizations.winner,
              iconData: Icons.emoji_events,
            ),
            TooltipVisibility(
              visible: bout.result != null,
              child: Tooltip(
                message: bout.result?.description(context) ?? '-',
                child: ContentItem.icon(
                  title: bout.result?.abbreviation(context) ?? '-',
                  subtitle: localizations.result,
                  iconData: Icons.label,
                ),
              ),
            ),
            LoadingBuilder<bool>(
              future: ref.watch(timeCountDownProvider),
              builder: (context, isTimeCountDown) {
                return ContentItem.icon(
                  title:
                      bout.duration
                          .invertIf(isTimeCountDown, max: boutConfig!.totalPeriodDuration)
                          .formatMinutesAndSeconds(),
                  subtitle: localizations.duration,
                  iconData: Icons.timer,
                );
              },
            ),
            ContentItem.icon(title: bout.comment ?? '-', subtitle: localizations.comment, iconData: Icons.comment),
          ],
        );
        final relations = buildRelations != null ? buildRelations(bout) : {};
        return FavoriteScaffold<T>(
          dataObject: subClassData,
          label: classLocale,
          details: details ?? bout.title(context),
          tabs: [Tab(child: HeadingText(localizations.info)), ...relations.keys],
          actions: actions,
          body: TabGroup(items: [description, ...relations.values]),
        );
      },
    );
  }
}
