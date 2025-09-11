import 'dart:typed_data';

import 'package:flutter/material.dart' show BuildContext;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:wrestling_scoreboard_client/l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/person_role.dart';
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
                        : (wrestlingEvent is Competition ? wrestlingEvent.name : ''),
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

  List<Widget> buildOfficials(
    Context context,
    WrestlingEvent wrestlingEvent, {
    required List<PersonRole> order,
    int Function(PersonRole personRole)? getPlaceHolderCount,
    required Map<PersonRole, Set<Person>> groupedOfficials,
    double? width,
  }) {
    return [
      for (final personRole in order)
        ...(groupedOfficials[personRole] ??
                Iterable.generate(getPlaceHolderCount?.call(personRole) ?? 1, (index) => null).toSet())
            .map(
              (person) => buildPerson(
                title: personRole.localize(buildContext).toUpperCase(),
                no: person == null ? '' : '${person.id} / ${person.fullName}',
                width: width,
              ),
            ),
    ];
  }
}
