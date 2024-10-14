import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class WeightClassOverview extends ConsumerWidget implements AbstractOverview<WeightClass> {
  static const route = 'weight_class';

  const WeightClassOverview({super.key});

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
    WeightClass? initialData,
    Map<Tab, Widget> Function(WeightClass data)? buildRelations,
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
          details: details ?? data.name,
          tabs: [
            Tab(child: HeadingText(localizations.info)),
          ],
          actions: actions,
          body: TabGroup(items: [
            description,
          ]),
        );
      },
    );
  }
}
