import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/components.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/pdf_sheet.dart';
import 'package:wrestling_scoreboard_client/utils/duration.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ScoreSheet extends PdfSheet {
  ScoreSheet({
    required this.bout,
    required this.boutActions,
    required this.wrestlingEvent,
    required this.boutConfig,
    required this.boutRules,
    required this.weightClass,
    required this.isTimeCountDown,
    super.baseColor,
    super.accentColor,
    required super.buildContext,
  });

  final Bout bout;
  final WeightClass? weightClass;
  final List<BoutAction> boutActions;
  final BoutConfig boutConfig;
  final List<BoutResultRule> boutRules;
  final WrestlingEvent wrestlingEvent;
  final bool isTimeCountDown;

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
          Row(mainAxisSize: MainAxisSize.max, children: [
            Expanded(
                child:
                    buildFormCell(title: localizations.winner, content: bout.winnerRole?.localize(buildContext) ?? '')),
            buildFormCell(
                title: localizations.duration,
                content: bout.duration
                    .invertIf(isTimeCountDown, max: boutConfig.totalPeriodDuration)
                    .formatMinutesAndSeconds(),
                width: 100),
          ]),
          Container(height: PdfSheet.verticalGap),
          _buildClassificationPointsTable(context),
          Container(height: PdfSheet.verticalGap),
          // Alternatively create a table with row which are spread equally.
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...buildReferees(context, event),
                ...buildStaff(context, event),
              ]
                  .map(
                    (e) => Expanded(child: e),
                  )
                  .toList(),
              mainAxisSize: MainAxisSize.max),
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
            (wrestlingEvent is TeamMatch
                    ? localizations.teamMatchScoreSheet
                    : localizations.singleCompetitionScoreSheet)
                .toUpperCase(),
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
    final isFreeStyle = weightClass?.style == WrestlingStyle.free;
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
                title: '${localizations.weightClass} (${weightClass?.unit.toAbbr()})',
                content: weightClass?.weight.toString(),
                color: PdfColors.grey300,
                pencilColor: PdfSheet.pencilColor),
            buildFormCell(
                title: localizations.boutNo,
                content: bout.id?.toString() ?? '',
                color: PdfColors.grey300,
                pencilColor: PdfSheet.pencilColor),
            // buildFormCell(
            //     title: localizations.pool.toUpperCase(),
            //     content: bout.pool?.toString() ?? '',
            //     color: PdfColors.grey300,
            //     pencilColor: PdfSheet.pencilColor),
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
      buildParticipantColumn(isLeft: true, membership: bout.r?.membership, borderColor: PdfSheet.homeColor),
      Container(width: PdfSheet.horizontalGap),
      buildParticipantColumn(isLeft: false, membership: bout.b?.membership, borderColor: PdfSheet.guestColor),
    ]);
  }

  Widget _buildClassificationPointsTable(Context context) {
    BoutResultRule? resultRule;
    if (bout.winnerRole != null && bout.result != null) {
      resultRule = BoutConfig.resultRule(
        result: bout.result!,
        style: weightClass?.style ?? WrestlingStyle.free,
        technicalPointsWinner: AthleteBoutState.getTechnicalPoints(boutActions, bout.winnerRole!),
        technicalPointsLoser: AthleteBoutState.getTechnicalPoints(
            boutActions, bout.winnerRole == BoutRole.red ? BoutRole.blue : BoutRole.red),
        rules: boutRules,
      );
    }

    const numColumns = 2;
    final boutResultRuleGroupsList = boutRules.groupListsBy((element) {
      return (element.boutResult, element.winnerClassificationPoints, element.loserClassificationPoints);
    }).entries;

    return Row(
      children: boutResultRuleGroupsList
          .slices((boutResultRuleGroupsList.length / numColumns).ceil())
          .map<Widget>((boutResultRuleGroupSection) => Expanded(
              child: _buildClassificationPointsTableSection(
                  context, Map.fromEntries(boutResultRuleGroupSection), resultRule)))
          .intersperse(
            Container(width: PdfSheet.horizontalGap),
          )
          .toList(),
    );
  }

  Widget _buildClassificationPointsTableSection(Context context,
      Map<(BoutResult, int, int), List<BoutResultRule>> boutResultRuleGroups, BoutResultRule? resultRule) {
    const cellHeight = 20.0;
    return Table(
        columnWidths: {
          0: const FixedColumnWidth(35),
          1: const FixedColumnWidth(30),
          2: const FlexColumnWidth(1),
        },
        children: boutResultRuleGroups.entries.map((entry) {
          final (res, winnerClassificationPoints, loserClassificationPoints) = entry.key;
          final rules = entry.value;
          var description = res.description(buildContext);
          final isResultRuleApplied = rules.contains(resultRule);
          for (final rule in rules) {
            if (rule.style != null ||
                rule.winnerTechnicalPoints != null ||
                rule.loserTechnicalPoints != null ||
                rule.technicalPointsDifference != null) {
              description += ' ';
              if (rule.style != null) {
                description += '${rule.style!.localize(buildContext).toUpperCase()}';
              }
              if (rule.winnerTechnicalPoints != null) {
                description += '• Winner has ${rule.winnerTechnicalPoints} technical point(s)';
              }
              if (rule.loserTechnicalPoints != null) {
                description += '• Loser has ${rule.loserTechnicalPoints} technical point(s)';
              }
              if (rule.technicalPointsDifference != null) {
                description += '• A difference of at least ${rule.technicalPointsDifference} point(s)';
              }
              description += '\n';
            }
          }

          return TableRow(children: [
            buildTextCell(
              res.abbreviation(buildContext),
              width: 40,
              height: cellHeight,
              alignment: Alignment.center,
              borderColor: isResultRuleApplied ? PdfSheet.pencilColor : null,
              borderWidth: isResultRuleApplied ? 2 : null,
            ),
            buildTextCell(
              '$winnerClassificationPoints:$loserClassificationPoints',
              width: 40,
              height: cellHeight,
              alignment: Alignment.center,
              borderColor: isResultRuleApplied ? PdfSheet.pencilColor : null,
              borderWidth: isResultRuleApplied ? 2 : null,
            ),
            buildTextCell(description, fontSize: 7, height: cellHeight),
          ]);
        }).toList());
  }

  Widget _buildPointsBody(Context context, List<BoutAction> actions) {
    const headerCellHeight = 40.0;
    const roundCellHeight = 35.0;
    const breakCellHeight = 15.0;
    const athleteWidth = 30.0;

    final rounds = boutConfig.periodCount;

    Widget buildColorCell({required String colorStr, required PdfColor borderColor}) {
      return Transform.rotateBox(
          angle: pi * 0.5,
          unconstrained: true,
          child: buildTextCell(
            colorStr,
            height: athleteWidth,
            width: headerCellHeight + PdfSheet.verticalGap + rounds * roundCellHeight + (rounds - 1) * breakCellHeight,
            borderColor: borderColor,
            textColor: borderColor,
            alignment: Alignment.center,
          ));
    }

    Widget buildTotalCell(PdfColor borderColor) => buildTextCell(localizations.total.toUpperCase(),
        height: headerCellHeight, borderColor: borderColor, alignment: Alignment.center);
    Widget buildTechnicalPointsHeaderCell(PdfColor borderColor) =>
        buildTextCell(localizations.technicalPoints.toUpperCase(),
            height: headerCellHeight, borderColor: borderColor, alignment: Alignment.center);

    TableRow buildRound({required int round}) {
      final periodDurMin = boutConfig.periodDuration * round;
      var periodDurMax = periodDurMin + boutConfig.periodDuration;
      if (round == rounds - 1) {
        // Also consider points after the regular time.
        periodDurMax += const Duration(seconds: 1);
      }
      final periodActions = actions.where(
          (element) => element.duration.compareTo(periodDurMax) < 0 && element.duration.compareTo(periodDurMin) >= 0);

      Widget buildPeriodTechnicalPoints(Iterable<BoutAction> actions, BoutRole role) {
        actions = actions.where((e) => e.role == role);
        return buildFormCellWidget(
            content: RichText(
                text: TextSpan(
                    style: const TextStyle(color: PdfSheet.pencilColor),
                    children: actions
                        .map(
                          (e) => TextSpan(
                              text: actions.last == e ? e.actionValue : '${e.actionValue}, ',
                              style: periodActions.lastWhereOrNull((e) => e.actionType == BoutActionType.points) == e
                                  ? const TextStyle(decoration: TextDecoration.underline)
                                  : null),
                        )
                        .toList())),
            borderColor: role.pdfColor,
            height: roundCellHeight,
            contentAlignment: Alignment.centerLeft);
      }

      return TableRow(children: [
        buildFormCell(
            content: AthleteBoutState.getTechnicalPoints(periodActions, BoutRole.red).toString(),
            borderColor: PdfSheet.homeColor,
            height: roundCellHeight),
        buildPeriodTechnicalPoints(periodActions, BoutRole.red),
        buildTextCell('${localizations.round.toUpperCase()}\n${round + 1}',
            height: roundCellHeight,
            margin: const EdgeInsets.symmetric(horizontal: PdfSheet.horizontalGap),
            fontSize: 8,
            alignment: Alignment.center),
        buildPeriodTechnicalPoints(periodActions, BoutRole.blue),
        buildFormCell(
            content: AthleteBoutState.getTechnicalPoints(periodActions, BoutRole.blue).toString(),
            borderColor: PdfSheet.guestColor,
            height: roundCellHeight),
      ]);
    }

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
    Widget buildClassificationPoints(int? points, PdfColor color) {
      return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(localizations.classificationPoints.toUpperCase(), style: const TextStyle(fontSize: 8)),
        Container(
          width: roundCellHeight * 2,
          height: roundCellHeight * 2,
          foregroundDecoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 2,
            ),
          ),
          child: Center(
              child: Text(points?.toString() ?? '', style: const TextStyle(color: PdfSheet.pencilColor, fontSize: 20))),
        ),
      ]);
    }

    return Table(
      columnWidths: {
        0: const FixedColumnWidth(athleteWidth),
        1: const FlexColumnWidth(1),
        2: const FlexColumnWidth(4),
        3: const FixedColumnWidth(52),
        4: const FlexColumnWidth(4),
        5: const FlexColumnWidth(1),
        6: const FixedColumnWidth(athleteWidth),
      },
      children: [
        TableRow(
          children: [
            TableCell(
              rowSpan: 2 * rounds + 1,
              child: buildColorCell(
                colorStr: localizations.red.toUpperCase(),
                borderColor: PdfSheet.homeColor,
              ),
            ),
            buildTotalCell(PdfSheet.homeColor),
            buildTechnicalPointsHeaderCell(PdfSheet.homeColor),
            Container(),
            buildTechnicalPointsHeaderCell(PdfSheet.guestColor),
            buildTotalCell(PdfSheet.guestColor),
            TableCell(
              rowSpan: 2 * rounds + 1,
              child: buildColorCell(
                colorStr: localizations.blue.toUpperCase(),
                borderColor: PdfSheet.guestColor,
              ),
            ),
          ],
          verticalAlignment: TableCellVerticalAlignment.full,
        ),
        TableRow(children: [Container(height: PdfSheet.verticalGap)]),
        ...roundRows,
        TableRow(children: [Container(height: PdfSheet.verticalGap)]),
        TableRow(
          children: [
            Container(),
            buildTextCell(AthleteBoutState.getTechnicalPoints(actions, BoutRole.red).toString(),
                height: headerCellHeight,
                borderWidth: 2,
                borderColor: PdfSheet.homeColor,
                alignment: Alignment.center,
                textColor: PdfSheet.pencilColor),
            buildClassificationPoints(bout.r?.classificationPoints, PdfSheet.homeColor),
            Container(),
            buildClassificationPoints(bout.b?.classificationPoints, PdfSheet.guestColor),
            buildTextCell(AthleteBoutState.getTechnicalPoints(actions, BoutRole.blue).toString(),
                height: headerCellHeight,
                borderWidth: 2,
                borderColor: PdfSheet.guestColor,
                alignment: Alignment.center,
                textColor: PdfSheet.pencilColor),
            Container(),
          ],
          verticalAlignment: TableCellVerticalAlignment.full,
        ),
      ],
    );
  }
}
