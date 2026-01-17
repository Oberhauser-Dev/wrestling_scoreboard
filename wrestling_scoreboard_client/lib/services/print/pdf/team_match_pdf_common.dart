import 'package:pdf/widgets.dart';
import 'package:wrestling_scoreboard_client/l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/components.dart';
import 'package:wrestling_scoreboard_common/common.dart';

const titleCellHeight = 20.0;
const headerCellHeight = 24.0;
const cellHeight = 16.0;
const titleFontSize = 10.0;
const headerFontSize = 8.0;
const cellFontSize = 10.0;

class TeamMatchPdfCommon {
  final AppLocalizations localizations;

  TeamMatchPdfCommon(this.localizations);

  List<Widget> buildTeamHeader(Team team, BoutRole role, {required int columnSpan}) {
    final style = TextStyle(fontSize: titleFontSize, color: role.pdfColor);
    return [
      TableCell(
        columnSpan: columnSpan,
        child: buildTableCellWidget(
          height: titleCellHeight,
          borderColor: role.pdfColor,
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(
                '${role == BoutRole.red ? localizations.home : localizations.guest}:',
                style: style.copyWith(fontWeight: FontWeight.bold),
              ),
              Expanded(child: Center(child: Text(team.name, style: style))),
            ],
          ),
        ),
      ),
    ];
  }
}
