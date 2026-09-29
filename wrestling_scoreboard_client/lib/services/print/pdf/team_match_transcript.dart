import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/components.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/pdf_sheet.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/team_match_pdf_common.dart';
import 'package:wrestling_scoreboard_client/utils/duration.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchTranscript extends PdfSheet {
  TeamMatchTranscript({
    required this.teamMatch,
    required this.teamMatchBoutActions,
    required this.officials,
    required this.homeParticipations,
    required this.guestParticipations,
    required this.homeLineupMemberships,
    required this.guestLineupMemberships,
    required this.boutConfig,
    required this.isTimeCountDown,
    super.baseColor,
    super.accentColor,
    required super.buildContext,
  });

  final Map<TeamMatchBout, List<BoutAction>> teamMatchBoutActions;
  final List<TeamLineupParticipation> homeParticipations;
  final List<TeamLineupParticipation> guestParticipations;
  final List<TeamLineupMembership> homeLineupMemberships;
  final List<TeamLineupMembership> guestLineupMemberships;
  final BoutConfig boutConfig;
  final TeamMatch teamMatch;
  final Map<Person, PersonRole> officials;
  final bool isTimeCountDown;
  late final TeamMatchPdfCommon teamMatchPdfCommon = TeamMatchPdfCommon(localizations);

  Iterable<Bout> get bouts => teamMatchBoutActions.keys.map((tmb) => tmb.bout);

  TeamMatch get event => teamMatch;
  String? _logo;

  @override
  Future<Uint8List> buildPdf({PdfPageFormat? pageFormat}) async {
    final doc = Document();

    _logo = await rootBundle.loadString('assets/images/icons/launcher.svg');
    final winner = TeamMatch.getResultRole(home: teamMatch.home, guest: teamMatch.guest);

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
              const FlexColumnWidth(0.5), // Begin
              const FlexColumnWidth(0.5), // End
              const FlexColumnWidth(4), // Comment
            ].asMap(),
            children: [
              TableRow(
                children: [
                  buildFormCell(
                    title: localizations.winner,
                    content: switch (winner) {
                      MatchResultRole.home => '${teamMatch.home.team.name} (${localizations.home})',
                      MatchResultRole.guest => '${teamMatch.guest.team.name} (${localizations.guest})',
                      MatchResultRole.tie => localizations.tie,
                      _ => '',
                    },
                    pencilSize: 9,
                    height: 30.0,
                    color: PdfColors.grey100,
                  ),
                  buildFormCell(
                    title: localizations.visitors,
                    content: teamMatch.visitorsCount?.toString() ?? '',
                    height: 30.0,
                    color: PdfColors.grey100,
                  ),
                  buildFormCell(
                    title: localizations.startDate,
                    content: teamMatch.date.toTimeStringFromLocaleName(localizations.localeName),
                    color: PdfColors.grey100,
                    height: 30,
                  ),
                  buildFormCell(
                    title: localizations.endDate,
                    content: teamMatch.endDate?.toTimeStringFromLocaleName(localizations.localeName),
                    color: PdfColors.grey100,
                    height: 30,
                  ),
                  buildFormCell(
                    title: localizations.remarks,
                    content: teamMatch.comment ?? '',
                    height: 30.0,
                    color: PdfColors.grey100,
                    pencilSize: 8,
                  ),
                ],
              ),
            ],
          ),
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
      ...buildOfficials(
        order: [PersonRole.referee, PersonRole.matChairman, PersonRole.judge],
        context,
        event,
        groupedOfficials: groupedOfficials,
      ),
      ...buildTeamLeader(context, event),
    ];
    final staff = buildOfficials(
      order: [PersonRole.timeKeeper, PersonRole.transcriptWriter],
      context,
      event,
      groupedOfficials: groupedOfficials,
    );
    final stewards = buildOfficials(
      order: [PersonRole.steward],
      getPlaceHolderCount: (personRole) => 3,
      context,
      event,
      groupedOfficials: groupedOfficials,
    );
    return Table(
      defaultColumnWidth: const FlexColumnWidth(1),
      children: [
        TableRow(
          children: [
            ...signaturePersons.map(
              (p) => Column(
                children: [
                  p,
                  buildFormCell(title: localizations.signature, height: 25.0, color: PdfColors.grey100),
                ],
              ),
            ),
            Column(children: staff),
            Column(children: stewards),
          ].map((child) => Container(padding: const EdgeInsets.symmetric(horizontal: 2), child: child)).toList(),
        ),
      ],
    );
  }

  List<Widget> buildTeamLeader(Context context, TeamMatch teamMatch, {double? width}) {
    return [
      buildPerson(
        title: '${localizations.home} ${localizations.leader.toUpperCase()}',
        no: homeLineupMemberships.firstOfRole(LineupRole.leader)?.membership.person.fullName ?? '',
        width: width,
      ),
      buildPerson(
        title: '${localizations.guest} ${localizations.leader.toUpperCase()}',
        no: guestLineupMemberships.firstOfRole(LineupRole.leader)?.membership.person.fullName ?? '',
        width: width,
      ),
    ];
  }

  Widget _buildBoutTable(Context context) {
    const marginBottom = EdgeInsets.only(bottom: PdfSheet.verticalGap);

    List<TableColumnWidth> participantStateColumnWidths() => [
      const FlexColumnWidth(0.5), // Weight
      const FlexColumnWidth(2.2), // Name
      const FlexColumnWidth(0.6), // No
      const FlexColumnWidth(0.4), // Status
      const FlexColumnWidth(0.3), // Classification points
    ];

    List<Widget> buildTeamFooter(BoutRole role) {
      return [
        Container(color: role.pdfColor, height: cellHeight),
        Container(color: role.pdfColor, height: cellHeight),
        Container(color: role.pdfColor, height: cellHeight),
        Container(color: role.pdfColor, height: cellHeight),
        buildTextCell(
          (role == BoutRole.red ? teamMatch.home : teamMatch.guest).classificationPoints?.toString() ?? '',
          borderColor: role.pdfColor,
          height: cellHeight,
          fontSize: cellFontSize,
          borderWidth: 2.0,
          alignment: Alignment.center,
        ),
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
        buildTextCell(
          localizations.classificationPointsAbbr,
          height: headerCellHeight,
          fontSize: headerFontSize,
          color: color,
          textColor: PdfColors.white,
          margin: marginBottom,
          borderColor: textColor,
        ),
      ];
    }

    List<Widget> buildParticipantState(
      Bout bout,
      BoutRole role,
      WeightClass? weightClass,
      Iterable<TeamLineupParticipation> participations,
    ) {
      final borderColor = role.pdfColor;
      final teamMatchParticipation = TeamLineupParticipation.fromParticipationsAndWeightClass(
        participations: participations,
        weightClass: weightClass,
      );
      final boutState = role == BoutRole.red ? bout.r : bout.b;
      final membership = boutState?.membership;
      assert(teamMatchParticipation?.membership == membership, 'Memberships do not match');
      return [
        buildTextCell(
          teamMatchParticipation?.weight?.toString() ?? '',
          height: cellHeight,
          alignment: Alignment.centerRight,
          borderColor: borderColor,
          fontSize: cellFontSize,
        ),
        buildTextCell(
          membership?.person.fullName ?? (bout.result == null ? '' : localizations.participantVacant),
          height: cellHeight,
          borderColor: borderColor,
          fontSize: cellFontSize,
          fontWeight: bout.winnerRole == role ? FontWeight.bold : null,
        ),
        buildTextCell(
          membership?.no ?? '',
          height: cellHeight,
          borderColor: borderColor,
          fontSize: cellFontSize,
          alignment: Alignment.center,
        ),
        buildTextCell(
          membership?.person.toStatus() ?? '',
          height: cellHeight,
          alignment: Alignment.center,
          borderColor: borderColor,
          fontSize: cellFontSize,
        ),
        buildTextCell(
          boutState?.classificationPoints?.toString() ?? '',
          height: cellHeight,
          alignment: Alignment.center,
          borderColor: borderColor,
          fontSize: cellFontSize,
        ),
      ];
    }

    return Table(
      columnWidths: [
        const FlexColumnWidth(0.3), // No
        const FlexColumnWidth(0.6), // Weightclass
        const FlexColumnWidth(0.3), // Style
        ...participantStateColumnWidths(),
        ...participantStateColumnWidths(),
        const FlexColumnWidth(0.4), // Result
        const FlexColumnWidth(0.5), // Duration
        const FlexColumnWidth(2.0), // Comment
      ].asMap(),
      children: [
        TableRow(
          children: [
            Container(height: titleCellHeight),
            Container(height: titleCellHeight),
            Container(height: titleCellHeight),
            ...teamMatchPdfCommon.buildTeamHeader(teamMatch.home.team, BoutRole.red, columnSpan: 5),
            ...teamMatchPdfCommon.buildTeamHeader(teamMatch.guest.team, BoutRole.blue, columnSpan: 5),
            Container(height: titleCellHeight),
            Container(height: titleCellHeight),
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
            ...buildParticipantStateColumnHeaders(BoutRole.red),
            ...buildParticipantStateColumnHeaders(BoutRole.blue),
            buildTextCell(
              localizations.result,
              height: headerCellHeight,
              fontSize: headerFontSize,
              margin: marginBottom,
            ),
            buildTextCell(
              localizations.duration,
              height: headerCellHeight,
              fontSize: headerFontSize,
              margin: marginBottom,
            ),
            buildTextCell(
              localizations.comment,
              height: headerCellHeight,
              fontSize: headerFontSize,
              margin: marginBottom,
            ),
          ],
        ),
        ...teamMatchBoutActions.entries.map((boutEntry) {
          final bout = boutEntry.key;
          final actions = [...boutEntry.value]..sort((a, b) => a.duration.compareTo(b.duration));
          final PdfColor? winnerColor = bout.bout.winnerRole?.pdfColor;
          final PdfColor? winnerTextColor = bout.bout.winnerRole?.textPdfColor;
          return TableRow(
            children: [
              buildTextCell(
                (bout.pos + 1).toString(),
                height: cellHeight,
                fontSize: cellFontSize,
                alignment: Alignment.center,
              ),
              buildTextCell(
                bout.weightClass?.name ?? '-',
                height: cellHeight,
                fontSize: cellFontSize,
                alignment: Alignment.centerRight,
              ),
              buildTextCell(
                bout.weightClass?.style.abbreviation(buildContext) ?? '-',
                height: cellHeight,
                alignment: Alignment.center,
                fontSize: cellFontSize,
              ),
              ...buildParticipantState(bout.bout, BoutRole.red, bout.weightClass, homeParticipations),
              ...buildParticipantState(bout.bout, BoutRole.blue, bout.weightClass, guestParticipations),
              buildTextCell(
                bout.bout.result?.abbreviation(buildContext) ?? '',
                height: cellHeight,
                alignment: Alignment.center,
                color: winnerColor,
                textColor: winnerTextColor,
                fontSize: cellFontSize,
              ),
              buildTextCell(
                // Do not show a '0:00' time, when bout not finished.
                (bout.bout.duration == Duration.zero && bout.bout.result == null)
                    ? ''
                    : bout.bout.duration
                          .invertIf(isTimeCountDown, max: boutConfig.totalPeriodDuration)
                          .formatMinutesAndSeconds(),
                height: cellHeight,
                alignment: Alignment.center,
                fontSize: cellFontSize,
              ),
              buildTableCellWidget(
                height: cellHeight,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 7),
                    children: [
                      ...actions.map(
                        (action) => TextSpan(
                          text: action == actions.last ? action.actionValue : '${action.actionValue} ',
                          style: TextStyle(color: action.role.pdfColor),
                          // Shift red up and blue down, to differentiate them also without color.
                          baseline: action.role == BoutRole.red ? 1.5 : -1.5,
                        ),
                      ),
                      if (bout.bout.comment?.isNotEmpty ?? false)
                        TextSpan(text: '${actions.isEmpty ? '' : ' | '}${bout.bout.comment}'),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
        TableRow(
          children: [
            TableCell(
              columnSpan: 3,
              child: buildTextCell(localizations.total, height: cellHeight, fontSize: cellFontSize),
            ),
            ...buildTeamFooter(BoutRole.red),
            ...buildTeamFooter(BoutRole.blue),
            Container(height: cellHeight),
            Container(height: cellHeight),
            Container(height: cellHeight),
          ],
        ),
      ],
    );
  }
}
