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
    organization: Organization(
      name: 'Test Organization',
    ),
  );
  final league = League(
    name: 'Test League',
    startDate: DateTime(1999),
    endDate: DateTime(2000),
    division: division,
  );
  final clubA = Club(name: 'Club A', organization: organizationNRW);
  final clubB = Club(name: 'Club B', organization: organizationDRB);
  final lineupA = Lineup(team: Team(name: 'Team A', club: clubA));
  final lineupB = Lineup(team: Team(name: 'Team B', club: clubB));
  final teamMatch = TeamMatch(
    league: league,
    home: lineupA,
    guest: lineupB,
    date: DateTime(2000),
    no: 'matchNo',
    visitorsCount: 5,
    referee: Person(prename: 'Mr.', surname: 'Referee'),
    comment: 'Match comment: Semicolon;OpeningParenthesis(ClosingParenthesis)LessThan<GreaterThan>AndSign&'
        .padRight(200, '0'),
  );
  final bout = Bout(
    duration: Duration(minutes: 2),
    r: ParticipantState(
      classificationPoints: 4,
      participation: Participation(
        lineup: lineupA,
        weight: 9,
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
    ),
    b: ParticipantState(
      classificationPoints: 0,
      participation: Participation(
        lineup: lineupB,
        weight: 8,
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
    ),
    weightClass: WeightClass(weight: 10, style: WrestlingStyle.free),
    winnerRole: BoutRole.red,
    result: BoutResult.vfa,
  );

  group('Reports', () {
    test('Germany, NRW', () {
      final wrestlingReport = WrestlingReportProvider.deNwRdb274.getReporter(organizationNRW);
      final report = wrestlingReport.exportTeamMatchReport(
        teamMatch,
        {
          bout: [
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
          ]
        },
      );
      expect(
        report,
        'rdbi;2.0.0;MK;matchNo;Test League;1.1.2000;Team A;Team B;4;0;5;Referee;Mr.;Match comment: Semicolon OpeningParenthesis&#40;ClosingParenthesis&#41;LessThan&lt;GreaterThan&gt;AndSign&amp;00000000000000000000000000000000000000000000000000000000000000000000000000000000000000...\n'
        '10;LL;LizNoA;SurnameA;PrenameA;JN;LizNoB;SurnameB;PrenameB;JEU;4;0;SS;4:2(points PB30,4R60,2B120)',
      );
    });
  });
}
