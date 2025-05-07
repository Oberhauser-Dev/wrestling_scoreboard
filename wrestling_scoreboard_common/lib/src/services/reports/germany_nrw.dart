import 'dart:convert';

import 'package:country/country.dart';

import '../../../common.dart';

extension StatusParser on Person {
  String toStatus() {
    var status = '';

    if ((age ?? 18) < 18) status += 'J';
    if (nationality != null && nationality != Countries.deu) {
      if (nationality!.euMember) {
        status += 'EU';
      } else {
        status += 'N';
      }
    }
    return status;
  }
}

extension GerBoutResultAbbreviation on BoutResult {
  get toGerman {
    switch (this) {
      case BoutResult.vfa:
        return 'SS';
      case BoutResult.vin:
        return 'AS';
      case BoutResult.vca:
        return 'DV';
      case BoutResult.vsu:
        return 'TÜ';
      case BoutResult.vpo:
        return 'PS';
      case BoutResult.vfo:
        return 'KL'; // Also known as 'DN' or 'ÜG'
      case BoutResult.dsq:
        return 'DQ';
      case BoutResult.bothVfo:
      case BoutResult.bothVin:
        return 'o.W.';
      case BoutResult.bothDsq:
        return 'DQ2';
    }
  }
}

/// See: https://www.brv-ringen.de/index.php?option=com_wbw&view=wbw&Itemid=516&tk=dw&dwbid=1&dwcid=15&op=da&opa=0&dwnid=18&opv=lql
/// TODO: https://github.com/Oberhauser-Dev/wrestling_scoreboard/issues/1
class NrwGermanyWrestlingReporter extends WrestlingReporter {
  static const HtmlEscape _htmlEscape = HtmlEscape(HtmlEscapeMode(escapeLtGt: true));

  @override
  final Organization organization;

  NrwGermanyWrestlingReporter(this.organization);

  String _handleComment(String comment) {
    String escapedComment = _htmlEscape
        .convert(_sanitizeString(comment))
        .replaceAll('(', '&#40;')
        .replaceAll(')', '&#41;');

    // Allow more than 200 characters for now.
    /*if (escapedComment.length >= 200) {
      /// Comments must be HTML escaped and must be no longer than 200 characters due to specification.
      while (escapedComment.length >= 197) {
        // Remove one char by one, until the escaped comment fits the field
        comment = comment.substring(0, comment.length - 1);
        escapedComment =
            _htmlEscape.convert(_sanitizeString(comment)).replaceAll('(', '&#40;').replaceAll(')', '&#41;');
      }
      escapedComment += '...';
    }*/
    return escapedComment;
  }

  /// Remove all semicolons to not mess with the format.
  String _sanitizeString(String str) {
    return str.replaceAll(';', ',');
  }

  @override
  String exportTeamMatchReport(TeamMatch teamMatch, Map<TeamMatchBout, List<BoutAction>> boutMap) {
    final bouts = boutMap.keys;
    final teamMatchInfos = <Object>[
      'rdbi',
      '2.0.0',
      'MK',
      teamMatch.no ?? '', // 3:competitionId
      _sanitizeString(teamMatch.league?.fullname ?? ''), // 4:Tabelle
      '${teamMatch.date.day}.${teamMatch.date.month}.${teamMatch.date.year}', // 5:Datum
      _sanitizeString(teamMatch.home.team.name), // 6:Heim
      _sanitizeString(teamMatch.guest.team.name), // 7:Gast
      TeamMatch.getHomePoints(bouts),
      TeamMatch.getGuestPoints(bouts),
      teamMatch.visitorsCount ?? '',
      _sanitizeString(teamMatch.referee?.surname ?? ''),
      _sanitizeString(teamMatch.referee?.prename ?? ''),
      _handleComment(teamMatch.comment ?? ''),
    ].join(';');
    final boutInfos = boutMap.entries.map((entry) {
      final teamMatchBout = entry.key;
      final bout = teamMatchBout.bout;
      var points = entry.value
          .asMap()
          .entries
          .map((boutActionEntry) {
            final boutActionIndex = boutActionEntry.key;
            final action = boutActionEntry.value;
            String actionValue = action.actionValue;
            if (teamMatchBout.weightClass?.style == WrestlingStyle.free) {
              // In germany: 'P' is handled as 'A' activity period, whereas a verbal admonition 'V' before a passivity ('P' / 'A' in Germany) is written as first 'P'.
              if (action.actionType == BoutActionType.passivity) {
                actionValue = 'A';
              } else if (action.actionType == BoutActionType.caution &&
                  entry.value.length > (boutActionIndex + 1) &&
                  entry.value[boutActionIndex + 1].actionType == BoutActionType.passivity) {
                actionValue = 'P';
              }
            }
            return '$actionValue${action.role == BoutRole.red ? 'R' : 'B'}${action.duration.inSeconds}';
          })
          .join(',');
      if (points.isNotEmpty) {
        points = '(points $points)';
      }
      // TODO: One comment is allowed per bout, according to the specs.
      var comment = ''; // bout.comment ?? ''
      if (comment.isNotEmpty) {
        comment = '(comment ${_handleComment(comment)})';
      }
      var duration = '';
      if (bout.duration != Duration.zero) {
        duration = '(duration ${bout.duration.inSeconds})';
      }
      return <Object>[
        teamMatchBout.weightClass?.weight ?? '', // 0:weightClass
        teamMatchBout.weightClass?.style == WrestlingStyle.greco ? 'GR' : 'LL', // 1:stil
        bout.r?.membership.no ?? '', // 2:HeimLiz
        _sanitizeString(bout.r?.membership.person.surname ?? ''),
        _sanitizeString(bout.r?.membership.person.prename ?? ''),
        bout.r?.membership.person.toStatus() ?? '',
        bout.b?.membership.no ?? '', // 6:GastLiz
        _sanitizeString(bout.b?.membership.person.surname ?? ''),
        _sanitizeString(bout.b?.membership.person.prename ?? ''),
        bout.b?.membership.person.toStatus() ?? '',
        bout.r?.classificationPoints ?? 0, // 10:HeimPunkte
        bout.b?.classificationPoints ?? 0, // 11:GastPunkte
        bout.result?.toGerman ?? '', // 12:Ergebnis
        '${AthleteBoutState.getTechnicalPoints(entry.value, BoutRole.red)}:${AthleteBoutState.getTechnicalPoints(entry.value, BoutRole.blue)}$points$comment$duration',
      ].join(';');
    });
    return [teamMatchInfos, ...boutInfos].join('\n');
  }

  @override
  String exportCompetitionReport(Competition competition, Map<CompetitionBout, List<BoutAction>> boutMap) {
    // TODO: implement reportCompetition
    // https://de.wikipedia.org/wiki/ISO_8859
    throw UnimplementedError();
  }

  @override
  (Competition, Map<CompetitionBout, List<BoutAction>>) importCompetitionReport(String report) {
    // TODO: implement importCompetitionReport
    throw UnimplementedError();
  }

  @override
  (TeamMatch, Map<TeamMatchBout, List<BoutAction>>) importTeamMatchReport(String report) {
    // TODO: implement importTeamMatchReport
    throw UnimplementedError();
  }
}
