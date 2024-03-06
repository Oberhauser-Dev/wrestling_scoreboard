import '../../common.dart';

export 'reports/germany_nrw.dart';

/// Country and region code prefixes by https://en.wikipedia.org/wiki/ISO_3166-2
/// and https://de.wikipedia.org/wiki/ISO_3166-2:DE
enum WrestlingReportProvider {
  deNwRdb274; // NRW, RDB 2.7.4 für Mannschaftskämpfe

  WrestlingReporter get reporter {
    switch (this) {
      case WrestlingReportProvider.deNwRdb274:
        return NrwGermanyWrestlingReporter();
    }
  }
}

/// Abstraction for importing and exporting file reports.
abstract class WrestlingReporter {
  String exportTeamMatchReport(TeamMatch teamMatch, Map<Bout, List<BoutAction>> boutMap);

  (TeamMatch teamMatch, Map<Bout, List<BoutAction>> boutMap) importTeamMatchReport(String report);

  String exportCompetitionReport(Competition competition, Map<Bout, List<BoutAction>> boutMap);

  (Competition competition, Map<Bout, List<BoutAction>> boutMap) importCompetitionReport(String report);
}
