import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/components.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/pdf_sheet.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ScoreSheet extends PdfSheet {
  ScoreSheet({
    required this.bout,
    required this.boutActions,
    required this.wrestlingEvent,
    required this.boutConfig,
    super.baseColor,
    super.accentColor,
    required super.buildContext,
  });

  final Bout bout;
  final List<BoutAction> boutActions;
  final BoutConfig boutConfig;
  final WrestlingEvent wrestlingEvent;

  WrestlingEvent get event => wrestlingEvent;

  String? _logo;

  @override
  Future<Uint8List> buildPdf({PdfPageFormat? pageFormat}) async {
    final doc = Document();

    _logo = await rootBundle.loadString('assets/images/icons/launcher.svg');
    final actions = boutActions;

    // Add page to the PDF
    doc.addPage(
      MultiPage(
        pageTheme: await buildTheme(),
        header: _buildHeader,
        footer: buildFooter,
        build: (context) => [
          Container(height: PdfSheet.verticalGap),
          buildInfo(context, event),
          Container(height: PdfSheet.verticalGap),
          _buildInfoHeader2(context),
          Container(height: PdfSheet.verticalGap),
          _buildParticipantsHeader(context),
          Container(height: PdfSheet.verticalGap),
          _buildPointsBody(context, actions),
          Container(height: PdfSheet.verticalGap),
          Column(
            children: [
              ...buildReferees(context, event, width: 120.0),
              ...buildStaff(context, event, width: 120.0),
            ],
          ),
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
            localizations.scoreSheetSingleCompetitions.toUpperCase(),
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

  Widget _buildInfoHeader2(Context context) {
    final isFreeStyle = bout.weightClass?.style == WrestlingStyle.free;
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
            buildFormCellWidget(
                title: localizations.wrestlingStyle,
                content: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(localizations.freeStyle, style: const TextStyle(fontSize: 7)),
                  buildCheckBox(
                      isChecked: isFreeStyle, pencilColor: PdfSheet.pencilColor, checkBoxColor: PdfColors.white),
                  buildCheckBox(
                      isChecked: !isFreeStyle, pencilColor: PdfSheet.pencilColor, checkBoxColor: PdfColors.white),
                  Text(localizations.grecoRoman, style: const TextStyle(fontSize: 7)),
                ]),
                color: PdfColors.grey300,
                pencilColor: PdfSheet.pencilColor),
            buildFormCell(
                title: '${localizations.weightClass} (${bout.weightClass?.unit.toAbbr()})',
                content: bout.weightClass?.weight.toString(),
                color: PdfColors.grey300,
                pencilColor: PdfSheet.pencilColor),
            buildFormCell(
                title: localizations.boutNo, // TODO: change to boutNo
                content: bout.id?.toString() ?? '',
                color: PdfColors.grey300,
                pencilColor: PdfSheet.pencilColor),
            buildFormCell(
                title: localizations.pool.toUpperCase(),
                content: bout.pool?.toString() ?? '',
                color: PdfColors.grey300,
                pencilColor: PdfSheet.pencilColor),
            buildFormCell(
                title: localizations.round.toUpperCase(),
                content: '',
                color: PdfColors.grey300,
                pencilColor: PdfSheet.pencilColor),
            buildFormCell(
                title: localizations.place.toUpperCase(),
                content: '',
                color: PdfColors.grey300,
                pencilColor: PdfSheet.pencilColor),
            buildFormCell(
                title: localizations.mat.toUpperCase(),
                content: '',
                color: PdfColors.grey300,
                pencilColor: PdfSheet.pencilColor),
          ],
        ),
      ],
    );
  }

  Widget _buildParticipantsHeader(Context context) {
    Widget buildParticipantNameColumn({String? name, String? club, required PdfColor borderColor}) {
      return Column(children: [
        buildFormCell(
            title: localizations.name,
            content: name,
            pencilColor: PdfSheet.pencilColor,
            height: 40,
            borderColor: borderColor),
        buildFormCell(
            title: 'NATION / VERBAND / ${localizations.club}',
            content: club,
            pencilColor: PdfSheet.pencilColor,
            height: 40,
            borderColor: borderColor),
      ]);
    }

    Widget buildParticipantColumn({required bool isLeft, Membership? membership, required PdfColor borderColor}) {
      final numberCell = buildFormCell(
          title: localizations.numberAbbreviation.toUpperCase(),
          content: membership?.person.id?.toString() ?? '',
          pencilColor: PdfSheet.pencilColor,
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
      buildParticipantColumn(
          isLeft: true, membership: bout.r?.participation.membership, borderColor: PdfSheet.homeColor),
      Container(width: PdfSheet.horizontalGap),
      buildParticipantColumn(
          isLeft: false, membership: bout.b?.participation.membership, borderColor: PdfSheet.guestColor),
    ]);
  }

  Widget _buildPointsBody(Context context, List<BoutAction> actions) {
    const headerCellHeight = 40.0;
    const roundCellHeight = 35.0;
    const breakCellHeight = 15.0;

    final rounds = boutConfig.periodCount;

    Widget buildColorCell({required String colorStr, required PdfColor borderColor}) => Transform.rotateBox(
        angle: pi * 0.5,
        unconstrained: true,
        child: buildTextCell(
          colorStr,
          height: 40,
          width:
              headerCellHeight + PdfSheet.verticalGap + (rounds * roundCellHeight) + ((rounds - 1) * breakCellHeight),
          borderColor: borderColor,
          textColor: borderColor,
          alignment: Alignment.center,
        ));

    Widget buildTotalCell(PdfColor borderColor) => buildTextCell(localizations.total.toUpperCase(),
        height: headerCellHeight, borderColor: borderColor, alignment: Alignment.center);
    Widget buildTechnicalPointsHeaderCell(PdfColor borderColor) =>
        buildTextCell(localizations.technicalPoints.toUpperCase(),
            height: headerCellHeight, borderColor: borderColor, alignment: Alignment.center);
    TableRow buildRound({required int round}) {
      final periodDurMin = boutConfig.periodDuration * round;
      final periodDurMax = periodDurMin + boutConfig.periodDuration;
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
            borderColor: PdfSheet.homeColor,
            height: roundCellHeight),
        buildFormCell(
            content: periodActionsRed.map((e) => e.toString()).join(', '),
            borderColor: PdfSheet.homeColor,
            height: roundCellHeight),
        buildTextCell('${localizations.round.toUpperCase()}\n${round + 1}',
            height: roundCellHeight,
            margin: const EdgeInsets.symmetric(horizontal: PdfSheet.horizontalGap),
            fontSize: 8,
            alignment: Alignment.center),
        buildFormCell(
            content: periodActionsBlue.map((e) => e.toString()).join(', '),
            borderColor: PdfSheet.guestColor,
            height: roundCellHeight),
        buildFormCell(
            content: periodActionsBlue
                .where((element) => element.actionType == BoutActionType.points)
                .map((e) => e.pointCount ?? 0)
                .fold<int>(0, (cur, next) => (cur + next))
                .toString(),
            borderColor: PdfSheet.guestColor,
            height: roundCellHeight),
      ]);
    }

    Widget buildTechnicalPoints() {
      final List<TableRow> roundRows = [];
      for (int round = 0; round < rounds; round++) {
        roundRows.add(buildRound(round: round));
        if (round < (rounds - 1)) {
          final breakDurationStr =
              '${localizations.breakDuration}: ${boutConfig.breakDuration.formatMinutesAndSeconds()}';
          roundRows.add(TableRow(children: [
            Container(color: PdfSheet.homeColor, height: breakCellHeight),
            buildTextCell(
              breakDurationStr,
              fontSize: 8,
              alignment: Alignment.center,
              borderColor: PdfSheet.homeColor,
              color: PdfSheet.homeColor,
              textColor: PdfColors.white,
              height: breakCellHeight,
            ),
            Container(),
            buildTextCell(
              breakDurationStr,
              fontSize: 8,
              alignment: Alignment.center,
              borderColor: PdfSheet.guestColor,
              color: PdfSheet.guestColor,
              textColor: PdfColors.white,
              height: breakCellHeight,
            ),
            Container(color: PdfSheet.guestColor, height: breakCellHeight),
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
            buildTotalCell(PdfSheet.homeColor),
            buildTechnicalPointsHeaderCell(PdfSheet.homeColor),
            Container(),
            buildTechnicalPointsHeaderCell(PdfSheet.guestColor),
            buildTotalCell(PdfSheet.guestColor),
          ]),
          TableRow(children: [Container(height: PdfSheet.verticalGap)]),
          ...roundRows,
        ],
      ));
    }

    return Row(children: [
      buildColorCell(colorStr: localizations.red.toUpperCase(), borderColor: PdfSheet.homeColor),
      buildTechnicalPoints(),
      buildColorCell(colorStr: localizations.blue.toUpperCase(), borderColor: PdfSheet.guestColor),
    ]);
  }
}
