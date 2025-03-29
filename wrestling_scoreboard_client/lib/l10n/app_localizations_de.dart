// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Ringkampf-Anzeige';

  @override
  String get start => 'Start';

  @override
  String get home => 'Heim';

  @override
  String get guest => 'Gast';

  @override
  String get explore => 'Erkunden';

  @override
  String get more => 'Mehr';

  @override
  String get settings => 'Einstellungen';

  @override
  String get general => 'Allgemein';

  @override
  String get network => 'Netzwerk';

  @override
  String get scoreboard => 'Anzeigetafel';

  @override
  String get systemSetting => 'Systemeinstellung';

  @override
  String get language => 'Sprache';

  @override
  String get de_DE => 'Deutsch';

  @override
  String get en_US => 'Englisch (US)';

  @override
  String get themeMode => 'Themen Modus';

  @override
  String get themeModeLight => 'Heller Modus';

  @override
  String get themeModeDark => 'Dunkler Modus';

  @override
  String get fontFamily => 'Schriftart';

  @override
  String get systemFont => 'System-Schrift';

  @override
  String get apiUrl => 'Api-Url';

  @override
  String get wsUrl => 'Websocket-Url';

  @override
  String get services => 'Dienste';

  @override
  String get apiProvider => 'API-Anbieter';

  @override
  String get warningOverrideDatabase => 'Diese Aktion überschreibt die existierende Datenbank. Bist du sicher, dass du fortfahren möchtest?';

  @override
  String get importFromApiProvider => 'Synchronisiere mit API-Anbieter';

  @override
  String get warningImportFromApiProvider => 'Diese Aktion importiert Objekte dieser Organisation und versucht diese zu integrieren. Bist du sicher, dass du fortfahren möchtest?';

  @override
  String get proposeFirstImportFromApiProvider => 'Der letzte Import konnte nicht bestimmt werden. Möchtest du die Daten importieren?';

  @override
  String proposeImportFromApiProvider(DateTime date, DateTime time) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);
    final intl.DateFormat timeDateFormat = intl.DateFormat.Hm(localeName);
    final String timeString = timeDateFormat.format(time);

    return 'Der letzte Import war am $dateString um $timeString Uhr. Möchtest du die Daten aktualisieren?';
  }

  @override
  String get proposeApiImportDuration => 'Dauer für den Vorschlag eines API-Imports';

  @override
  String get importIncludeSubjacent => 'Importiere auch alle darunderliegenden Daten. Dies kann länger dauern und bei Zeitüberschreitung oder inkonsistenten Daten fehlschlagen!';

  @override
  String get reportProvider => 'Report-Anbieter';

  @override
  String get database => 'Datenbank';

  @override
  String get exportDatabase => 'Datenbank exportieren';

  @override
  String get restoreDatabase => 'Datenbank wiederherstellen';

  @override
  String get restoreDefaultDatabase => 'Standard-Datenbank wiederherstellen';

  @override
  String get resetDatabase => 'Datenbank zurücksetzen';

  @override
  String get bellSound => 'Glocken-Sound';

  @override
  String get timeCountDown => 'Zähle die Zeit herunter';

  @override
  String get profile => 'Profil';

  @override
  String get username => 'Nutzername';

  @override
  String get usernameRequirementsWarning => 'Ein Benutzername darf nur alphanumerische Zeichen, Punkt (.), Bindestrich (-) oder Unterstrich (_) enthalten.';

  @override
  String get password => 'Passwort';

  @override
  String get email => 'E-Mail';

  @override
  String get administration => 'Administration';

  @override
  String get users => 'Nutzer';

  @override
  String get user => 'Nutzer';

  @override
  String get joinedOn => 'Beigetreten am';

  @override
  String get privilege => 'Berechtigung';

  @override
  String get auth_signIn => 'Anmelden';

  @override
  String get auth_signInPrompt_phrase => 'Haben Sie bereits ein Konto? Hier anmelden';

  @override
  String get auth_signIntoAccount_phrase => 'Melden Sie sich an';

  @override
  String get auth_signUp => 'Registrieren';

  @override
  String get auth_signUpPrompt_phrase => 'Noch kein Konto? Hier registrieren';

  @override
  String get auth_signOut => 'Abmelden';

  @override
  String get auth_emailPrompt_phrase => 'Bitte geben Sie Ihre E-Mail-Adresse ein';

  @override
  String get auth_Password => 'Passwort';

  @override
  String get auth_password_save_phrase => 'Passwort speichern';

  @override
  String get auth_change_password => 'Password ändern';

  @override
  String get auth_agreeTermsAndConditions_phrase => 'Ich habe die Allgemeinen Geschäftsbedingungen gelesen und stimme ihnen zu';

  @override
  String get imprint => 'Impressum';

  @override
  String get imprint_phrase => '**Angaben gem. § 5 TMG:**\n\nOberhauser Dev\n\nAugust Oberhauser\n\nGroßhausener Str. 16\n\n86551 Aichach\n\n**Kontaktaufnahme:**\n\nE-Mail: info@oberhauser.dev\n\n**Umsatzsteuer-Identifikationsnummer gem. § 27 a Umsatzsteuergesetz:**\n\nDE XXX XXX XXX';

  @override
  String get about => 'Über';

  @override
  String get about_Changelog => 'Änderungsprotokoll';

  @override
  String get about_Licenses => 'Lizenzen';

  @override
  String get about_Application => 'App';

  @override
  String get about_Contact => 'Kontakt';

  @override
  String get about_contact_phrase => 'August Oberhauser\n\nEmail: info@oberhauser.dev\n\nWebsite: [oberhauser.dev](https://oberhauser.dev)';

  @override
  String get about_Development => 'Entwicklung';

  @override
  String get about_development_phrase => 'Oberhauser Dev\n\nEmail: info@oberhauser.dev\n\nWebsite: [oberhauser.dev](https://oberhauser.dev)';

  @override
  String get privacy_policy => 'Datenschutzerklärung';

  @override
  String get optionSelect => 'Auswählen';

  @override
  String get noneSelected => 'Nichts ausgewählt';

  @override
  String get create => 'Erstellen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get save => 'Speichern';

  @override
  String get saveAndGenerate => 'Speichern & Generieren';

  @override
  String get add => 'Hinzufügen';

  @override
  String get addExisting => 'Existierende hinzufügen';

  @override
  String get mergeObjectData => 'Objekt-Daten zusammenführen';

  @override
  String get remove => 'Entfernen';

  @override
  String get previous => 'Vorherige(r)';

  @override
  String get next => 'Nächste(r)';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get ok => 'OK';

  @override
  String get info => 'Info';

  @override
  String get details => 'Details';

  @override
  String get display => 'Anzeige';

  @override
  String get toggleFullscreen => 'Vollbildschirm umschalten';

  @override
  String get favorite => 'Favorit';

  @override
  String get favorites => 'Favoriten';

  @override
  String get name => 'Name';

  @override
  String get description => 'Beschreibung';

  @override
  String get comment => 'Kommentar';

  @override
  String get abbreviation => 'Abkürzung';

  @override
  String get position => 'Position';

  @override
  String get noItems => 'Keine Einträge vorhanden.';

  @override
  String get optional => 'Optional';

  @override
  String get mandatoryField => 'Das ist ein Pflichtfeld.';

  @override
  String get actionSuccessful => 'Die Aktion war erfolgreich.';

  @override
  String get noWebSocketConnection => 'Die Verbindung zum Server konnte nicht aufgebaut werden oder wurde unterbrochen.';

  @override
  String get errorOccurred => 'Etwas ist schief gelaufen :/';

  @override
  String get notFoundException => 'Element wurde nicht gefunden :/';

  @override
  String get invalidParameterException => 'Die Änderung war nicht erfolgreich, bitte überprüfe deine Eingabeparameter.';

  @override
  String get warningBoutGenerate => 'Diese Aktion überschreibt alle existierenden Kämpfe dieser Begegnung. Um einzelne Kämpfe zu bearbeiten, nutze die Seite zur Kampf-Bearbeitung. Bist du sicher, dass du fortfahren möchtest?';

  @override
  String get warningPrefilledLineup => 'Die Aufstellung wurde mit Werten einer vorherigen Begegnung vorausgefüllt!';

  @override
  String get infoUseDivisionWeightClass => 'Definiere Gewichtsklassen pro Liga nur, wenn sie sich von denen der zugehörigen Spielklasse unterscheiden!';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get networkTimeout => 'Netzwerk-Timeout';

  @override
  String get event => 'Veranstaltung';

  @override
  String get place => 'Ort';

  @override
  String get date => 'Datum';

  @override
  String get minutes => 'Minuten';

  @override
  String get seconds => 'Sekunden';

  @override
  String get startDate => 'Beginn';

  @override
  String get endDate => 'Ende';

  @override
  String get wrestlingRulesPdf => 'https://www.ringen.de/wp-content/uploads/2019/01/Internationales-Regelwerk_Januar-2019_.pdf';

  @override
  String get teamMatchTranscript => 'Protokoll für Mannschaftskämpfe';

  @override
  String get teamMatchScoreSheet => 'Punktzettel für Mannschaftskämpfe';

  @override
  String get singleCompetitionTranscript => 'Protokoll für Einzelmeisterschaften';

  @override
  String get singleCompetitionScoreSheet => 'Punktzettel für Einzelmeisterschaften';

  @override
  String get signature => 'Unterschrift';

  @override
  String get pool => 'Pool';

  @override
  String get round => 'Runde';

  @override
  String get mat => 'Matte';

  @override
  String get mats => 'Matten';

  @override
  String get status => 'Status';

  @override
  String get visitors => 'Besucher';

  @override
  String get numberAbbreviation => 'Nr.';

  @override
  String get total => 'Gesamt';

  @override
  String get participantVacant => 'unbesetzt';

  @override
  String get weight => 'Gewicht';

  @override
  String get weightClass => 'Gewichtsklasse';

  @override
  String get weightClasses => 'Gewichtsklassen';

  @override
  String get weightCategory => 'Gewichts-Kategorie';

  @override
  String get weightCategories => 'Gewichts-Kategorien';

  @override
  String get weightUnit => 'Gewichtseinheit';

  @override
  String get ageCategory => 'Age Category';

  @override
  String get ageCategories => 'Age Categories';

  @override
  String get suffix => 'Kategorie';

  @override
  String get participantUnknownWeight => 'Gewicht unbekannt';

  @override
  String get club => 'Verein';

  @override
  String get clubs => 'Vereine';

  @override
  String get clubNumber => 'Vereinsnummer';

  @override
  String get person => 'Person';

  @override
  String get persons => 'Personen';

  @override
  String get membership => 'Mitgliedschaft';

  @override
  String get memberships => 'Mitgliedschaften';

  @override
  String get membershipNumber => 'Mitgliedsnummer';

  @override
  String get leader => 'Mannschaftsführer';

  @override
  String get leaders => 'Mannschaftsführer';

  @override
  String get coach => 'Trainer';

  @override
  String get coaches => 'Trainer';

  @override
  String get team => 'Mannschaft';

  @override
  String get teams => 'Mannschaften';

  @override
  String get teamClubAffiliation => 'Team-Club-Zugehörigkeit';

  @override
  String get participatingTeam => 'Teilnehmende Mannschaft';

  @override
  String get participatingTeams => 'Teilnehmende Mannschaften';

  @override
  String get sub => 'Unter';

  @override
  String get umbrellaOrganization => 'Dachorganisation';

  @override
  String get organization => 'Organisation';

  @override
  String get organizations => 'Organisationen';

  @override
  String get division => 'Spielklasse';

  @override
  String get divisions => 'Spielklassen';

  @override
  String get league => 'Liga';

  @override
  String get leagues => 'Ligen';

  @override
  String get season => 'Saison';

  @override
  String get seasonPartition => 'Saison-Abschnitt';

  @override
  String get seasonPartitions => 'Season-Abschnitte';

  @override
  String get seasonFirstHalf => 'Hinrunde';

  @override
  String get seasonSecondHalf => 'Rückrunde';

  @override
  String get competition => 'Turnier';

  @override
  String get competitions => 'Turniere';

  @override
  String get boutDay => 'Kampftag';

  @override
  String get boutDays => 'Kampftage';

  @override
  String get match => 'Begegnung';

  @override
  String get matches => 'Begegnungen';

  @override
  String get competitionNumber => 'Turnier-ID';

  @override
  String get matchNumber => 'Begegnungs-ID / Kampf-ID';

  @override
  String get lineup => 'Aufstellung';

  @override
  String get lineups => 'Aufstellungen';

  @override
  String get bout => 'Kampf';

  @override
  String get bouts => 'Kämpfe';

  @override
  String get boutNo => 'Kampf-Nr.';

  @override
  String get boutResult => 'Kampfergebnis';

  @override
  String get boutResultVfa => 'Schultersieg';

  @override
  String get boutResultVin => 'Aufgabesieg wegen Verletzung';

  @override
  String get boutResultBothVin => 'Beide Ringer sind verletzt';

  @override
  String get boutResultVca => 'Sieger durch 3 Verwarnungen / Regelwidrigkeit des Gegners';

  @override
  String get boutResultVsu => 'Technische Überlegenheit';

  @override
  String get boutResultVpo => 'Punktsieg';

  @override
  String get boutResultVfo => 'Sieger durch Ausschluss des Gegners vom Wettkampf wegen Nichtantritt / Übergewicht / Untergewicht';

  @override
  String get boutResultBothVfo => 'Keiner der Ringer ist erschienen oder erfüllte das Gewicht';

  @override
  String get boutResultDsq => 'Sieger durch Ausschluss des Gegners vom Wettkampf wegen Unsportlichkeit / Tätlichkeit';

  @override
  String get boutResultBothDsq => 'Beide Ringer disqualifiziert wegen Unsportlichkeit / Regelwidrigkeit';

  @override
  String get boutResultVfaAbbr => 'SS';

  @override
  String get boutResultVinAbbr => 'AS';

  @override
  String get boutResultBothVinAbbr => 'AS2';

  @override
  String get boutResultVcaAbbr => 'DV';

  @override
  String get boutResultVsuAbbr => 'TÜ';

  @override
  String get boutResultVpoAbbr => 'PS';

  @override
  String get boutResultVfoAbbr => 'DN';

  @override
  String get boutResultBothVfoAbbr => 'DN2';

  @override
  String get boutResultDsqAbbr => 'DQ';

  @override
  String get boutResultBothDsqAbbr => 'DQ2';

  @override
  String get actions => 'Aktionen';

  @override
  String get point => 'Punkt';

  @override
  String get points => 'Punkte';

  @override
  String get technicalPoints => 'Technische Punkte';

  @override
  String get classificationPoints => 'Kampfwertungspunkte';

  @override
  String get difference => 'Differenz';

  @override
  String get participations => 'Teilnahmen';

  @override
  String get boutConfig => 'Kampf-Konfiguration';

  @override
  String get boutResultRule => 'Kampfergebnisregel';

  @override
  String get boutResultRules => 'Kampfergebnisregeln';

  @override
  String get red => 'Red';

  @override
  String get blue => 'Blue';

  @override
  String get winner => 'Gewinner';

  @override
  String get loser => 'Verlierer';

  @override
  String get result => 'Ergebnis';

  @override
  String get wrestlingStyle => 'Stilart';

  @override
  String get freeStyle => 'Freistil';

  @override
  String get freeStyleAbbr => 'F';

  @override
  String get grecoRoman => 'Gr.-Römisch';

  @override
  String get grecoRomanAbbr => 'G';

  @override
  String get verbalWarning => 'Verbale Ermahnung';

  @override
  String get verbalWarningAbbr => 'V';

  @override
  String get passivity => 'Passivität';

  @override
  String get passivityAbbr => 'P';

  @override
  String get caution => 'Verwarnung';

  @override
  String get cautionAbbr => 'O';

  @override
  String get dismissal => 'Ausschluss';

  @override
  String get dismissalAbbr => 'D';

  @override
  String get activityTime => 'Aktivitätszeit';

  @override
  String get activityTimeAbbr => 'AZ';

  @override
  String get injuryTime => 'Verletzungszeit';

  @override
  String get injuryTimeShort => 'VZ';

  @override
  String get bleedingInjuryTimeShort => 'BZ';

  @override
  String get deleteLatestAction => 'Lösche letzte Aktion';

  @override
  String get pause => 'Pausieren';

  @override
  String get duration => 'Dauer';

  @override
  String get durations => 'Zeiten';

  @override
  String get periodDuration => 'Dauer des Kampfabschnittes';

  @override
  String get breakDuration => 'Dauer der Pause';

  @override
  String get activityDuration => 'Dauer der Aktivitätszeit';

  @override
  String get injuryDuration => 'Dauer der Verletzungszeit';

  @override
  String get bleedingInjuryDuration => 'Dauer der Verletzungszeit mit Blut';

  @override
  String get periodCount => 'Anzahl der Kampfabschnitte';

  @override
  String get days => 'Days';

  @override
  String get minimum => 'Minimum';

  @override
  String get maximum => 'Maximum';

  @override
  String get referee => 'Kampfrichter';

  @override
  String get refereeAbbr => 'SR';

  @override
  String get judge => 'Punktrichter';

  @override
  String get matChairman => 'Mattenpräsident';

  @override
  String get timeKeeper => 'Zeitnehmer';

  @override
  String get transcriptionWriter => 'Protokollführer';

  @override
  String get steward => 'Ordner';

  @override
  String get prename => 'Vorname';

  @override
  String get surname => 'Nachname';

  @override
  String get age => 'Alter';

  @override
  String get dateOfBirth => 'Geburtsdatum';

  @override
  String get gender => 'Geschlecht';

  @override
  String get genderMale => 'Männlich';

  @override
  String get genderFemale => 'Weiblich';

  @override
  String get genderTransgender => 'Divers';

  @override
  String get nationality => 'Nationalität';
}
