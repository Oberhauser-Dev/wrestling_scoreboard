import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/components.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/pdf_sheet.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/team_match_pdf_common.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchWeightList extends PdfSheet {
  TeamMatchWeightList({
    required this.teamMatch,
    required this.officials,
    required this.weightClasses,
    required this.participations,
    required this.lineup,
    super.baseColor,
    super.accentColor,
    required super.buildContext,
  }) : lineupRole = teamMatch.home.id == lineup.id ? BoutRole.red : BoutRole.blue;

  final List<WeightClass> weightClasses;
  final List<TeamLineupParticipation> participations;
  final TeamMatch teamMatch;
  final Map<Person, PersonRole> officials;
  final TeamLineup lineup;
  final BoutRole lineupRole;
  late final TeamMatchPdfCommon teamMatchPdfCommon = TeamMatchPdfCommon(localizations);

  TeamMatch get event => teamMatch;
  String? _logo;

  @override
  Future<Uint8List> buildPdf({PdfPageFormat? pageFormat}) async {
    final doc = Document();

    _logo = await rootBundle.loadString('assets/images/icons/launcher.svg');

    // Add page to the PDF
    doc.addPage(
      MultiPage(
        pageTheme: await buildTheme(pageFormat: pageFormat ?? PdfSheet.a4Cross),
        header: _buildHeader,
        footer: buildFooter,
        build:
            (context) => [
              buildInfo(context, event),
              Container(height: PdfSheet.verticalGap),
              _buildBoutTable(context),
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
            localizations.teamMatchWeightList.toUpperCase(),
            style: TextStyle(color: baseColor, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        Container(height: 48, child: _logo != null ? SvgImage(svg: _logo!) : null),
      ],
    );
  }

  Widget _buildPersons(Context context) {
    final groupedOfficials = <PersonRole, Set<Person>>{};
    officials.forEach((person, personRole) {
      groupedOfficials.putIfAbsent(personRole, () => {});
      groupedOfficials[personRole]!.add(person);
    });
    final signaturePersons = [
      ...buildOfficials(order: [PersonRole.referee], context, event, groupedOfficials: groupedOfficials),
      ...buildTeamLeader(context, event),
    ];
    return Table(
      defaultColumnWidth: const FlexColumnWidth(1),
      children: [
        TableRow(
          children:
              [
                ...signaturePersons.map(
                  (p) => Column(
                    children: [
                      p,
                      buildFormCell(title: localizations.signature, height: 25.0, color: PdfColors.grey100),
                    ],
                  ),
                ),
              ].map((child) => Container(padding: const EdgeInsets.symmetric(horizontal: 2), child: child)).toList(),
        ),
      ],
    );
  }

  List<Widget> buildTeamLeader(Context context, TeamMatch teamMatch, {double? width}) {
    return [
      buildPerson(
        title: '${localizations.home} ${localizations.leader.toUpperCase()}',
        no: teamMatch.home.leader?.person.fullName ?? '',
        width: width,
      ),
      buildPerson(
        title: '${localizations.guest} ${localizations.leader.toUpperCase()}',
        no: teamMatch.guest.leader?.person.fullName ?? '',
        width: width,
      ),
    ];
  }

  Widget _buildBoutTable(Context context) {
    const marginBottom = EdgeInsets.only(bottom: PdfSheet.verticalGap);

    List<TableColumnWidth> participantStateColumnWidths() => [
      const FlexColumnWidth(0.8), // Weight
      const FlexColumnWidth(2.2), // Name
      const FlexColumnWidth(1), // No
      const FlexColumnWidth(0.5), // Status
    ];

    List<Widget> buildTeamFooter(BoutRole role) {
      return [
        Container(color: role.pdfColor, height: cellHeight),
        Container(color: role.pdfColor, height: cellHeight),
        Container(color: role.pdfColor, height: cellHeight),
        Container(color: role.pdfColor, height: cellHeight),
      ];
    }

    List<Widget> buildParticipantStateColumnHeaders(BoutRole role) {
      final color = role.pdfColor;
      final textColor = role.textPdfColor;
      return [
        buildTextCell(
          localizations.weight,
          height: headerCellHeight,
          color: color,
          fontSize: headerFontSize,
          textColor: textColor,
          borderColor: textColor,
          margin: marginBottom,
        ),
        buildTextCell(
          localizations.name,
          height: headerCellHeight,
          color: color,
          fontSize: headerFontSize,
          textColor: textColor,
          borderColor: textColor,
          margin: marginBottom,
        ),
        buildTextCell(
          localizations.membershipNumber,
          height: headerCellHeight,
          color: color,
          fontSize: headerFontSize,
          textColor: textColor,
          borderColor: textColor,
          margin: marginBottom,
        ),
        buildTextCell(
          localizations.status,
          height: headerCellHeight,
          color: color,
          fontSize: headerFontSize,
          textColor: textColor,
          borderColor: textColor,
          margin: marginBottom,
        ),
      ];
    }

    List<Widget> buildParticipantState(WeightClass? weightClass, Iterable<TeamLineupParticipation> participations) {
      final teamMatchParticipation = TeamLineupParticipation.fromParticipationsAndWeightClass(
        participations: participations,
        weightClass: weightClass,
      );
      final membership = teamMatchParticipation?.membership;
      return [
        buildTextCell(teamMatchParticipation?.weight?.toString() ?? '', height: cellHeight, fontSize: cellFontSize),
        buildTextCell(membership?.person.fullName ?? '', height: cellHeight, fontSize: cellFontSize),
        buildTextCell(membership?.no ?? '', height: cellHeight, fontSize: cellFontSize),
        buildTextCell(membership?.person.toStatus() ?? '', height: cellHeight, fontSize: cellFontSize),
      ];
    }

    return Table(
      columnWidths:
          [
            const FlexColumnWidth(0.5), // No
            const FlexColumnWidth(0.8), // Weightclass
            const FlexColumnWidth(0.3), // Style
            ...participantStateColumnWidths(),
            const FlexColumnWidth(1.5), // Comment
          ].asMap(),
      children: [
        TableRow(
          children: [
            Container(height: titleCellHeight),
            Container(height: titleCellHeight),
            Container(height: titleCellHeight),
            ...teamMatchPdfCommon.buildTeamHeader(lineup.team, lineupRole, columnSpan: 4),
            Container(height: titleCellHeight),
          ],
        ),
        TableRow(
          children: [
            buildTextCell(
              localizations.boutNo,
              height: headerCellHeight,
              fontSize: headerFontSize,
              margin: marginBottom,
            ),
            buildTextCell(
              localizations.weightClass,
              height: headerCellHeight,
              fontSize: headerFontSize,
              margin: marginBottom,
            ),
            buildTextCell(
              localizations.wrestlingStyle,
              height: headerCellHeight,
              fontSize: headerFontSize,
              margin: marginBottom,
            ),
            ...buildParticipantStateColumnHeaders(lineupRole),
            buildTextCell(
              localizations.comment,
              height: headerCellHeight,
              fontSize: headerFontSize,
              margin: marginBottom,
            ),
          ],
        ),
        ...weightClasses.indexed.map((indexed) {
          final index = indexed.$1;
          final weightClass = indexed.$2;
          return TableRow(
            children: [
              buildTextCell((index + 1).toString(), height: cellHeight, fontSize: cellFontSize),
              buildTextCell(weightClass.name, height: cellHeight, fontSize: cellFontSize),
              buildTextCell(weightClass.style.abbreviation(buildContext), height: cellHeight, fontSize: cellFontSize),
              ...buildParticipantState(weightClass, participations),
              buildTextCell(/* TODO: Allow comment in Lineup */ '', height: cellHeight, fontSize: 6),
            ],
          );
        }),
        TableRow(
          children: [
            TableCell(
              columnSpan: 3,
              child: buildTextCell(
                localizations.total,
                height: cellHeight,
                fontSize: cellFontSize,
                // Gab to replacement
                margin: marginBottom,
              ),
            ),
            ...buildTeamFooter(lineupRole),
            Container(height: cellHeight),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              columnSpan: 4 + 4,
              child: buildTextCell(
                localizations.replacement,
                borderWidth: 0,
                height: cellHeight,
                fontSize: cellFontSize,
              ),
            ),
          ],
        ),
        ...List.generate(
          3,
          (e) => TableRow(children: List.generate(4 + 4, (e) => buildTextCell('', height: cellHeight))),
        ),
      ],
    );
  }
}
