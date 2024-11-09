import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result_rule.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/bout_result_rule_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/bout_result_rule_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class BoutConfigOverview<T extends DataObject> extends ConsumerWidget
    implements AbstractOverview<BoutConfig, T> {
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
    required T subClassData,
  }) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<BoutConfig>(
      id: dataId,
      initialData: initialData,
      builder: (context, boutConfig) {
        final description = InfoWidget(
          obj: boutConfig,
          editPage: editPage,
          onDelete: () async {
            onDelete();
            (await ref.read(dataManagerNotifierProvider)).deleteSingle<BoutConfig>(boutConfig);
          },
          classLocale: classLocale,
          children: [
            ...tiles,
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
          ],
        );
        final relations = buildRelations != null ? buildRelations(boutConfig) : {};
        return FavoriteScaffold<T>(
          dataObject: subClassData,
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
              filterObject: boutConfig,
              builder: (BuildContext context, List<BoutResultRule> boutResultRule) {
                return GroupedList(
                  header: HeadingItem(
                    trailing: RestrictedAddButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BoutResultRuleEdit(initialBoutConfig: boutConfig),
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
