import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result_rule.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/bout_config_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/bout_result_rule_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/bout_result_rule_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/scratch_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_common/common.dart';

mixin class BoutConfigOverviewTab implements AbstractOverviewTab<BoutConfig> {
  @override
  (Tab, Widget) buildTab(BuildContext context, {required initialData}) {
    final localizations = context.l10n;
    final Widget tabContent = SingleConsumer<BoutConfig>(
      id: initialData.id,
      initialData: initialData,
      builder: (context, boutConfig) {
        return InfoWidget(
          obj: boutConfig,
          editPage: BoutConfigEdit(boutConfig: boutConfig),
          classLocale: localizations.boutConfig,
          children: [
            ContentItem(
              title: '${boutConfig.periodDuration.formatMinutesAndSeconds()} ✕ ${boutConfig.periodCount}',
              subtitle: localizations.periodDuration,
              icon: Icons.timelapse,
            ),
            ContentItem(
              title: boutConfig.breakDuration.formatMinutesAndSeconds(),
              subtitle: localizations.breakDuration,
              icon: Icons.timelapse,
            ),
            ContentItem(
              title: boutConfig.activityDuration?.formatMinutesAndSeconds() ?? '-',
              subtitle: localizations.activityDuration,
              icon: Icons.timelapse,
            ),
            ContentItem(
              title: boutConfig.injuryDuration?.formatMinutesAndSeconds() ?? '-',
              subtitle: localizations.injuryDuration,
              icon: Icons.timelapse,
            ),
            ContentItem(
              title: boutConfig.bleedingInjuryDuration?.formatMinutesAndSeconds() ?? '-',
              subtitle: localizations.bleedingInjuryDuration,
              icon: Icons.timelapse,
            ),
            FilterableManyConsumer<BoutResultRule, BoutConfig>.edit(
              context: context,
              shrinkWrap: true,
              editPageBuilder: (context) => BoutResultRuleEdit(initialBoutConfig: boutConfig),
              filterObject: boutConfig,
              itemBuilder:
                  (context, item) => ContentItem(
                    title: item.localize(context),
                    icon: Icons.rule,
                    onTap: () {
                      if (GoRouterState.of(context).isScratchBoutRoute) {
                        // Ensure the provider scope is available
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BoutResultRuleOverview(id: item.id!)),
                        );
                      } else {
                        BoutResultRuleOverview.navigateTo(context, item);
                      }
                    },
                  ),
            ),
          ],
        );
      },
    );
    return (Tab(child: HeadingText(localizations.boutConfig)), tabContent);
  }

  @override
  Future<void> onDelete(BuildContext context, WidgetRef ref, {required BoutConfig single}) async {
    await (await ref.read(dataManagerNotifierProvider)).deleteSingle<BoutConfig>(single);
  }
}
