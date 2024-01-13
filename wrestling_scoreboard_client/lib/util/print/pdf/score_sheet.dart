import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:wrestling_scoreboard_client/ui/display/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/util/date_time.dart';
import 'package:wrestling_scoreboard_client/util/print/pdf/components.dart';
import 'package:wrestling_scoreboard_common/common.dart';

// TODO: Replace boutState with individual dataTypes or introduce model.
Future<Uint8List> generateScoreSheet(BoutState boutState,
    {PdfPageFormat? pageFormat, required, required AppLocalizations localizations}) async {
  final scoreSheet = ScoreSheet(
    boutState: boutState,
    localizations: localizations,
    baseColor: PdfColors.blueGrey500,
    accentColor: PdfColors.blueGrey900,
  );

  return await scoreSheet.buildPdf(pageFormat: pageFormat);
}

class ScoreSheet {
  ScoreSheet({
    required this.boutState,
    required this.baseColor,
    required this.accentColor,
    required this.localizations,
  });

  static const PdfPageFormat a4 =
      PdfPageFormat(21.0 * PdfPageFormat.cm, 29.7 * PdfPageFormat.cm, marginAll: 1.0 * PdfPageFormat.cm);

  static const horizontalGap = 8.0;
  static const verticalGap = 8.0;

  final BoutState boutState;
  final AppLocalizations localizations;

  Bout get bout => boutState.bout;

  TeamMatch get event => boutState.match;
  final PdfColor baseColor;
  final PdfColor accentColor;

  static const _pencilColor = PdfColors.blue900;
  static const _homeColor = PdfColors.red;
  static const _guestColor = PdfColors.blue;

  String? _logo;

  Future<Uint8List> buildPdf({PdfPageFormat? pageFormat}) async {
    final doc = Document();

    _logo = await rootBundle.loadString('assets/images/icons/launcher.svg');
    final actions = await boutState.getActions();

    // Add page to the PDF
    doc.addPage(
      MultiPage(
        pageTheme: _buildTheme(
          pageFormat ?? a4,
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _buildInfoHeader1(context),
          Container(height: verticalGap),
          _buildInfoHeader2(context),
          Container(height: verticalGap),
          _buildParticipantsHeader(context),
          Container(height: verticalGap),
          _buildPointsBody(context, actions),
        ],
      ),
    );

// Return the PDF file content
    return doc.save();
  }

  Widget _buildHeader(Context context) {
    return Column(children: [
      Container(
          height: 70,
          color: PdfColors.grey300,
          child: Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.all(8),
            height: 72,
            child: _logo != null ? SvgImage(svg: _logo!) : null,
          )),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 25,
          alignment: Alignment.centerLeft,
          child: Text(
            'PUNKTZETTEL FÜR EINZELMEISTERSCHAFTEN',
            style: TextStyle(
              color: baseColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ]),
    ]);
  }

  Widget _buildInfoHeader1(Context context) {
    buildCheckBox({bool isChecked = false}) => Container(
        margin: const EdgeInsets.all(4),
        height: 20,
        width: 20,
        foregroundDecoration: BoxDecoration(
          border: Border.all(
            color: PdfColors.grey,
            width: .5,
          ),
        ),
        alignment: Alignment.center,
        child: isChecked ? Text('×', style: const TextStyle(fontSize: 20, color: _pencilColor)) : null);

    buildJudges({required String title, String? no}) {
      const cellHeight = 20.0;
      return TableRow(children: [
        buildTextCell(title, fontSize: 7, height: cellHeight),
        buildFormCell(title: 'Nr.', content: no, height: cellHeight, width: 60),
      ]);
    }

    final isFreeStyle = bout.weightClass.style == WrestlingStyle.free;

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(children: [
            Text(localizations.freeStyle, style: const TextStyle(fontSize: 7)),
            buildCheckBox(isChecked: isFreeStyle),
            buildCheckBox(isChecked: !isFreeStyle),
            Text(localizations.grecoRoman, style: const TextStyle(fontSize: 7)),
          ]),
          Table(children: [
            buildJudges(title: localizations.matChairman.toUpperCase(), no: event.matChairman?.id.toString() ?? ''),
            buildJudges(title: localizations.referee.toUpperCase(), no: event.referee?.id.toString() ?? ''),
            buildJudges(title: 'PUNKTRICHTER', no: event.judge?.id.toString() ?? ''),
          ]),
        ]);
  }

  Widget _buildInfoHeader2(Context context) {
    return Table(
      columnWidths: {
        0: const FlexColumnWidth(2),
        1: const FlexColumnWidth(1),
        2: const FlexColumnWidth(1),
        3: const FlexColumnWidth(1),
        4: const FlexColumnWidth(1),
        5: const FlexColumnWidth(1),
        6: const FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            buildFormCell(
                title: localizations.date,
                content: event.date.toDateStringFromLocaleName(localizations.localeName),
                color: PdfColors.grey300,
                pencilColor: _pencilColor),
            buildFormCell(
                title: '${localizations.weightClass} (${bout.weightClass.unit.toAbbr()})',
                content: bout.weightClass.weight.toString(),
                color: PdfColors.grey300,
                pencilColor: _pencilColor),
            buildFormCell(
                title: localizations.boutNo, // TODO: change to boutNo
                content: bout.id?.toString() ?? '',
                color: PdfColors.grey300,
                pencilColor: _pencilColor),
            buildFormCell(
                title: 'POOL' /*localizations.pool*/,
                content: bout.pool?.toString() ?? '',
                color: PdfColors.grey300,
                pencilColor: _pencilColor),
            buildFormCell(title: 'RUNDE', content: '', color: PdfColors.grey300, pencilColor: _pencilColor),
            buildFormCell(title: 'PLATZ', content: '', color: PdfColors.grey300, pencilColor: _pencilColor),
            buildFormCell(title: 'MATTE', content: '', color: PdfColors.grey300, pencilColor: _pencilColor),
          ],
        ),
      ],
    );
  }

  Widget _buildParticipantsHeader(Context context) {
    Widget buildParticipantNameColumn({String? name, String? club, required PdfColor borderColor}) {
      return Column(children: [
        buildFormCell(
            title: localizations.name, content: name, pencilColor: _pencilColor, height: 40, borderColor: borderColor),
        buildFormCell(
            title: 'NATION / VERBAND / ${localizations.club}',
            content: club,
            pencilColor: _pencilColor,
            height: 40,
            borderColor: borderColor),
      ]);
    }

    Widget buildParticipantColumn({required bool isLeft, Membership? membership, required PdfColor borderColor}) {
      final numberCell = buildFormCell(
          title: 'NR.',
          content: membership?.person.id?.toString() ?? '',
          pencilColor: _pencilColor,
          height: 80,
          borderColor: borderColor);
      final content = [
        buildParticipantNameColumn(
            name: membership?.person.fullName ?? localizations.participantVacant,
            club: membership?.club.name,
            borderColor: borderColor)
      ];
      if (isLeft) {
        content.insert(0, numberCell);
      } else {
        content.add(numberCell);
      }
      return Expanded(
          child: Table(
        columnWidths: {
          0: FlexColumnWidth(isLeft ? 1 : 4),
          1: FlexColumnWidth(isLeft ? 4 : 1),
        },
        children: [
          TableRow(children: [
            Container(
              height: 8,
              color: borderColor,
            ),
            Container(
              height: 8,
              color: borderColor,
            ),
          ]),
          TableRow(
            children: content,
          ),
        ],
      ));
    }

    return Row(children: [
      buildParticipantColumn(isLeft: true, membership: bout.r?.participation.membership, borderColor: _homeColor),
      Container(width: horizontalGap),
      buildParticipantColumn(isLeft: false, membership: bout.b?.participation.membership, borderColor: _guestColor),
    ]);
  }

  Widget _buildPointsBody(Context context, List<BoutAction> actions) {
    const headerCellHeight = 40.0;
    const roundCellHeight = 35.0;
    const breakCellHeight = 15.0;

    final rounds = boutState.boutConfig.periodCount;

    Widget buildColorCell({required String colorStr, required PdfColor borderColor}) => Transform.rotateBox(
        angle: pi * 0.5,
        unconstrained: true,
        child: buildTextCell(
          colorStr,
          height: 40,
          width: headerCellHeight + verticalGap + (rounds * roundCellHeight) + ((rounds - 1) * breakCellHeight),
          borderColor: borderColor,
          textColor: borderColor,
          alignment: Alignment.center,
        ));

    Widget buildTotalCell(PdfColor borderColor) =>
        buildTextCell('TOTAL', height: headerCellHeight, borderColor: borderColor, alignment: Alignment.center);
    Widget buildTechnicalPointsHeaderCell(PdfColor borderColor) => buildTextCell('TECHNISCHE PUNKTE',
        height: headerCellHeight, borderColor: borderColor, alignment: Alignment.center);
    TableRow buildRound({required int round}) {
      final periodDurMin = boutState.boutConfig.periodDuration * round;
      final periodDurMax = periodDurMin + boutState.boutConfig.periodDuration;
      final periodActions = actions.where(
          (element) => element.duration.compareTo(periodDurMax) <= 0 && element.duration.compareTo(periodDurMin) > 0);
      final periodActionsRed = periodActions.where((element) => element.role == BoutRole.red);
      final periodActionsBlue = periodActions.where((element) => element.role == BoutRole.blue);
      return TableRow(children: [
        buildFormCell(
            content: periodActionsRed
                .where((element) => element.actionType == BoutActionType.points)
                .map((e) => e.pointCount ?? 0)
                .fold<int>(0, (cur, next) => (cur + next))
                .toString(),
            borderColor: _homeColor,
            height: roundCellHeight),
        buildFormCell(
            content: periodActionsRed.map((e) => e.toString()).join(', '),
            borderColor: _homeColor,
            height: roundCellHeight),
        buildTextCell('ROUND\n${round + 1}',
            height: roundCellHeight,
            margin: const EdgeInsets.symmetric(horizontal: horizontalGap),
            fontSize: 8,
            alignment: Alignment.center),
        buildFormCell(
            content: periodActionsBlue.map((e) => e.toString()).join(', '),
            borderColor: _guestColor,
            height: roundCellHeight),
        buildFormCell(
            content: periodActionsBlue
                .where((element) => element.actionType == BoutActionType.points)
                .map((e) => e.pointCount ?? 0)
                .fold<int>(0, (cur, next) => (cur + next))
                .toString(),
            borderColor: _guestColor,
            height: roundCellHeight),
      ]);
    }

    Widget buildTechnicalPoints() {
      final List<TableRow> roundRows = [];
      for (int round = 0; round < rounds; round++) {
        roundRows.add(buildRound(round: round));
        if (round < (rounds - 1)) {
          final breakDurationStr =
              '${localizations.breakDurationInSecs}: ${boutState.boutConfig.breakDuration.inSeconds}';
          roundRows.add(TableRow(children: [
            Container(color: _homeColor, height: breakCellHeight),
            buildTextCell(
              breakDurationStr,
              fontSize: 8,
              alignment: Alignment.center,
              borderColor: _homeColor,
              color: _homeColor,
              textColor: PdfColors.white,
              height: breakCellHeight,
            ),
            Container(),
            buildTextCell(
              breakDurationStr,
              fontSize: 8,
              alignment: Alignment.center,
              borderColor: _guestColor,
              color: _guestColor,
              textColor: PdfColors.white,
              height: breakCellHeight,
            ),
            Container(color: _guestColor, height: breakCellHeight),
          ]));
        }
      }

      return Expanded(
          child: Table(
        columnWidths: {
          0: const FlexColumnWidth(1),
          1: const FlexColumnWidth(4),
          2: const FixedColumnWidth(52),
          3: const FlexColumnWidth(4),
          4: const FlexColumnWidth(1),
        },
        children: [
          TableRow(children: [
            buildTotalCell(_homeColor),
            buildTechnicalPointsHeaderCell(_homeColor),
            Container(),
            buildTechnicalPointsHeaderCell(_guestColor),
            buildTotalCell(_guestColor),
          ]),
          TableRow(children: [Container(height: verticalGap)]),
          ...roundRows,
        ],
      ));
    }

    return Row(children: [
      buildColorCell(colorStr: localizations.red.toUpperCase(), borderColor: _homeColor),
      buildTechnicalPoints(),
      buildColorCell(colorStr: localizations.blue.toUpperCase(), borderColor: _guestColor),
    ]);
  }

  Widget _buildFooter(Context context) {
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

  PageTheme _buildTheme(PdfPageFormat pageFormat, Font base, Font bold, Font italic) {
    return PageTheme(
      pageFormat: pageFormat,
      theme: ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
    );
  }
}
