import 'package:wrestling_scoreboard_common/common.dart';

enum OrganizationImportType {
  organization,
  team,
  league,
  competition,
  teamMatch;

  Type get dataType {
    return switch (this) {
      organization => Organization,
      team => Team,
      league => League,
      competition => Competition,
      teamMatch => TeamMatch,
    };
  }
}
