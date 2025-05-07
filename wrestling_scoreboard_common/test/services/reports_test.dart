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
    referee: Person(prename: 'Mr.', surname: 'Referee'),
    comment: 'Match comment: Semicolon;OpeningParenthesis(ClosingParenthesis)LessThan<GreaterThan>AndSign&'.padRight(
      200,
      '0',
    ),
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
  );
  final teamMatchBout = TeamMatchBout(
    pos: 0,
    teamMatch: teamMatch,
    bout: bout,
    weightClass: WeightClass(weight: 10, style: WrestlingStyle.free),
  );

  group('Reports', () {
    test('Germany, NRW', () {
      final wrestlingReport = WrestlingReportProvider.deNwRdb274.getReporter(organizationNRW);
      final report = wrestlingReport.exportTeamMatchReport(teamMatch, {
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
      });
      expect(
        report,
        'rdbi;2.0.0;MK;matchNo;Test Division Test League;1.1.2000;Team A;Team B;4;0;5;Referee;Mr.;Match comment: Semicolon,OpeningParenthesis&#40;ClosingParenthesis&#41;LessThan&lt;GreaterThan&gt;AndSign&amp;000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000\n'
        '10;LL;LizNoA;SurnameA;PrenameA;JN;LizNoB;SurnameB;PrenameB;JEU;4;0;SS;4:2(points AB30,4R60,2B120)(duration 120)',
      );
    });
  });
}
