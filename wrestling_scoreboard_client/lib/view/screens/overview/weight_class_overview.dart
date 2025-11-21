import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/weight_class.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

mixin WeightClassOverview<T extends DataObject> implements AbstractOverview<WeightClass, T> {
  @override
  Widget buildOverview(
    BuildContext context,
    WidgetRef ref, {
    required String classLocale,
    String? details,
    required Widget editPage,
    required VoidCallback onDelete,
    required List<Widget> tiles,
    List<ResponsiveScaffoldActionItem> actions = const [],
    required int dataId,
    WeightClass? initialData,
    Map<Tab, Widget> Function(WeightClass data)? buildRelations,
    required T subClassData,
  }) {
    final localizations = context.l10n;
    return SingleConsumer<WeightClass>(
      id: dataId,
      initialData: initialData,
      builder: (context, weightClass) {
        final description = InfoWidget(
          obj: weightClass,
          editPage: editPage,
          onDelete: () async {
            onDelete();
            (await ref.read(dataManagerProvider)).deleteSingle<WeightClass>(weightClass);
          },
          classLocale: classLocale,
          children: [
            ...tiles,
            ContentItem.icon(
              title: weightClass.weight.toString(),
              subtitle: localizations.weight,
              iconData: Icons.fitness_center,
            ),
            ContentItem.icon(
              title: weightClass.style.localize(context),
              subtitle: localizations.wrestlingStyle,
              iconData: Icons.style,
            ),
            ContentItem.icon(
              title: weightClass.unit.toAbbr(),
              subtitle: localizations.weightUnit,
              iconData: Icons.straighten,
            ),
            ContentItem.icon(
              title: weightClass.suffix ?? '-',
              subtitle: localizations.suffix,
              iconData: Icons.description,
            ),
          ],
        );
        final relations = buildRelations != null ? buildRelations(weightClass) : {};
        return FavoriteScaffold<T>(
          dataObject: subClassData,
          label: classLocale,
          details: details ?? weightClass.abbreviation(context),
          tabs: [Tab(child: HeadingText(localizations.info)), ...relations.keys],
          actions: actions,
          body: TabGroup(items: [description, ...relations.values]),
        );
      },
    );
  }
}
