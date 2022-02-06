import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/wrestling_style.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/components/info.dart';
import 'package:wrestling_scoreboard/ui/edit/league_weight_class_edit.dart';

class LeagueWeightClassOverview extends StatelessWidget {
  final LeagueWeightClass filterObject;

  const LeagueWeightClassOverview({Key? key, required this.filterObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<LeagueWeightClass>(
      id: filterObject.id!,
      initialData: filterObject,
      builder: (context, data) {
        final description = InfoWidget(
          obj: data!,
          editPage: LeagueWeightClassEdit(
            leagueWeightClass: data,
            league: data.league,
          ),
          children: [
            ContentItem(
              title: data.weightClass.weight.toString(),
              subtitle: localizations.weight,
              icon: Icons.fitness_center,
            ),
            ContentItem(
              title: styleToString(data.weightClass.style, context),
              subtitle: localizations.wrestlingStyle,
              icon: Icons.style,
            ),
            ContentItem(
              title: data.weightClass.unit.toAbbr(),
              subtitle: localizations.weightUnit,
              icon: Icons.straighten,
            ),
            ContentItem(
              title: data.weightClass.suffix ?? '-',
              subtitle: localizations.suffix,
              icon: Icons.description,
            ),
          ],
          classLocale: localizations.weightClass,
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(data.weightClass.name),
          ),
          body: GroupedList(items: [
            description,
          ]),
        );
      },
    );
  }
}
