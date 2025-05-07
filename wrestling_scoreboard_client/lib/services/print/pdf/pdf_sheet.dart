import 'dart:typed_data';

import 'package:flutter/material.dart' show BuildContext;
import 'package:wrestling_scoreboard_client/l10n/app_localizations.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/components.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class PdfSheet {
  static const PdfPageFormat a4 = PdfPageFormat(
    21.0 * PdfPageFormat.cm,
    29.7 * PdfPageFormat.cm,
    marginAll: 1.0 * PdfPageFormat.cm,
  );
  static const PdfPageFormat a4Cross = PdfPageFormat(
    29.7 * PdfPageFormat.cm,
    21.0 * PdfPageFormat.cm,
    marginAll: 1.0 * PdfPageFormat.cm,
  );

  static const horizontalGap = 8.0;
  static const verticalGap = 8.0;

  static const pencilColor = PdfColors.brown600;
  static const homeColor = PdfColors.red;
  static const guestColor = PdfColors.blue;

  final PdfColor baseColor;
  final PdfColor accentColor;
  late final AppLocalizations localizations;
  final BuildContext buildContext;

  PdfSheet({
    this.baseColor = PdfColors.blueGrey500,
    this.accentColor = PdfColors.blueGrey900,
    required this.buildContext,
  }) {
    localizations = AppLocalizations.of(buildContext)!;
  }

  Future<Uint8List> buildPdf({PdfPageFormat? pageFormat});

  Widget buildFooter(Context context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '© ${DateTime.now().year} - August Oberhauser',
          style: const TextStyle(fontSize: 6, color: PdfColors.grey500),
        ),
        Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const TextStyle(fontSize: 8, color: PdfColors.grey800),
        ),
      ],
    );
  }

  Future<PageTheme> buildTheme({PdfPageFormat pageFormat = PdfSheet.a4, Font? base, Font? bold, Font? italic}) async {
    return PageTheme(
      pageFormat: pageFormat,
      theme: ThemeData.withFont(
        base: base ?? await PdfGoogleFonts.robotoRegular(),
        bold: bold ?? await PdfGoogleFonts.robotoBold(),
        italic: italic ?? await PdfGoogleFonts.robotoItalic(),
      ),
    );
  }

  Widget buildInfo(Context context, WrestlingEvent wrestlingEvent) {
    return Table(
      columnWidths: {
        0: const FlexColumnWidth(2),
        1: const FlexColumnWidth(1),
        2: const FlexColumnWidth(1),
        3: const FlexColumnWidth(1),
        4: const FixedColumnWidth(120),
      },
      children: [
        TableRow(
          children: [
            TableCell(
              columnSpan: wrestlingEvent is TeamMatch ? 1 : 2,
              child: buildFormCell(
                title: '${localizations.event}-${localizations.name}',
                content:
                    wrestlingEvent is TeamMatch
                        ? ('${wrestlingEvent.home.team.name} – ${wrestlingEvent.guest.team.name}')
                        : (wrestlingEvent as Competition).name,
                color: PdfColors.grey100,
                pencilColor: PdfSheet.pencilColor,
                height: 40,
              ),
            ),
            if (wrestlingEvent is TeamMatch)
              buildFormCell(
                title: localizations.league,
                content: wrestlingEvent.league?.fullname,
                color: PdfColors.grey100,
                pencilColor: PdfSheet.pencilColor,
                height: 40,
              ),
            buildFormCell(
              title: localizations.date,
              content: wrestlingEvent.date.toDateTimeStringFromLocaleName(localizations.localeName),
              color: PdfColors.grey100,
              pencilColor: PdfSheet.pencilColor,
              height: 40,
            ),
            buildFormCell(
              title: localizations.place,
              // ?? localizations.location,
              content: wrestlingEvent.location,
              color: PdfColors.grey100,
              pencilColor: PdfSheet.pencilColor,
              height: 40,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildPerson({required String title, String? no, double? width}) {
    const cellHeight = 30.0;
    return buildFormCell(title: '$title (Name/Nr.)', content: no, height: cellHeight, width: width);
  }

  List<Widget> buildStaff(Context context, WrestlingEvent wrestlingEvent, {double? width}) {
    Person? timeKeeper;
    Person? transcriptWriter;
    if (wrestlingEvent is TeamMatch) {
      timeKeeper = wrestlingEvent.timeKeeper;
      transcriptWriter = wrestlingEvent.transcriptWriter;
    } else if (wrestlingEvent is Competition) {}

    return [
      buildPerson(
        title: localizations.timeKeeper.toUpperCase(),
        no: timeKeeper == null ? '' : '${timeKeeper.id} / ${timeKeeper.fullName}',
        width: width,
      ),
      buildPerson(
        title: localizations.transcriptionWriter.toUpperCase(),
        no: transcriptWriter == null ? '' : '${transcriptWriter.id} / ${transcriptWriter.fullName}',
        width: width,
      ),
    ];
  }

  List<Widget> buildStewards(Context context, WrestlingEvent wrestlingEvent, {double? width}) {
    List<Person?> stewards = [];
    // TODO: stewards from list
    if (stewards.length < 3) {
      stewards.addAll(Iterable.generate(3 - stewards.length, (i) => null));
    }
    return stewards
        .map(
          (steward) => buildPerson(
            title: localizations.steward.toUpperCase(),
            no: steward == null ? '' : '${steward.id} / ${steward.fullName}',
            width: width,
          ),
        )
        .toList();
  }

  List<Widget> buildReferees(Context context, WrestlingEvent wrestlingEvent, {double? width}) {
    Person? matChairman;
    Person? referee;
    Person? judge;
    if (wrestlingEvent is TeamMatch) {
      matChairman = wrestlingEvent.matChairman;
      referee = wrestlingEvent.referee;
      judge = wrestlingEvent.judge;
    } else if (wrestlingEvent is Competition) {
      // TODO: get referees from bout
      // matChairman = bout.matChairman;
      // referee = bout.referee;
      // judge = bout.judge;
    }

    return [
      buildPerson(
        title: localizations.matChairman.toUpperCase(),
        no: matChairman == null ? '' : '${matChairman.id} / ${matChairman.fullName}',
        width: width,
      ),
      buildPerson(
        title: localizations.referee.toUpperCase(),
        no: referee == null ? '' : '${referee.id} / ${referee.fullName}',
        width: width,
      ),
      buildPerson(
        title: localizations.judge.toUpperCase(),
        no: judge == null ? '' : '${judge.id} / ${judge.fullName}',
        width: width,
      ),
    ];
  }
}
