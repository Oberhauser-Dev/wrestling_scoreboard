import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/season.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/division_weight_class_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/division_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/weight_class_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class DivisionWeightClassOverview extends ConsumerWidget with WeightClassOverview<DivisionWeightClass> {
  static const route = 'division_weight_class';

  static void navigateTo(BuildContext context, DivisionWeightClass dataObject) {
    context.push('/$route/${dataObject.id}');
  }

  final int id;
  final DivisionWeightClass? divisionWeightClass;

  const DivisionWeightClassOverview({super.key, required this.id, this.divisionWeightClass});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<DivisionWeightClass>(
      id: id,
      initialData: divisionWeightClass,
      builder: (context, data) {
        return buildOverview(
          context,
          ref,
          classLocale: localizations.weightClass,
          editPage: DivisionWeightClassEdit(divisionWeightClass: data, initialDivision: data.division),
          onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<DivisionWeightClass>(data),
          tiles: [
            ContentItem(
              title: data.division.fullname,
              subtitle: localizations.division,
              icon: Icons.inventory,
              onTap: () => DivisionOverview.navigateTo(context, data.division),
            ),
            ContentItem(
              title: data.seasonPartition?.asSeasonPartition(context, data.division.seasonPartitions) ?? '-',
              subtitle: localizations.seasonPartition,
              icon: Icons.sunny_snowing,
            ),
          ],
          dataId: data.weightClass.id!,
          initialData: data.weightClass,
          subClassData: data,
        );
      },
    );
  }
}
