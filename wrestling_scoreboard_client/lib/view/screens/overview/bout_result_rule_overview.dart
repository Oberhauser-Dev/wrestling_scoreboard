import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/bout_config.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result_rule.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/bout_result_rule_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class BoutResultRuleOverview extends ConsumerWidget {
  static const route = 'bout_result_rule';

  static void navigateTo(BuildContext context, BoutResultRule boutResultRule) {
    context.push('/$route/${boutResultRule.id}');
  }

  final int id;
  final BoutResultRule? boutResultRule;

  const BoutResultRuleOverview({super.key, required this.id, this.boutResultRule});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<BoutResultRule>(
      id: id,
      initialData: boutResultRule,
      builder: (context, boutResultRule) {
        final description = InfoWidget(
          obj: boutResultRule,
          editPage: BoutResultRuleEdit(boutResultRule: boutResultRule),
          onDelete: () async => (await ref.read(dataManagerProvider)).deleteSingle<BoutResultRule>(boutResultRule),
          classLocale: localizations.boutResultRule,
          children: [
            ContentItem(
              title: boutResultRule.boutConfig.localize(context),
              subtitle: localizations.boutConfig,
              icon: Icons.tune,
            ),
            ContentItem(
              title: boutResultRule.boutResult.fullName(context),
              subtitle: localizations.boutResult,
              icon: Icons.label,
            ),
            ContentItem(
              title:
                  '${boutResultRule.style?.localize(context) ?? '-'} (${boutResultRule.style?.abbreviation(context) ?? '-'})',
              subtitle: localizations.wrestlingStyle,
              icon: Icons.style,
            ),
            ContentItem(
              title: '${boutResultRule.winnerClassificationPoints} : ${boutResultRule.loserClassificationPoints}',
              subtitle: localizations.classificationPoints,
              icon: Icons.pin,
            ),
            ContentItem(
              title: '${boutResultRule.winnerTechnicalPoints ?? '-'} : ${boutResultRule.loserTechnicalPoints ?? '-'}',
              subtitle: localizations.technicalPoints,
              icon: Icons.pin_outlined,
            ),
            ContentItem(
              title: boutResultRule.technicalPointsDifference?.toString() ?? '-',
              subtitle: '${localizations.technicalPoints} ${localizations.difference}',
              icon: Icons.difference,
            ),
          ],
        );
        return FavoriteScaffold<BoutResultRule>(
          dataObject: boutResultRule,
          label: localizations.boutResultRule,
          details: boutResultRule.localize(context),
          tabs: [Tab(child: HeadingText(localizations.info))],
          body: TabGroup(items: [description]),
        );
      },
    );
  }
}
