// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Wrestling Scoreboard';

  @override
  String get start => 'Start';

  @override
  String get home => 'Home';

  @override
  String get guest => 'Guest';

  @override
  String get explore => 'Explore';

  @override
  String get more => 'More';

  @override
  String get settings => 'Settings';

  @override
  String get general => 'General';

  @override
  String get network => 'Network';

  @override
  String get scoreboard => 'Scoreboard';

  @override
  String get systemSetting => 'System setting';

  @override
  String get language => 'Language';

  @override
  String get de_DE => 'German';

  @override
  String get en_US => 'English (US)';

  @override
  String get themeMode => 'Theme mode';

  @override
  String get themeModeLight => 'Light mode';

  @override
  String get themeModeDark => 'Dark mode';

  @override
  String get fontFamily => 'Font family';

  @override
  String get systemFont => 'System font';

  @override
  String get apiUrl => 'Api-Url';

  @override
  String get wsUrl => 'Websocket-Url';

  @override
  String get webClientUrl => 'Web Client Url (used for sharing)';

  @override
  String get services => 'Services';

  @override
  String get apiProvider => 'API Provider';

  @override
  String get warningOverrideDatabase =>
      'This action overrides the existing database. Are you sure, you want to continue?';

  @override
  String get importFromApiProvider => 'Sync with API provider';

  @override
  String get warningMissingApiProviderCredentials =>
      'The credentials for the API Provider of the organization are required for the import. Please provide a username and a password!';

  @override
  String get warningImportFromApiProvider =>
      'This action imports objects of this organization and tries to integrate them. Are you sure, you want to continue?';

  @override
  String get proposeFirstImportFromApiProvider => 'Cannot determine the last import. Would you like import the data?';

  @override
  String proposeImportFromApiProvider(DateTime date, DateTime time) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);
    final intl.DateFormat timeDateFormat = intl.DateFormat.Hm(localeName);
    final String timeString = timeDateFormat.format(time);

    return 'The last import was on $dateString at $timeString. Would you like to update the data?';
  }

  @override
  String get proposeApiImportDuration => 'Duration for proposing an API import';

  @override
  String get importIncludeSubjacent =>
      'Also import all subjacent data. This may take longer and fail on a timeout or if inconsistent data occurs!';

  @override
  String get appDataDirectory => 'App Data Directory';

  @override
  String get reportProvider => 'Report Provider';

  @override
  String get warningMissingReporter => 'Please provide a Report Provider for this organization.';

  @override
  String get report => 'Report';

  @override
  String get print => 'Print';

  @override
  String get database => 'Database';

  @override
  String get exportDatabase => 'Export database';

  @override
  String get restoreDatabase => 'Restore database';

  @override
  String get restoreDefaultDatabase => 'Restore default database';

  @override
  String get resetDatabase => 'Reset database';

  @override
  String get localBackup => 'Local Backup';

  @override
  String get saveEvery => 'Save every';

  @override
  String get deleteAfter => 'Delete after';

  @override
  String get bellSound => 'Bell sound';

  @override
  String get timeCountDown => 'Count down the time';

  @override
  String get profile => 'Profile';

  @override
  String get username => 'Username';

  @override
  String get usernameRequirementsWarning =>
      'A username may only contain alphanumeric characters, dot (.), hyphen (-) or underscore (_).';

  @override
  String get password => 'Password';

  @override
  String get email => 'Email';

  @override
  String get administration => 'Administration';

  @override
  String get users => 'Users';

  @override
  String get user => 'User';

  @override
  String get joinedOn => 'Joined on';

  @override
  String get privilege => 'Privilege';

  @override
  String get auth_signIn => 'Sign in';

  @override
  String get auth_signInPrompt_phrase => 'Already have an account? Sign In';

  @override
  String get auth_signIntoAccount_phrase => 'Sign in to your account';

  @override
  String get auth_signUp => 'Sign up';

  @override
  String get auth_signUpPrompt_phrase => 'Don\'t have an account? Sign Up';

  @override
  String get auth_signOut => 'Sign out';

  @override
  String get auth_emailPrompt_phrase => 'Please enter your email address';

  @override
  String get auth_Password => 'Password';

  @override
  String get auth_password_save_phrase => 'Save password';

  @override
  String get auth_change_password => 'Change password';

  @override
  String get auth_agreeTermsAndConditions_phrase => 'I read and agree to Terms & Conditions';

  @override
  String get imprint => 'Imprint';

  @override
  String get imprint_phrase =>
      '**Angaben gem. § 5 TMG:**\n\nOberhauser Dev\n\nAugust Oberhauser\n\nGroßhausener Str. 16\n\n86551 Aichach\n\n**Kontaktaufnahme:**\n\nE-Mail: info@oberhauser.dev\n\n**Umsatzsteuer-Identifikationsnummer gem. § 27 a Umsatzsteuergesetz:**\n\nDE XXX XXX XXX';

  @override
  String get about => 'About';

  @override
  String get about_Changelog => 'Changelog';

  @override
  String get about_Licenses => 'Licenses';

  @override
  String get about_Application => 'Application';

  @override
  String get about_Contact => 'Contact';

  @override
  String get about_contact_phrase =>
      'August Oberhauser\n\nEmail: info@oberhauser.dev\n\nWebsite: [oberhauser.dev](https://oberhauser.dev)';

  @override
  String get about_Development => 'Development';

  @override
  String get about_development_phrase =>
      'August Oberhauser\n\nEmail: info@oberhauser.dev\n\nWebsite: [oberhauser.dev](https://oberhauser.dev)';

  @override
  String get privacy_policy => 'Privacy Policy';

  @override
  String get optionSelect => 'select';

  @override
  String get noneSelected => 'None selected';

  @override
  String get create => 'Create';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get saveAndGenerate => 'Save & Generate';

  @override
  String get generate => 'Generate';

  @override
  String get add => 'Add';

  @override
  String get addExisting => 'Add existing';

  @override
  String get mergeObjectData => 'Merge Object Data';

  @override
  String get remove => 'Remove';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String get ok => 'OK';

  @override
  String get info => 'Info';

  @override
  String get details => 'Details';

  @override
  String get display => 'Display';

  @override
  String get share => 'Share';

  @override
  String get toggleFullscreen => 'Toggle Fullscreen';

  @override
  String get favorite => 'Favorite';

  @override
  String get favorites => 'Favorites';

  @override
  String get name => 'Name';

  @override
  String get description => 'Description';

  @override
  String get comment => 'Comment';

  @override
  String get abbreviation => 'Abbreviation';

  @override
  String get position => 'Position';

  @override
  String get noItems => 'No items available.';

  @override
  String get optional => 'Optional';

  @override
  String get mandatoryField => 'This is a mandatory field.';

  @override
  String get actionSuccessful => 'The action was successful.';

  @override
  String get noWebSocketConnection => 'The connection to the server could not be established or was interrupted.';

  @override
  String get errorOccurred => 'Something went wrong :/';

  @override
  String get notFoundException => 'Element was not found :/';

  @override
  String get invalidParameterException => 'The change was not successful, please check your input parameters.';

  @override
  String get warningBoutGenerate =>
      'This action overrides all existing bouts of this match. To edit single bouts, use the bout editing page. Are you sure, you want to continue?';

  @override
  String get warningPrefilledLineup => 'The lineup was prefilled with values from a previous match!';

  @override
  String get infoUseDivisionWeightClass =>
      'Only define weight classes per league, if they differ from those of its division!';

  @override
  String get retry => 'Retry';

  @override
  String get networkTimeout => 'Network timeout';

  @override
  String get event => 'Event';

  @override
  String get place => 'Place';

  @override
  String get date => 'Date';

  @override
  String get days => 'Days';

  @override
  String get hours => 'Hours';

  @override
  String get minutes => 'Minutes';

  @override
  String get seconds => 'Seconds';

  @override
  String get startDate => 'Beginning';

  @override
  String get endDate => 'End';

  @override
  String get wrestlingRulesPdf => 'https://uww.org/sites/default/files/2019-12/wrestling_rules.pdf';

  @override
  String get teamMatchTranscript => 'Transcript for Team Matches';

  @override
  String get teamMatchScoreSheet => 'Score sheet for Team Matches';

  @override
  String get singleCompetitionTranscript => 'Transcript for Single Competitions';

  @override
  String get singleCompetitionScoreSheet => 'Score sheet for Single Competitions';

  @override
  String get signature => 'Signature';

  @override
  String get pool => 'Pool';

  @override
  String get poolGroupCount => 'Pool group count';

  @override
  String get rank => 'Rank';

  @override
  String get cycle => 'Cycle';

  @override
  String get cycles => 'Cycles';

  @override
  String get round => 'Round';

  @override
  String get roundType => 'Round Type';

  @override
  String get qualification => 'Qualification';

  @override
  String get contestantStatus => 'Contestant Status';

  @override
  String get elimination => 'Elimination';

  @override
  String get eliminated => 'Eliminated';

  @override
  String get injured => 'Injured';

  @override
  String get disqualified => 'Disqualified';

  @override
  String get repechage => 'Repechage';

  @override
  String get finals => 'Final';

  @override
  String get semiFinals => 'Semi-Final';

  @override
  String get mat => 'Mat';

  @override
  String get mats => 'Mats';

  @override
  String get status => 'Status';

  @override
  String get visitors => 'Visitors';

  @override
  String get numberAbbreviation => 'No.';

  @override
  String get total => 'Total';

  @override
  String get participantVacant => 'vacant';

  @override
  String get weight => 'Weight';

  @override
  String get weightClass => 'Weight Class';

  @override
  String get weightClasses => 'Weight Classes';

  @override
  String get weightCategory => 'Weight Category';

  @override
  String get weightCategories => 'Weight Categories';

  @override
  String get weightUnit => 'Weight Unit';

  @override
  String get ageCategory => 'Age Category';

  @override
  String get ageCategories => 'Age Categories';

  @override
  String get suffix => 'Category';

  @override
  String get participantUnknownWeight => 'unknown weight';

  @override
  String get club => 'Club';

  @override
  String get clubs => 'Clubs';

  @override
  String get clubNumber => 'Club number';

  @override
  String get person => 'Person';

  @override
  String get persons => 'Persons';

  @override
  String get membership => 'Membership';

  @override
  String get memberships => 'Memberships';

  @override
  String get membershipNumber => 'Membership number';

  @override
  String get leader => 'Team Leader';

  @override
  String get leaders => 'Team Leaders';

  @override
  String get coach => 'Coach';

  @override
  String get coaches => 'Coaches';

  @override
  String get team => 'Team';

  @override
  String get teams => 'Teams';

  @override
  String get teamClubAffiliation => 'Team Club Affiliation';

  @override
  String get participatingTeam => 'Participating Team';

  @override
  String get participatingTeams => 'Participating Teams';

  @override
  String get sub => 'Sub';

  @override
  String get umbrellaOrganization => 'Umbrella Organization';

  @override
  String get organization => 'Organization';

  @override
  String get organizations => 'Organizations';

  @override
  String get division => 'Division';

  @override
  String get divisions => 'Divisions';

  @override
  String get league => 'League';

  @override
  String get leagues => 'Leagues';

  @override
  String get season => 'Season';

  @override
  String get seasonPartition => 'Season Partition';

  @override
  String get seasonPartitions => 'Season Partitions';

  @override
  String get seasonFirstHalf => 'First Half';

  @override
  String get seasonSecondHalf => 'Second Half';

  @override
  String get competition => 'Competition';

  @override
  String get competitions => 'Competitions';

  @override
  String get competitionSystem => 'Competition System';

  @override
  String get competitionSystems => 'Competition Systems';

  @override
  String get boutDay => 'Bout Day';

  @override
  String get boutDays => 'Bout Days';

  @override
  String get match => 'Match';

  @override
  String get matches => 'Matches';

  @override
  String get competitionNumber => 'Competition-ID';

  @override
  String get matchNumber => 'Match-ID';

  @override
  String get lineup => 'Lineup';

  @override
  String get lineups => 'Lineups';

  @override
  String get bout => 'Bout';

  @override
  String get bouts => 'Bouts';

  @override
  String get boutNo => 'Bout-No.';

  @override
  String get boutResult => 'Bout Result';

  @override
  String get boutResultVfa => 'Victory by fall';

  @override
  String get boutResultVin => 'Victory by injury';

  @override
  String get boutResultBothVin => 'Both wrestlers are injured';

  @override
  String get boutResultVca =>
      'Victory by cautions - the opponent received 3 cautions \"O\" due to error against the rules';

  @override
  String get boutResultVsu => 'Technical superiority';

  @override
  String get boutResultVpo => 'Victory by points';

  @override
  String get boutResultVfo => 'Victory by forfeit - no show up on the mat / not attending or failing the weigh-in';

  @override
  String get boutResultBothVfo => 'None of wrestlers pass the weight or show up on the mat';

  @override
  String get boutResultDsq =>
      'Victory by disqualification of the opponent from the whole competition due to infringement of the rules';

  @override
  String get boutResultBothDsq => 'In case both wrestlers have been disqualified due to infringement of the rules';

  @override
  String get boutResultVfaAbbr => 'VFA';

  @override
  String get boutResultVinAbbr => 'VIN';

  @override
  String get boutResultBothVinAbbr => '2VIN';

  @override
  String get boutResultVcaAbbr => 'VCA';

  @override
  String get boutResultVsuAbbr => 'VSU';

  @override
  String get boutResultVpoAbbr => 'VPO';

  @override
  String get boutResultVfoAbbr => 'VFO';

  @override
  String get boutResultBothVfoAbbr => '2VFO';

  @override
  String get boutResultDsqAbbr => 'DSQ';

  @override
  String get boutResultBothDsqAbbr => '2DSQ';

  @override
  String get actions => 'Actions';

  @override
  String get point => 'Point';

  @override
  String get points => 'Points';

  @override
  String get technicalPoints => 'Technical Points';

  @override
  String get technicalPointsAbbr => 'TP';

  @override
  String get classificationPoints => 'Classification Points';

  @override
  String get classificationPointsAbbr => 'CP';

  @override
  String get difference => 'Difference';

  @override
  String get participation => 'Participation';

  @override
  String get participations => 'Participations';

  @override
  String get boutConfig => 'Bout configuration';

  @override
  String get boutResultRule => 'Bout Result Rule';

  @override
  String get boutResultRules => 'Bout Result Rules';

  @override
  String get launchScratchBout => 'Launch Scratch Bout';

  @override
  String get searchResults => 'Search results';

  @override
  String get red => 'Red';

  @override
  String get blue => 'Blue';

  @override
  String get winner => 'Winner';

  @override
  String get wins => 'Wins';

  @override
  String get loser => 'Loser';

  @override
  String get result => 'Result';

  @override
  String get wrestlingStyle => 'Style';

  @override
  String get freeStyle => 'Freestyle';

  @override
  String get freeStyleAbbr => 'F';

  @override
  String get grecoRoman => 'Greco-Roman';

  @override
  String get grecoRomanAbbr => 'G';

  @override
  String get verbalWarning => 'Verbal Warning';

  @override
  String get verbalWarningAbbr => 'V';

  @override
  String get passivity => 'Passivity';

  @override
  String get passivityAbbr => 'P';

  @override
  String get caution => 'Caution';

  @override
  String get cautionAbbr => 'O';

  @override
  String get dismissal => 'Dismissal';

  @override
  String get dismissalAbbr => 'D';

  @override
  String get activityTime => 'activity time';

  @override
  String get activityTimeAbbr => 'AT';

  @override
  String get injuryTime => 'injury time';

  @override
  String get injuryTimeShort => 'IT';

  @override
  String get bleedingInjuryTimeShort => 'BT';

  @override
  String get deleteLatestAction => 'Delete latest action';

  @override
  String get pause => 'Pause';

  @override
  String get duration => 'Duration';

  @override
  String get durations => 'Durations';

  @override
  String get periodDuration => 'Period duration';

  @override
  String get breakDuration => 'Break duration';

  @override
  String get activityDuration => 'Activity duration';

  @override
  String get injuryDuration => 'Injury duration';

  @override
  String get bleedingInjuryDuration => 'Bleeding injury duration';

  @override
  String get periodCount => 'Number of periods';

  @override
  String get minimum => 'Minimum';

  @override
  String get maximum => 'Maximum';

  @override
  String get referee => 'Referee';

  @override
  String get refereeAbbr => 'REF';

  @override
  String get judge => 'Judge';

  @override
  String get matChairman => 'Mat president';

  @override
  String get timeKeeper => 'Time Keeper';

  @override
  String get transcriptionWriter => 'Transcription Writer';

  @override
  String get steward => 'Steward';

  @override
  String get prename => 'Prename';

  @override
  String get surname => 'Surname';

  @override
  String get age => 'Age';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get gender => 'Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderTransgender => 'Diverse';

  @override
  String get nationality => 'Nationality';
}
