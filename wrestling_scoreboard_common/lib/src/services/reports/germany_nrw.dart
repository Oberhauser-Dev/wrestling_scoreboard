import 'dart:convert';
import 'dart:math' as math;

import 'package:collection/collection.dart';
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

extension _BooleanParser on bool {
  String get toGerman => this ? 'Wahr' : 'Falsch';
}

extension _DateTimeParser on DateTime {
  String get toGerman => '$day.$month.$year';
}

extension _GerBoutResultAbbreviation on BoutResult {
  String get toGerman {
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
        return 'o.W.'; // ohne Wertung
      case BoutResult.bothDsq:
        return 'DQ2';
    }
  }

  // SS/SN Schultersieg
  // TÜPS/TÜPN Technisch überlegener Punktsieg
  // PS/PN Punktsieg
  // PES/PEN Sieg durch Passivitätsentscheid
  // AS/AN Aufgabe wegen Verletzung Überschreiten der Verletzungszeit
  // KLS/KLN Kampfloser Sieg (ohne Gegner)
  // ÜGS/ÜGN Übergewichtssieg/-niederlage
  // DS/DN Nur GR: Disqalifikation eines Ringers
  // aufgrund 4. Passivitätsverstosses
  // DVS/DVN Disqualifikation eines Ringers
  // aufgrund 3. Verwarnung wegen Regelwidrigkeit
  // DQS/DQN Disqualifikation eines Ringers
  // aufgrund Tätlichkeit / Unsportlichkeit
  // KES/KEN Sieg/Niederlage durch Kampfrichterentscheid
  // UGS/UGN Untergewichtssieg/-niederlage
  String get toGermanWinner {
    switch (this) {
      case BoutResult.vfa:
        return 'SS';
      case BoutResult.vin:
        return 'AS';
      case BoutResult.vca:
        return 'DVS';
      case BoutResult.vsu:
        return 'TÜPS';
      case BoutResult.vpo:
        return 'PS';
      case BoutResult.vfo:
        return 'KLS'; // Also known 'ÜGS' and 'DN'
      case BoutResult.dsq:
        return 'DQS';
      case BoutResult.bothVfo:
      case BoutResult.bothVin:
      case BoutResult.bothDsq:
        return 'DQ2';
    }
  }

  String get toGermanLoser {
    switch (this) {
      case BoutResult.vfa:
        return 'SN';
      case BoutResult.vin:
        return 'AN';
      case BoutResult.vca:
        return 'DVN';
      case BoutResult.vsu:
        return 'TÜPN';
      case BoutResult.vpo:
        return 'PN';
      case BoutResult.vfo:
        return 'KLN'; // Also known as 'ÜGN'
      case BoutResult.dsq:
        return 'DQN';
      case BoutResult.bothVfo:
      case BoutResult.bothVin:
      case BoutResult.bothDsq:
        return 'DQ2';
    }
  }
}

extension _WrestlingStyleParser on WrestlingStyle {
  String get abbreviation => this == WrestlingStyle.greco ? 'GR' : 'LL';

  String get toGerman => this == WrestlingStyle.greco ? 'griechisch-römisch' : 'freistil';
}

/// See: https://www.brv-ringen.de/index.php?option=com_wbw&view=wbw&Itemid=516&tk=dw&dwbid=1&dwcid=15&op=da&opa=0&dwnid=18&opv=lql
/// TODO: https://github.com/Oberhauser-Dev/wrestling_scoreboard/issues/1
class NrwGermanyWrestlingReporter extends WrestlingReporter {
  static const HtmlEscape _htmlEscape = HtmlEscape(HtmlEscapeMode(escapeLtGt: true));
  final vendor = 'Oberhauser';

  @override
  final Organization organization;

  NrwGermanyWrestlingReporter(this.organization);

  String _handleComment(String comment) {
    final String escapedComment = _htmlEscape
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
  String exportTeamMatchReport({
    required TeamMatch teamMatch,
    required Map<TeamMatchBout, List<BoutAction>> boutMap,
    required Map<Person, PersonRole> officials,
  }) {
    final bouts = boutMap.keys;
    final referee =
        officials.entries.where((official) => official.value == PersonRole.referee).map((e) => e.key).singleOrNull;
    final teamMatchInfos = <Object>[
      'rdbi',
      '2.0.0',
      'MK',
      teamMatch.no ?? '', // 3:competitionId
      _sanitizeString(teamMatch.league?.fullname ?? ''), // 4:Tabelle
      teamMatch.date.toGerman, // 5:Datum
      _sanitizeString(teamMatch.home.team.name), // 6:Heim
      _sanitizeString(teamMatch.guest.team.name), // 7:Gast
      TeamMatch.getHomePoints(bouts),
      TeamMatch.getGuestPoints(bouts),
      teamMatch.visitorsCount ?? '',
      _sanitizeString(referee?.surname ?? ''),
      _sanitizeString(referee?.prename ?? ''),
      _handleComment(teamMatch.comment ?? ''),
    ];
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
        (teamMatchBout.weightClass?.style ?? WrestlingStyle.free).abbreviation, // 1:stil
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
      ];
    });
    final List<List<Object>> resultMap = [teamMatchInfos, ...boutInfos];
    return resultMap.map((e) => e.join(';')).join('\n');
  }

  // https://de.wikipedia.org/wiki/ISO_8859
  @override
  String exportCompetitionReport({
    required Competition competition,
    required Map<CompetitionBout, List<BoutAction>> boutMap,
    required Iterable<CompetitionLineup> competitionLineups,
    required Iterable<CompetitionSystemAffiliation> competitionSystems,
    required Map<CompetitionWeightCategory, Iterable<CompetitionParticipation>> competitionWeightCategoryMap,
    required Iterable<CompetitionAgeCategory> competitionAgeCategories,
    required Iterable<BoutResultRule> boutResultRules,
  }) {
    // The rules for the loser are just the inverted rules for the winner
    // The following is used to generate fake IDs for the loser rules, which are [maxIdOfBoutResultRules] + rule.id
    final maxIdOfBoutResultRules =
        boutResultRules.fold(0, (value, element) => math.max<int>(value, element.id ?? 0)) + 1;
    final boutConfig = competition.boutConfig;

    // Aggregate all competitionWeightParticipations
    final competitionParticipations = competitionWeightCategoryMap.values.expand((e) => e);

    final headerInfos = [
      ['rdbi', '1.0.0', 'DTA', vendor],
      ['rdbi', '1.0.0', 'ATOM', 'version', '1.1'],
      ['rdbi', '1.0.0', 'ATOM', 'version', '1.1'],
    ];

    final objPrefix = ['rdbi', '1.0.0', 'OBJ'];

    final tblTeilnehmer = <List<Object>>[
      [
        ...objPrefix,
        'tblTeilnehmer',
        'NameID',
        'KlasseID',
        'LosNr',
        'LosNrOriginal',
        'LosNrVerein',
        'PoolID',
        'PoolNr',
        'PoolPlatz',
        'Platz',
        'Ausgeschieden',
        'MeldungID',
        'Gewicht',
      ],
      // 46;1236;455;455;455;1;1;2;4;Falsch;42;
    ];
    for (final competitionWeightCategoryEntry in competitionWeightCategoryMap.entries) {
      final competitionWeightCategory = competitionWeightCategoryEntry.key;
      final weightCategoryParticipants = competitionWeightCategoryEntry.value;
      // Map.where alternative
      final weightCategoryBoutsWithActions = {
        for (final cBout in boutMap.keys)
          if (cBout.weightCategory?.id == competitionWeightCategory.id) cBout: boutMap[cBout]!,
      };
      competitionWeightCategory.rankingBuilder(
        weightCategoryParticipants: weightCategoryParticipants,
        weightCategoryBoutsWithActions: weightCategoryBoutsWithActions,
        poolGroupBuilder: (poolGroup) {},
        poolGroupParticipantBuilder: (
          CompetitionParticipation cp,
          int? ranking,
          int? poolRanking,
          RankingMetric? rankingMetric,
        ) {
          tblTeilnehmer.add([
            cp.membership.id ?? '',
            cp.weightCategory?.id ?? '',
            cp.id ?? '',
            cp.id ?? '',
            cp.id ?? '',
            cp.poolGroup ?? '',
            cp.displayDrawNumber ?? '',
            ranking ?? '',
            poolRanking ?? '',
            cp.isExcluded,
            cp.id ?? '',
            cp.weight ?? '',
          ]);
        },
      );
    }

    final tblKaempfe = [
      [
        ...objPrefix,
        'tblKämpfe',
        'KampfNr',
        'ImpKampfNr',
        'KlasseID',
        'RundeID',
        'RingerRotID',
        'GewichtRot',
        'PunkteRot',
        'TechPunkteRot',
        'VerwarnungenRot',
        'ErgebnisRotID',
        'RingerBlauID',
        'GewichtBlau',
        'PunkteBlau',
        'VerwarnungenBlau',
        'TechPunkteBlau',
        'ErgebnisBlauID',
        'Punkte',
        'Kampfzeit',
        'VerletzungRot',
        'VerletzungBlau',
        'Aufgerufen',
        'Matte',
        'Aufrufzeit',
        'Eingetragen',
      ],
      // 712;0;1223;1;13832;;5;4;;21;14147;;0;;0;41;R217R242;00:45:00;;;Wahr;1;29.03.2025 09:45:36;29.03.2025 09:53:35
      ...boutMap.entries.map((boutMap) {
        final cBout = boutMap.key;
        final boutActions = boutMap.value;
        final techPointsRed = AthleteBoutState.getTechnicalPoints(boutActions, BoutRole.red);
        final techPointsBlue = AthleteBoutState.getTechnicalPoints(boutActions, BoutRole.blue);
        final resultRuleWinnerId =
            (cBout.bout.result == null || cBout.weightCategory == null)
                ? null
                : BoutConfig.resultRule(
                  result: cBout.bout.result!,
                  rules: boutResultRules,
                  style: cBout.weightCategory!.weightClass.style,
                  technicalPointsWinner: cBout.bout.winnerRole == BoutRole.red ? techPointsRed : techPointsBlue,
                  technicalPointsLoser: cBout.bout.winnerRole == BoutRole.red ? techPointsBlue : techPointsRed,
                )?.id;
        final resultRuleIdRed =
            resultRuleWinnerId == null
                ? null
                : cBout.bout.winnerRole == BoutRole.red
                ? resultRuleWinnerId // Winner result id
                : (maxIdOfBoutResultRules + resultRuleWinnerId); // Loser result id
        final resultRuleIdBlue =
            resultRuleWinnerId == null
                ? null
                : cBout.bout.winnerRole == BoutRole.red
                ? (maxIdOfBoutResultRules + resultRuleWinnerId) // Loser result id
                : resultRuleWinnerId; // Winner result id
        return <Object>[
          cBout.id ?? '',
          0,
          cBout.weightCategory?.id ?? '',
          cBout.displayRound ?? '',
          cBout.bout.r?.membership.id ?? '',
          competitionParticipations.firstWhereOrNull((cp) => cp.membership.id == cBout.bout.r?.membership.id)?.weight ??
              '',
          cBout.bout.r?.classificationPoints ?? '',
          techPointsRed,
          boutActions.where((ba) => ba.actionType == BoutActionType.caution && ba.role == BoutRole.red).length,
          resultRuleIdRed ?? '',
          cBout.bout.b?.membership.id ?? '',
          competitionParticipations.firstWhereOrNull((cp) => cp.membership.id == cBout.bout.b?.membership.id)?.weight ??
              '',
          cBout.bout.b?.classificationPoints ?? '',
          techPointsBlue,
          boutActions.where((ba) => ba.actionType == BoutActionType.caution && ba.role == BoutRole.blue).length,
          resultRuleIdBlue ?? '',
        ];
      }),
    ];

    final tblRunden = [
      [
        ...objPrefix,
        'tblRunden',
        'KampfNr',
        'Runde',
        'TechPunkteRot',
        'ErgebnisRotID',
        'TechPunkteBlau',
        'ErgebnisBlauID',
        'Kampfzeit',
        'Punkte',
        'Eingetragen',
      ],
    ];

    // 39;35;28.03.2025 22:48:01;45
    final tblMeldungen = [
      [...objPrefix, 'tblMeldungen', 'MeldungID', 'NameID', 'Anmeldung', 'AlterID'],
      ...competitionParticipations.map(
        (cp) => <Object>[
          cp.id ?? '',
          cp.membership.id ?? '',
          '', // TODO Anmeldung
          cp.weightCategory?.competitionAgeCategory.id ?? '',
        ],
      ),
    ];

    final tblPool = [
      [...objPrefix, 'tblPool', 'PoolID', 'Pool'],
    ];

    // 13842;;;Bichlmaier;Finn Ishaan;24.01.2017;2017;;70008;29.03.2025 07:53:26
    final tblRinger = [
      [
        ...objPrefix,
        'tblRinger',
        'NameID',
        'ImpNameID',
        'PassNr',
        'Nachname',
        'Vorname',
        'Geburtsdatum',
        'Jahrgang',
        'Staatsangehörigkeit',
        'VereinID',
        'LetzteTeilnahme',
        ...competitionParticipations.map(
          (cp) => [
            cp.membership.id,
            '',
            cp.membership.no,
            cp.membership.person.surname,
            cp.membership.person.prename,
            cp.membership.person.birthDate?.toGerman ?? '',
            cp.membership.person.birthDate?.year ?? '',
            cp.membership.person.nationality?.nationality ?? '',
            cp.membership.club.id,
            '', // TODO
          ],
        ),
      ],
    ];

    // 10047;;SC Anger;Anger;
    final tblVerein = [
      [...objPrefix, 'tblVerein', 'VereinID', 'ImpVereinID', 'Verein', 'Vereinsort', 'LandesverbandID'],
      ...competitionLineups.map(
        (cl) => <Object>[
          cl.club.id ?? '',
          '',
          cl.club.name,
          '', // TODO: cl.club.location,
          '',
        ],
      ),
    ];

    final tblLandesverband = [
      [...objPrefix, 'tblLandesverband', 'LandesverbandID', 'Landesverband', 'LO'],
    ];

    // 1223;;40;21;14;1;Wahr
    final tblKlasse = [
      [
        ...objPrefix,
        'tblKlasse',
        'KlasseID',
        'ImpKlasseID',
        'AlterID',
        'Gewichtsklasse',
        'DruckenRundeID',
        'Kampffolge',
        'Drucken',
      ],
      ...competitionWeightCategoryMap.keys.map((cwc) {
        return [
          cwc.id ?? '',
          '',
          cwc.competitionAgeCategory.id ?? '',
          cwc.weightClass.weight,
          '',
          cwc.pos,
          true.toGerman,
        ];
      }),
    ];

    final tblVorgaben = [
      [
        ...objPrefix,
        'tblVorgaben',
        'TurnierID',
        'ImpTurnierID',
        'Allgemeine_Angaben',
        'Titel1',
        'Titel2',
        'Ort',
        'Verein',
        'Datum',
        'Regeln',
        'Überkreuz',
        'Startkarten drucken',
        'Punktzettel drucken',
        'Urkunden drucken',
        'UrkundeBerichtsname',
        'Ergebnisliste drucken',
        'Dateiname',
        'Sicherungspfad1',
        'Sicherungspfad2',
        'Gültig',
        'Mattenzahl',
        'Mannschaftswertung',
        'LosNr_Erzeugen',
        'RingerSetzen',
        'Finale56InÜberkreuz',
        'Kampfzeiten',
        'Pausenzeiten',
        'Zwiegriffzeiten',
        'Verletzungszeit',
        'Runden',
        'LOAnzeigen',
        'AnzTeilnehmerNordisch',
        'RundenEingeben',
      ],
      // 11;;;Wittelsbacher-Land-Turnier;2025;Aichach;TSV Aichach;29.03.2025;;Falsch;Etiketten;Vordruck;1-6;UrkundeWLT2025;1-6;WLT_2025;;;Wahr;5;Standard;Wahr;Wahr;Falsch;180;30;30;120;2;Falsch;6;Falsch
      [
        competition.id!, '', '', competition.name, competition.date.year, competition.location ?? '',
        '', // TODO: competition.organizer
        competition.date.toGerman,
        '', // Regeln
        '', // TODO: competion.isAcross
        'Etiketten',
        'Vordruck',
        '1-${competition.maxRanking}',
        '', // UrkundeBerichtsname
        '1-${competition.maxRanking}', // TODO: Ergebnisliste drucken
        '', // Dateiname
        '', // Sicherungspfad1
        '', // Sicherungspfad2
        true.toGerman, // Gültig
        competition.matCount, // Mattenzahl
        'Standard', // Mannschaftswertung
        true.toGerman, // LosNr_Erzeugen
        true.toGerman, // RingerSetzen
        false.toGerman, // TODO: Finale56InÜberkreuz
        boutConfig.totalPeriodDuration.inSeconds, // Kampfzeiten
        boutConfig.breakDuration.inSeconds, // Pausenzeiten
        boutConfig.activityDuration?.inSeconds ?? '', // Zwiegriffzeiten
        boutConfig.injuryDuration?.inSeconds ?? '', // Verletzungszeit
        boutConfig.periodCount, // Runden
        false.toGerman, // LOAnzeigen
        competitionSystems.firstWhereOrNull((cs) => cs.competitionSystem == CompetitionSystem.nordic)?.maxContestants ??
            '', // AnzTeilnehmerNordisch
        false.toGerman, // RundenEingeben
      ],
    ];

    final tblAlter = [
      [
        ...objPrefix,
        'tblAlter',
        'AlterID',
        'ImpAlterID',
        'TurnierID',
        'Altersklasse',
        'AlterVon',
        'AlterBis',
        'Stilart',
        'imTurnier',
        'Kampfgeschwindigkeit',
        'Kampffolge',
        'aufBeamer',
        'Überkreuz',
        'Drucken',
        'GewichtEingeben',
        'GewichtsklassenErzeugen',
        'MaxAnzahlRinger',
        'MaxGewichtsunterschied',
        'Kampfzeiten',
        'TPunkte4T PS',
      ],
      // 40;;11;E-Jugend;6;8;freistil;Wahr;15;1;Wahr;Falsch;Falsch;Wahr;Falsch;8;10;120;10
      ...competitionAgeCategories.map((cac) {
        return <Object>[
          cac.id ?? '',
          '',
          competition.id ?? '',
          cac.ageCategory.name,
          cac.ageCategory.minAge,
          cac.ageCategory.maxAge,
          WrestlingStyle.free.toGerman, // TODO: cac.wrestlingStyle,
          true.toGerman,
          '', // TODO Kampfgeschwindigkeit
          cac.pos,
          true.toGerman,
          '', // TODO across mode,
          false.toGerman,
          false.toGerman,
          true.toGerman,
          false.toGerman,
          8, // TODO max Anzahl Ringer
          10, // TODO max Gewichtsunterschied
          boutConfig.totalPeriodDuration.inSeconds,
          10,
        ];
      }),
    ];

    // 1223;1;1;5;2;;;Falsch;
    final tblRundeneinteilung = [
      [
        ...objPrefix,
        'tblRundeneinteilung',
        'KlasseID',
        'RundeID',
        'TatRunde',
        'AnzahlTeilnehmer',
        'Kämpfe',
        'Wahrscheinlichkeit',
        'AnzDatensätze',
        'AmAnsagetisch',
        'Kampffolge',
      ],
      // TODO: not present
    ];

    // 1;PS;3;1
    final tblErgebnis = [
      [...objPrefix, 'tblErgebnis', 'ErgebnisID', 'Ergebnis', 'Punkte', 'Punkte Gegner'],
      ...boutResultRules.map((brr) {
        return <Object>[
          brr.id ?? '',
          brr.boutResult.toGermanWinner,
          brr.winnerClassificationPoints,
          brr.loserClassificationPoints,
        ];
      }),
      ...boutResultRules.map((brr) {
        return <Object>[
          brr.id == null ? '' : maxIdOfBoutResultRules + brr.id!,
          brr.boutResult.toGermanLoser,
          brr.loserClassificationPoints,
          brr.winnerClassificationPoints,
        ];
      }),
    ];

    final List<List<List<Object>>> resultMap = [
      headerInfos,
      tblTeilnehmer,
      tblKaempfe,
      tblRunden,
      tblMeldungen,
      tblPool,
      tblRinger,
      tblVerein,
      tblLandesverband,
      tblKlasse,
      tblVorgaben,
      tblAlter,
      tblRundeneinteilung,
      tblErgebnis,
    ];
    return resultMap.map((t) => t.map((l) => l.join(';')).join('\n')).join('\n\n');
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
