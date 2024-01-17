import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/data/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard_client/ui/components/info.dart';
import 'package:wrestling_scoreboard_client/ui/overview/common.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class WeightClassOverview extends ConsumerWidget implements AbstractOverview<WeightClass> {
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
          onDelete: () {
            onDelete();
            ref.read(dataManagerProvider).deleteSingle<WeightClass>(data);
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
              title: styleToString(data.style, context),
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
        return Scaffold(
          appBar: AppBar(
            title: AppBarTitle(label: classLocale, details: data.name),
          ),
          body: GroupedList(items: [
            description,
          ]),
        );
      },
    );
  }
}
