import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result_rule.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/bout_result_rule_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/bout_result_rule_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class BoutConfigOverview extends ConsumerWidget implements AbstractOverview<BoutConfig> {
  static const route = 'bout_config';

  const BoutConfigOverview({super.key});

  @override
  Widget buildOverview(
    BuildContext context,
    WidgetRef ref, {
    required String classLocale,
    required Widget editPage,
    required VoidCallback onDelete,
    required List<Widget> tiles,
    List<Widget> actions = const [],
    Map<Tab, Widget> Function(BoutConfig data)? buildRelations,
    required int dataId,
    BoutConfig? initialData,
    String? details,
  }) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<BoutConfig>(
      id: dataId,
      initialData: initialData,
      builder: (context, data) {
        final description = InfoWidget(
          obj: data,
          editPage: editPage,
          onDelete: () async {
            onDelete();
            (await ref.read(dataManagerNotifierProvider)).deleteSingle<BoutConfig>(data);
          },
          classLocale: classLocale,
          children: [
            ...tiles,
            ContentItem(
              title: '${data.periodDuration.formatMinutesAndSeconds()} ✕ ${data.periodCount}',
              subtitle: localizations.periodDuration,
              icon: Icons.timelapse,
            ),
            ContentItem(
              title: data.breakDuration.formatMinutesAndSeconds(),
              subtitle: localizations.breakDuration,
              icon: Icons.timelapse,
            ),
            ContentItem(
              title: data.activityDuration.formatMinutesAndSeconds(),
              subtitle: localizations.activityDuration,
              icon: Icons.timelapse,
            ),
            ContentItem(
              title: data.injuryDuration.formatMinutesAndSeconds(),
              subtitle: localizations.injuryDuration,
              icon: Icons.timelapse,
            ),
          ],
        );
        final relations = buildRelations != null ? buildRelations(data) : {};
        return OverviewScaffold<BoutConfig>(
          dataObject: data,
          label: classLocale,
          details: details ?? '',
          tabs: [
            Tab(child: HeadingText(localizations.info)),
            ...relations.keys,
            Tab(child: HeadingText(localizations.boutResultRules)),
          ],
          actions: actions,
          body: TabGroup(items: [
            description,
            ...relations.values,
            ManyConsumer<BoutResultRule, BoutConfig>(
              filterObject: data,
              builder: (BuildContext context, List<BoutResultRule> boutResultRule) {
                return GroupedList(
                  header: HeadingItem(
                    trailing: RestrictedAddButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BoutResultRuleEdit(initialBoutConfig: data),
                        ),
                      ),
                    ),
                  ),
                  items: boutResultRule.map((e) {
                    return SingleConsumer<BoutResultRule>(
                      id: e.id,
                      initialData: e,
                      builder: (context, data) {
                        return ContentItem(
                            title: data.localize(context),
                            icon: Icons.rule,
                            onTap: () => handleSelectedBoutResultRule(data, context));
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

  handleSelectedBoutResultRule(BoutResultRule boutResultRule, BuildContext context) {
    context.push('/${BoutResultRuleOverview.route}/${boutResultRule.id}');
  }
}
