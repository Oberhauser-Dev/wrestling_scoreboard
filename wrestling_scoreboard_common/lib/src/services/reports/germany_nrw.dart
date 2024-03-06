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
      case BoutResult.vsu1:
        return 'TÜ1';
      case BoutResult.vpo:
        return 'PS';
      case BoutResult.vpo1:
        return 'PS1';
      case BoutResult.vfo:
        return 'DN';
      case BoutResult.dsq:
        return 'DQ';
      case BoutResult.dsq2:
        return 'DQ2';
    }
  }
}

/// See: https://www.brv-ringen.de/index.php?option=com_wbw&view=wbw&Itemid=516&tk=dw&dwbid=1&dwcid=15&op=da&opa=0&dwnid=18&opv=lql
/// TODO: https://github.com/Oberhauser-Dev/wrestling_scoreboard/issues/1
class NrwGermanyWrestlingReporter extends WrestlingReporter {
  static const HtmlEscape _htmlEscape = HtmlEscape(HtmlEscapeMode(escapeLtGt: true));

  /// Comments must be HTML escaped and must be longer than 200 characters.
  String _handleComment(String comment) {
    bool isSubstring = false;
    String escapedComment = _htmlEscape.convert(comment);
    while (escapedComment.length >= 197) {
      isSubstring = true;
      comment = comment.substring(0, comment.length - 1);
      escapedComment = _htmlEscape.convert(_sanitizeString(comment)).replaceAll('(', '&#40;').replaceAll(')', '&#41;');
    }
    if (isSubstring) {
      escapedComment += '...';
    }
    return escapedComment;
  }

  /// Remove all semicolons to not mess with the format.
  String _sanitizeString(String str) {
    return str.replaceAll(';', ' ');
  }

  @override
  String exportTeamMatchReport(TeamMatch teamMatch, Map<Bout, List<BoutAction>> boutMap) {
    final bouts = boutMap.keys;
    final teamMatchInfos = <Object>[
      'rdbi',
      '2.0.0',
      'MK',
      teamMatch.no ?? '', // 3:competitionId
      _sanitizeString(teamMatch.league?.name ?? ''), // 4:Tabelle
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
      final bout = entry.key;
      var points = entry.value.map((BoutAction action) {
        return '${action.actionValue}${action.role == BoutRole.red ? 'R' : 'B'}${action.duration.inSeconds}';
      }).join(',');
      if (points.isNotEmpty) {
        points = '(points $points)';
      }
      // TODO: One comment is allowed per bout, according to the specs.
      var comment = ''; // bout.comment ?? ''
      if (comment.isNotEmpty) {
        comment = '(comment ${_handleComment(comment)})';
      }
      return <Object>[
        bout.weightClass?.weight ?? '', // 0:weightClass
        bout.weightClass?.style == WrestlingStyle.greco ? 'GR' : 'LL', // 1:stil
        bout.r?.participation.membership.no ?? '', // 2:HeimLiz
        _sanitizeString(bout.r?.participation.membership.person.surname ?? ''),
        _sanitizeString(bout.r?.participation.membership.person.prename ?? ''),
        bout.r?.participation.membership.person.toStatus() ?? '',
        bout.b?.participation.membership.no ?? '', // 6:GastLiz
        _sanitizeString(bout.b?.participation.membership.person.surname ?? ''),
        _sanitizeString(bout.b?.participation.membership.person.prename ?? ''),
        bout.b?.participation.membership.person.toStatus() ?? '',
        bout.r?.classificationPoints ?? 0, // 10:HeimPunkte
        bout.b?.classificationPoints ?? 0, // 11:GastPunkte
        bout.result?.toGerman ?? '', // 12:Ergebnis
        '${ParticipantState.getTechnicalPoints(entry.value, BoutRole.red)}:${ParticipantState.getTechnicalPoints(entry.value, BoutRole.blue)}$points$comment',
      ].join(';');
    });
    return [teamMatchInfos, ...boutInfos].join('\n');
  }

  @override
  String exportCompetitionReport(Competition competition, Map<Bout, List<BoutAction>> boutMap) {
    // TODO: implement reportCompetition
    // https://de.wikipedia.org/wiki/ISO_8859
    throw UnimplementedError();
  }

  @override
  (Competition, Map<Bout, List<BoutAction>>) importCompetitionReport(String report) {
    // TODO: implement importCompetitionReport
    throw UnimplementedError();
  }

  @override
  (TeamMatch, Map<Bout, List<BoutAction>>) importTeamMatchReport(String report) {
    // TODO: implement importTeamMatchReport
    throw UnimplementedError();
  }
}
