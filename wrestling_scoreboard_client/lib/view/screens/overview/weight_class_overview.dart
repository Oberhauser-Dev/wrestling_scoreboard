import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class WeightClassOverview extends ConsumerWidget implements AbstractOverview<WeightClass> {
  static const route = 'weight_class';

  const WeightClassOverview({super.key});

  @override
  Widget buildOverview(
    BuildContext context,
    WidgetRef ref, {
    required String classLocale,
    required Widget editPage,
    required VoidCallback onDelete,
    required List<Widget> tiles,
    required int dataId,
    WeightClass? initialData,
  }) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<WeightClass>(
      id: dataId,
      initialData: initialData,
      builder: (context, data) {
        final description = InfoWidget(
          obj: data,
          editPage: editPage,
          onDelete: () async {
            onDelete();
            (await ref.read(dataManagerNotifierProvider)).deleteSingle<WeightClass>(data);
          },
          classLocale: classLocale,
          children: [
            ...tiles,
            ContentItem(
              title: data.weight.toString(),
              subtitle: localizations.weight,
              icon: Icons.fitness_center,
            ),
            ContentItem(
              title: data.style.localize(context),
              subtitle: localizations.wrestlingStyle,
              icon: Icons.style,
            ),
            ContentItem(
              title: data.unit.toAbbr(),
              subtitle: localizations.weightUnit,
              icon: Icons.straighten,
            ),
            ContentItem(
              title: data.suffix ?? '-',
              subtitle: localizations.suffix,
              icon: Icons.description,
            ),
          ],
        );
        return OverviewScaffold<WeightClass>(
          dataObject: data,
          label: classLocale,
          details: data.name,
          body: GroupedList(items: [
            description,
          ]),
        );
      },
    );
  }
}
