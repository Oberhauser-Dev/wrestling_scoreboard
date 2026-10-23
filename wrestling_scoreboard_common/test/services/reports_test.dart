import 'package:country/country.dart';
import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';

import 'shared.dart';

void main() {
  final division = Division(
    name: 'Test Division',
    startDate: DateTime(1999),
    endDate: DateTime(2000),
    boutConfig: BoutConfig(),
    seasonPartitions: 2,
    organization: Organization(name: 'Test Organization'),
  );
  final league = League(
    name: 'Test League',
    startDate: DateTime(1999),
    endDate: DateTime(2000),
    division: division,
    boutDays: 14,
  );
  final clubA = Club(name: 'Club A', organization: organizationNRW);
  final clubB = Club(name: 'Club B', organization: organizationDRB);
  final lineupA = TeamLineup(team: Team(name: 'Team A'));
  final lineupB = TeamLineup(team: Team(name: 'Team B'));
  final teamMatch = TeamMatch(
    league: league,
    home: lineupA,
    guest: lineupB,
    date: DateTime(2000),
    no: 'matchNo',
    visitorsCount: 5,
    comment:
        'Match comment: Semicolon ;, OpeningParenthesis (, ClosingParenthesis ), LessThan <, GreaterThan >, AndSign &, Slash /, Backslash \\, Hash #, OpeningBracket [, ClosingBracket ], Plus +, QuestionMark ?, Dollar \$, IsEqual =, Asterisk *, Caret ^, END'
            .padRight(200, '0'),
  );
  final bout = Bout(
    duration: Duration(minutes: 2),
    r: AthleteBoutState(
      classificationPoints: 4,
      membership: Membership(
        no: 'LizNoA',
        club: clubA,
        person: Person(
          prename: 'PrenameA',
          surname: 'SurnameA',
          birthDate: DateTime.now().subtract(Duration(days: 365)),
          gender: Gender.female,
          nationality: Countries.usa,
        ),
      ),
    ),
    b: AthleteBoutState(
      classificationPoints: 0,
      membership: Membership(
        no: 'LizNoB',
        club: clubB,
        person: Person(
          prename: 'PrenameB',
          surname: 'SurnameB',
          birthDate: DateTime.now().subtract(Duration(days: 366)),
          gender: Gender.male,
          nationality: Countries.aut,
        ),
      ),
    ),
    winnerRole: BoutRole.red,
    result: BoutResult.vfa,
    comment:
        'Bout comment: Semicolon ;, OpeningParenthesis (, ClosingParenthesis ), LessThan <, GreaterThan >, AndSign &, Slash /, Backslash \\, Hash #, OpeningBracket [, ClosingBracket ], Plus +, QuestionMark ?, Dollar \$, IsEqual =, Asterisk *, Caret ^, END'
            .padRight(200, '0'),
  );
  final teamMatchBout = TeamMatchBout(
    pos: 0,
    teamMatch: teamMatch,
    bout: bout,
    weightClass: WeightClass(weight: 10, style: WrestlingStyle.free),
  );

  group('Eligibility status suggestion', () {
    final date = DateTime(2026, 10, 1);
    final adult = DateTime(2000, 1, 1);
    // Turns 18 one day after the event.
    final youth = DateTime(2008, 10, 2);
    Person person(Country? nationality, DateTime birthDate) =>
        Person(prename: 'Prename', surname: 'Surname', nationality: nationality, birthDate: birthDate);

    test('Germany, NRW', () {
      final reporter = WrestlingReportProvider.deNwRdb274.getReporter(organizationNRW);
      expect(reporter.suggestEligibilityStatusText(person(Countries.deu, adult), date: date), isNull);
      expect(reporter.suggestEligibilityStatusText(person(null, adult), date: date), isNull);
      expect(reporter.suggestEligibilityStatusText(person(Countries.deu, youth), date: date), 'J');
      expect(reporter.suggestEligibilityStatusText(person(Countries.usa, adult), date: date), 'N');
      expect(reporter.suggestEligibilityStatusText(person(Countries.usa, youth), date: date), 'JN');
      expect(reporter.suggestEligibilityStatusText(person(Countries.aut, adult), date: date), 'EU');
      expect(reporter.suggestEligibilityStatusText(person(Countries.aut, youth), date: date), 'JEU');
    });

    test('Organization falls back to report provider of parent', () {
      final parent = organizationNRW.copyWith(reportProvider: WrestlingReportProvider.deNwRdb274);
      final child = Organization(name: 'Child', parent: parent);
      expect(child.suggestEligibilityStatusText(person(Countries.usa, adult), date: date), 'N');
      expect(organizationDRB.suggestEligibilityStatusText(person(Countries.usa, adult), date: date), isNull);
    });
  });

  group('Reports', () {
    test('Germany, NRW', () {
      final wrestlingReport = WrestlingReportProvider.deNwRdb274.getReporter(organizationNRW);
      final report = wrestlingReport.exportTeamMatchReport(
        teamMatch: teamMatch,
        boutMap: {
          teamMatchBout: [
            BoutAction(
              actionType: BoutActionType.passivity,
              bout: bout,
              duration: Duration(seconds: 30),
              role: BoutRole.blue,
            ),
            BoutAction(
              actionType: BoutActionType.points,
              bout: bout,
              duration: Duration(minutes: 1),
              pointCount: 4,
              role: BoutRole.red,
            ),
            BoutAction(
              actionType: BoutActionType.points,
              bout: bout,
              duration: Duration(minutes: 2),
              pointCount: 2,
              role: BoutRole.blue,
            ),
          ],
        },
        officials: {Person(prename: 'Mr.', surname: 'Referee'): PersonRole.referee},
        // Only the stored status is exported, the guest has none.
        homeParticipations: [
          TeamLineupParticipation(
            membership: bout.r!.membership,
            lineup: lineupA,
            weightClass: teamMatchBout.weightClass,
            eligibilityStatusText: 'N6',
          ),
        ],
        guestParticipations: [],
      );
      expect(
        report,
        '''rdbi;2.0.0;MK;matchNo;Test Division Test League;1.1.2000;Team A;Team B;4;0;5;Referee;Mr.;Match comment: Semicolon ,, OpeningParenthesis (, ClosingParenthesis ), LessThan <, GreaterThan >, AndSign &, Slash /, Backslash \\, Hash #, OpeningBracket [, ClosingBracket ], Plus +, QuestionMark ?, Dollar \$, IsEqual =, Asterisk *, Caret ^, END
10;LL;LizNoA;SurnameA;PrenameA;N6;LizNoB;SurnameB;PrenameB;;4;0;SS;4:2(points AB30,4R60,2B120)(comment Bout comment: Semicolon ,, OpeningParenthesis &#40, ClosingParenthesis &#41, LessThan &lt, GreaterThan &gt, AndSign &amp, Slash /, Backslash \\, Hash #, OpeningBracket [, ClosingBracket ], Plus &#8230)(duration 120)''',
      );
    });
  });
}
