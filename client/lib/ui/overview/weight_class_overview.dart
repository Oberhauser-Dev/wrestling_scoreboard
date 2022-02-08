import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/wrestling_style.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/components/info.dart';
import 'package:wrestling_scoreboard/ui/overview/common.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

abstract class WeightClassOverview extends StatelessWidget implements AbstractOverview {
  final WeightClass _filterObject;

  const WeightClassOverview({Key? key, required WeightClass filterObject})
      : _filterObject = filterObject,
        super(key: key);

  @override
  Widget buildOverview(BuildContext context,
      {required String classLocale,
      required Widget editPage,
      required VoidCallback onDelete,
      required List<Widget> tiles}) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<WeightClass>(
      id: _filterObject.id!,
      initialData: _filterObject,
      builder: (context, data) {
        final description = InfoWidget(
          obj: data!,
          editPage: editPage,
          onDelete: () {
            onDelete();
            dataProvider.deleteSingle(data);
          },
          children: [
            ...tiles,
            ContentItem(
              title: _filterObject.weight.toString(),
              subtitle: localizations.weight,
              icon: Icons.fitness_center,
            ),
            ContentItem(
              title: styleToString(_filterObject.style, context),
              subtitle: localizations.wrestlingStyle,
              icon: Icons.style,
            ),
            ContentItem(
              title: _filterObject.unit.toAbbr(),
              subtitle: localizations.weightUnit,
              icon: Icons.straighten,
            ),
            ContentItem(
              title: _filterObject.suffix ?? '-',
              subtitle: localizations.suffix,
              icon: Icons.description,
            ),
          ],
          classLocale: classLocale,
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(_filterObject.name),
          ),
          body: GroupedList(items: [
            description,
          ]),
        );
      },
    );
  }
}
