import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/competition_bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_bout_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionBoutOverview extends BoutOverview<CompetitionBout> {
  static const route = 'competition_bout';

  final int id;
  final CompetitionBout? competitionBout;

  CompetitionBoutOverview({super.key, required this.id, this.competitionBout})
    : super(boutConfig: competitionBout?.competition.boutConfig ?? Competition.defaultBoutConfig);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;

    return SingleConsumer<CompetitionBout>(
      id: id,
      initialData: competitionBout,
      builder: (context, competitionBout) {
        // final bout = competitionBout.bout;
        // Future<List<BoutAction>> getActions() => ref.readAsync(
        //     manyDataStreamProvider<BoutAction, Bout>(ManyProviderData<BoutAction, Bout>(filterObject: bout)).future);

        // final pdfAction = IconButton(
        //   icon: const Icon(Icons.print),
        //   onPressed: () async {
        //     final actions = await getActions();
        //     final boutRules = await ref.readAsync(manyDataStreamProvider<BoutResultRule, BoutConfig>(
        //                 ManyProviderData<BoutResultRule, BoutConfig>(
        //                     filterObject: competitionBout.competition.boutConfig))
        //             .future);
        //     final isTimeCountDown = await ref.read(timeCountDownNotifierProvider);
        //     if (context.mounted) {
        //       final bytes = await ScoreSheet(
        //         bout: bout,
        //         boutActions: actions,
        //         buildContext: context,
        //         wrestlingEvent: competitionBout.competition,
        //         boutConfig: competitionBout.competition.boutConfig,
        //         boutRules: boutRules,
        //         isTimeCountDown: isTimeCountDown,
        //         weightClass: competitionBout.weightClass,
        //       ).buildPdf();
        //       Printing.sharePdf(bytes: bytes, filename: '${bout.getFileBaseName(competitionBout.competition)}.pdf');
        //     }
        //   },
        // );

        return buildOverview(
          context,
          ref,
          classLocale: localizations.bout,
          editPage: CompetitionBoutEdit(
            competitionBout: competitionBout,
            initialCompetition: competitionBout.competition,
          ),
          onDelete:
              () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<CompetitionBout>(competitionBout),
          tiles: [],
          actions: [
            // pdfAction,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.tv),
                onPressed: () => handleSelectedBoutDisplay(competitionBout, context),
                label: Text(localizations.display),
              ),
            ),
          ],
          dataId: competitionBout.bout.id!,
          initialData: competitionBout.bout,
          subClassData: competitionBout,
        );
      },
    );
  }

  handleSelectedBoutDisplay(CompetitionBout bout, BuildContext context) {
    context.push(
      '/${CompetitionOverview.route}/${bout.competition.id}/${CompetitionBoutOverview.route}/${bout.id}/${CompetitionBoutDisplay.route}',
    );
  }
}

// extension BoutFileExt on Bout {
//   String getFileBaseName(WrestlingEvent event) {
//     final fileNameBuilder = [
//       event.date.toIso8601String().substring(0, 10),
//       id?.toString(),
//       r?.membership.person.surname,
//       '–',
//       b?.membership.person.surname,
//     ];
//     fileNameBuilder.removeWhere((e) => e == null || e.isEmpty);
//     return fileNameBuilder.map((e) => e!.replaceAll(' ', '-')).join('_');
//   }
// }
