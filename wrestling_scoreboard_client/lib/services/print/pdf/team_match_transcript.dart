import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/components.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/pdf_sheet.dart';
import 'package:wrestling_scoreboard_client/utils/duration.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchTranscript extends PdfSheet {
  TeamMatchTranscript({
    required this.teamMatchBoutActions,
    required this.teamMatch,
    required this.boutConfig,
    required this.isTimeCountDown,
    super.baseColor,
    super.accentColor,
    required super.buildContext,
  });

  final Map<TeamMatchBout, List<BoutAction>> teamMatchBoutActions;
  final BoutConfig boutConfig;
  final TeamMatch teamMatch;
  final bool isTimeCountDown;

  Iterable<Bout> get bouts => teamMatchBoutActions.keys.map((tmb) => tmb.bout);

  TeamMatch get event => teamMatch;
  String? _logo;

  @override
  Future<Uint8List> buildPdf({PdfPageFormat? pageFormat}) async {
    final doc = Document();

    _logo = await rootBundle.loadString('assets/images/icons/launcher.svg');
    final homePoints = TeamMatch.getHomePoints(bouts);
    final guestPoints = TeamMatch.getGuestPoints(bouts);
    final winner = homePoints > guestPoints
        ? teamMatch.home.team.name
        : homePoints < guestPoints
            ? teamMatch.guest.team.name
            : '';

    // Add page to the PDF
    doc.addPage(
      MultiPage(
        pageTheme: await buildTheme(pageFormat: pageFormat ?? PdfSheet.a4Cross),
        header: _buildHeader,
        footer: buildFooter,
        build: (context) => [
          buildInfo(context, event),
          Container(height: PdfSheet.verticalGap),
          _buildBoutTable(context),
          Container(height: PdfSheet.verticalGap),
          Table(
              columnWidths: [
                const FlexColumnWidth(1), // Winner
                const FlexColumnWidth(1), // Visitors count
                const FlexColumnWidth(6), // Comment
              ].asMap(),
              children: [
                TableRow(children: [
                  buildFormCell(title: localizations.winner, content: winner, height: 30.0, color: PdfColors.grey100),
                  buildFormCell(
                      title: localizations.visitors,
                      content: teamMatch.visitorsCount?.toString() ?? '',
                      height: 30.0,
                      color: PdfColors.grey100),
                  buildFormCell(
                      title: localizations.comment,
                      content: teamMatch.comment ?? '',
                      height: 30.0,
                      color: PdfColors.grey100)
                ]),
              ]),
          Container(height: PdfSheet.verticalGap),
          _buildPersons(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  Widget _buildHeader(Context context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 25,
          alignment: Alignment.centerLeft,
          child: Text(
            localizations.teamMatchTranscript.toUpperCase(),
            style: TextStyle(
              color: baseColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          height: 48,
          child: _logo != null ? SvgImage(svg: _logo!) : null,
        )
      ],
    );
  }

  Widget _buildPersons(Context context) {
    final signaturePersons = [...buildReferees(context, event), ...buildTeamLeader(context, event)];
    final staff = buildStaff(context, event);
    final stewards = buildStewards(context, event);
    return Table(
      defaultColumnWidth: const FlexColumnWidth(1),
      children: [
        TableRow(
            children: [
          ...signaturePersons.map(
            (p) => Column(
                children: [p, buildFormCell(title: localizations.signature, height: 30.0, color: PdfColors.grey100)]),
          ),
          Column(children: staff),
          Column(children: stewards),
        ].map((child) => Container(padding: const EdgeInsets.symmetric(horizontal: 2), child: child)).toList()),
      ],
    );
  }

  List<Widget> buildTeamLeader(Context context, TeamMatch teamMatch, {double? width}) {
    return [
      buildPerson(
          title: '${localizations.home} ${localizations.leader.toUpperCase()}',
          no: teamMatch.home.leader?.person.fullName ?? '',
          width: width),
      buildPerson(
          title: '${localizations.guest} ${localizations.leader.toUpperCase()}',
          no: teamMatch.guest.leader?.person.fullName ?? '',
          width: width),
    ];
  }

  Widget _buildBoutTable(Context context) {
    const titleCellHeight = 16.0;
    const headerCellHeight = 30.0;
    const cellHeight = 16.0;
    const headerFontSize = 10.0;
    const cellFontSize = 10.0;
    const marginBottom = EdgeInsets.only(bottom: PdfSheet.verticalGap);

    List<TableColumnWidth> participantStateColumnWidths() => [
          const FlexColumnWidth(0.8), // Weight
          const FlexColumnWidth(2.2), // Name
          const FlexColumnWidth(1), // No
          const FlexColumnWidth(0.5), // Status
        ];

    List<Widget> buildTeamHeader(Team team, BoutRole role) {
      final textColor = role.textPdfColor;
      return [
        TableCell(
            columnSpan: 4,
            child: buildTextCell(
              '${role == BoutRole.red ? localizations.home : localizations.guest}: ${team.name}',
              color: role.pdfColor,
              height: titleCellHeight,
              textColor: textColor,
              fontSize: headerFontSize,
              borderColor: role.pdfColor,
              alignment: Alignment.center,
            )),
      ];
    }

    List<Widget> buildTeamFooter(BoutRole role) {
      return [
        Container(color: role.pdfColor, height: titleCellHeight),
        Container(color: role.pdfColor, height: titleCellHeight),
        Container(color: role.pdfColor, height: titleCellHeight),
        Container(color: role.pdfColor, height: titleCellHeight),
      ];
    }

    List<Widget> buildParticipantStateColumnHeaders(BoutRole role) {
      final color = role.pdfColor;
      final textColor = role.textPdfColor;
      return [
        buildTextCell(localizations.weight,
            height: headerCellHeight,
            color: color,
            fontSize: headerFontSize,
            textColor: textColor,
            borderColor: textColor,
            margin: marginBottom),
        buildTextCell(localizations.name,
            height: headerCellHeight,
            color: color,
            fontSize: headerFontSize,
            textColor: textColor,
            borderColor: textColor,
            margin: marginBottom),
        buildTextCell(localizations.membershipNumber,
            height: headerCellHeight,
            color: color,
            fontSize: headerFontSize,
            textColor: textColor,
            borderColor: textColor,
            margin: marginBottom),
        buildTextCell(localizations.status,
            height: headerCellHeight,
            color: color,
            fontSize: headerFontSize,
            textColor: textColor,
            borderColor: textColor,
            margin: marginBottom),
      ];
    }

    List<Widget> buildParticipantState(AthleteBoutState? state, BoutRole role) {
      final borderColor = role.pdfColor;
      return [
        buildTextCell(state?.participation.weight?.toString() ?? '',
            height: cellHeight, borderColor: borderColor, fontSize: cellFontSize),
        buildTextCell(state?.participation.membership.person.fullName ?? '-',
            height: cellHeight, borderColor: borderColor, fontSize: cellFontSize),
        buildTextCell(state?.participation.membership.no ?? '',
            height: cellHeight, borderColor: borderColor, fontSize: cellFontSize),
        buildTextCell(state?.participation.membership.person.toStatus() ?? '',
            height: cellHeight, borderColor: borderColor, fontSize: cellFontSize),
      ];
    }

    return Table(
      columnWidths: [
        const FlexColumnWidth(0.5), // No
        const FlexColumnWidth(0.8), // Weightclass
        const FlexColumnWidth(0.3), // Style
        ...participantStateColumnWidths(),
        const FlexColumnWidth(0.5), // Technical points red
        const FlexColumnWidth(0.5), // Classification points red
        const FlexColumnWidth(0.7), // Result
        const FlexColumnWidth(0.7), // Duration
        const FlexColumnWidth(0.5), // Classification points blue
        const FlexColumnWidth(0.5), // Technical points blue
        ...participantStateColumnWidths(),
        const FlexColumnWidth(1.5), // Comment
      ].asMap(),
      children: [
        TableRow(children: [
          Container(height: titleCellHeight),
          Container(height: titleCellHeight),
          Container(height: titleCellHeight),
          ...buildTeamHeader(teamMatch.home.team, BoutRole.red),
          Container(color: BoutRole.red.pdfColor, height: titleCellHeight),
          Container(color: BoutRole.red.pdfColor, height: titleCellHeight),
          Container(height: titleCellHeight),
          Container(height: titleCellHeight),
          Container(color: BoutRole.blue.pdfColor, height: titleCellHeight),
          Container(color: BoutRole.blue.pdfColor, height: titleCellHeight),
          ...buildTeamHeader(teamMatch.guest.team, BoutRole.blue),
          Container(height: titleCellHeight),
        ]),
        TableRow(
          children: [
            buildTextCell(localizations.boutNo,
                height: headerCellHeight, fontSize: headerFontSize, margin: marginBottom),
            buildTextCell(localizations.weightClass,
                height: headerCellHeight, fontSize: headerFontSize, margin: marginBottom),
            buildTextCell(localizations.wrestlingStyle,
                height: headerCellHeight, fontSize: headerFontSize, margin: marginBottom),
            ...buildParticipantStateColumnHeaders(BoutRole.red),
            buildTextCell(localizations.technicalPoints,
                height: headerCellHeight,
                fontSize: headerFontSize,
                color: PdfSheet.homeColor,
                textColor: PdfColors.white,
                margin: marginBottom,
                borderColor: BoutRole.red.textPdfColor),
            buildTextCell(localizations.classificationPoints,
                height: headerCellHeight,
                fontSize: headerFontSize,
                color: PdfSheet.homeColor,
                textColor: PdfColors.white,
                margin: marginBottom,
                borderColor: BoutRole.red.textPdfColor),
            buildTextCell(localizations.result,
                height: headerCellHeight, fontSize: headerFontSize, margin: marginBottom),
            buildTextCell(localizations.duration,
                height: headerCellHeight, fontSize: headerFontSize, margin: marginBottom),
            buildTextCell(localizations.classificationPoints,
                height: headerCellHeight,
                fontSize: headerFontSize,
                color: PdfSheet.guestColor,
                textColor: PdfColors.white,
                margin: marginBottom,
                borderColor: BoutRole.blue.textPdfColor),
            buildTextCell(localizations.technicalPoints,
                height: headerCellHeight,
                fontSize: headerFontSize,
                color: PdfSheet.guestColor,
                textColor: PdfColors.white,
                margin: marginBottom,
                borderColor: BoutRole.blue.textPdfColor),
            ...buildParticipantStateColumnHeaders(BoutRole.blue),
            buildTextCell(localizations.comment,
                height: headerCellHeight, fontSize: headerFontSize, margin: marginBottom),
          ],
        ),
        ...teamMatchBoutActions.entries.map((boutEntry) {
          final bout = boutEntry.key;
          final actions = boutEntry.value;
          PdfColor? winnerColor = bout.bout.winnerRole?.pdfColor;
          PdfColor? winnerTextColor = bout.bout.winnerRole?.textPdfColor;
          return TableRow(children: [
            buildTextCell(bout.pos.toString(), height: cellHeight, fontSize: cellFontSize),
            buildTextCell(bout.bout.weightClass?.name ?? '-', height: cellHeight, fontSize: cellFontSize),
            buildTextCell(bout.bout.weightClass?.style.abbreviation(buildContext) ?? '-',
                height: cellHeight, fontSize: cellFontSize),
            ...buildParticipantState(bout.bout.r, BoutRole.red),
            buildTextCell(AthleteBoutState.getTechnicalPoints(actions, BoutRole.red).toString(),
                height: cellHeight, borderColor: BoutRole.red.pdfColor, fontSize: cellFontSize),
            buildTextCell(bout.bout.r?.classificationPoints?.toString() ?? '',
                height: cellHeight, borderColor: BoutRole.red.pdfColor, fontSize: cellFontSize),
            buildTextCell(bout.bout.result?.abbreviation(buildContext) ?? '',
                height: cellHeight,
                alignment: Alignment.center,
                color: winnerColor,
                textColor: winnerTextColor,
                fontSize: cellFontSize),
            buildTextCell(
                bout.bout.duration
                    .invertIf(isTimeCountDown, max: boutConfig.totalPeriodDuration)
                    .formatMinutesAndSeconds(),
                height: cellHeight,
                alignment: Alignment.center,
                fontSize: cellFontSize),
            buildTextCell(bout.bout.b?.classificationPoints?.toString() ?? '',
                height: cellHeight, borderColor: BoutRole.blue.pdfColor, fontSize: cellFontSize),
            buildTextCell(AthleteBoutState.getTechnicalPoints(actions, BoutRole.blue).toString(),
                height: cellHeight, borderColor: BoutRole.blue.pdfColor, fontSize: cellFontSize),
            ...buildParticipantState(bout.bout.b, BoutRole.blue),
            // TODO: bout comment
            buildTextCell('', height: cellHeight, fontSize: cellFontSize),
          ]);
        }),
        TableRow(children: [
          TableCell(
            columnSpan: 3,
            child: buildTextCell(localizations.total, height: titleCellHeight, fontSize: headerFontSize),
          ),
          ...buildTeamFooter(BoutRole.red),
          Container(color: BoutRole.red.pdfColor, height: titleCellHeight),
          buildTextCell(TeamMatch.getHomePoints(bouts).toString(),
              borderColor: BoutRole.red.pdfColor, height: titleCellHeight, fontSize: headerFontSize, borderWidth: 2.0),
          Container(height: titleCellHeight),
          Container(height: titleCellHeight),
          buildTextCell(TeamMatch.getGuestPoints(bouts).toString(),
              borderColor: BoutRole.blue.pdfColor, height: titleCellHeight, fontSize: headerFontSize, borderWidth: 2.0),
          Container(color: BoutRole.blue.pdfColor, height: titleCellHeight),
          ...buildTeamFooter(BoutRole.blue),
          Container(height: titleCellHeight),
        ]),
      ],
    );
  }
}
