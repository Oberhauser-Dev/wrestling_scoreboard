import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('de'), Locale('en')];

  /// The internationalized app name
  ///
  /// In en, this message translates to:
  /// **'Wrestling Scoreboard'**
  String get appName;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @network.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// No description provided for @scoreboard.
  ///
  /// In en, this message translates to:
  /// **'Scoreboard'**
  String get scoreboard;

  /// No description provided for @systemSetting.
  ///
  /// In en, this message translates to:
  /// **'System setting'**
  String get systemSetting;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @de_DE.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get de_DE;

  /// No description provided for @en_US.
  ///
  /// In en, this message translates to:
  /// **'English (US)'**
  String get en_US;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get themeMode;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get themeModeDark;

  /// No description provided for @fontFamily.
  ///
  /// In en, this message translates to:
  /// **'Font family'**
  String get fontFamily;

  /// No description provided for @systemFont.
  ///
  /// In en, this message translates to:
  /// **'System font'**
  String get systemFont;

  /// No description provided for @apiUrl.
  ///
  /// In en, this message translates to:
  /// **'Api-Url'**
  String get apiUrl;

  /// No description provided for @wsUrl.
  ///
  /// In en, this message translates to:
  /// **'Websocket-Url'**
  String get wsUrl;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @apiProvider.
  ///
  /// In en, this message translates to:
  /// **'API Provider'**
  String get apiProvider;

  /// No description provided for @warningOverrideDatabase.
  ///
  /// In en, this message translates to:
  /// **'This action overrides the existing database. Are you sure, you want to continue?'**
  String get warningOverrideDatabase;

  /// No description provided for @importFromApiProvider.
  ///
  /// In en, this message translates to:
  /// **'Sync with API provider'**
  String get importFromApiProvider;

  /// No description provided for @warningImportFromApiProvider.
  ///
  /// In en, this message translates to:
  /// **'This action imports objects of this organization and tries to integrate them. Are you sure, you want to continue?'**
  String get warningImportFromApiProvider;

  /// No description provided for @proposeFirstImportFromApiProvider.
  ///
  /// In en, this message translates to:
  /// **'Cannot determine the last import. Would you like import the data?'**
  String get proposeFirstImportFromApiProvider;

  /// No description provided for @proposeImportFromApiProvider.
  ///
  /// In en, this message translates to:
  /// **'The last import was on {date} at {time}. Would you like to update the data?'**
  String proposeImportFromApiProvider(DateTime date, DateTime time);

  /// No description provided for @proposeApiImportDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration for proposing an API import'**
  String get proposeApiImportDuration;

  /// No description provided for @importIncludeSubjacent.
  ///
  /// In en, this message translates to:
  /// **'Also import all subjacent data. This may take longer and fail on a timeout or if inconsistent data occurs!'**
  String get importIncludeSubjacent;

  /// No description provided for @appDataDirectory.
  ///
  /// In en, this message translates to:
  /// **'App Data Directory'**
  String get appDataDirectory;

  /// No description provided for @reportProvider.
  ///
  /// In en, this message translates to:
  /// **'Report Provider'**
  String get reportProvider;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @database.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get database;

  /// No description provided for @exportDatabase.
  ///
  /// In en, this message translates to:
  /// **'Export database'**
  String get exportDatabase;

  /// No description provided for @restoreDatabase.
  ///
  /// In en, this message translates to:
  /// **'Restore database'**
  String get restoreDatabase;

  /// No description provided for @restoreDefaultDatabase.
  ///
  /// In en, this message translates to:
  /// **'Restore default database'**
  String get restoreDefaultDatabase;

  /// No description provided for @resetDatabase.
  ///
  /// In en, this message translates to:
  /// **'Reset database'**
  String get resetDatabase;

  /// No description provided for @bellSound.
  ///
  /// In en, this message translates to:
  /// **'Bell sound'**
  String get bellSound;

  /// No description provided for @timeCountDown.
  ///
  /// In en, this message translates to:
  /// **'Count down the time'**
  String get timeCountDown;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameRequirementsWarning.
  ///
  /// In en, this message translates to:
  /// **'A username may only contain alphanumeric characters, dot (.), hyphen (-) or underscore (_).'**
  String get usernameRequirementsWarning;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @administration.
  ///
  /// In en, this message translates to:
  /// **'Administration'**
  String get administration;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @joinedOn.
  ///
  /// In en, this message translates to:
  /// **'Joined on'**
  String get joinedOn;

  /// No description provided for @privilege.
  ///
  /// In en, this message translates to:
  /// **'Privilege'**
  String get privilege;

  /// No description provided for @auth_signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get auth_signIn;

  /// No description provided for @auth_signInPrompt_phrase.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign In'**
  String get auth_signInPrompt_phrase;

  /// No description provided for @auth_signIntoAccount_phrase.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get auth_signIntoAccount_phrase;

  /// No description provided for @auth_signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get auth_signUp;

  /// No description provided for @auth_signUpPrompt_phrase.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get auth_signUpPrompt_phrase;

  /// No description provided for @auth_signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get auth_signOut;

  /// No description provided for @auth_emailPrompt_phrase.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get auth_emailPrompt_phrase;

  /// No description provided for @auth_Password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_Password;

  /// No description provided for @auth_password_save_phrase.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get auth_password_save_phrase;

  /// No description provided for @auth_change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get auth_change_password;

  /// No description provided for @auth_agreeTermsAndConditions_phrase.
  ///
  /// In en, this message translates to:
  /// **'I read and agree to Terms & Conditions'**
  String get auth_agreeTermsAndConditions_phrase;

  /// No description provided for @imprint.
  ///
  /// In en, this message translates to:
  /// **'Imprint'**
  String get imprint;

  /// No description provided for @imprint_phrase.
  ///
  /// In en, this message translates to:
  /// **'**Angaben gem. § 5 TMG:**\n\nOberhauser Dev\n\nAugust Oberhauser\n\nGroßhausener Str. 16\n\n86551 Aichach\n\n**Kontaktaufnahme:**\n\nE-Mail: info@oberhauser.dev\n\n**Umsatzsteuer-Identifikationsnummer gem. § 27 a Umsatzsteuergesetz:**\n\nDE XXX XXX XXX'**
  String get imprint_phrase;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @about_Changelog.
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get about_Changelog;

  /// No description provided for @about_Licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get about_Licenses;

  /// No description provided for @about_Application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get about_Application;

  /// No description provided for @about_Contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get about_Contact;

  /// No description provided for @about_contact_phrase.
  ///
  /// In en, this message translates to:
  /// **'August Oberhauser\n\nEmail: info@oberhauser.dev\n\nWebsite: [oberhauser.dev](https://oberhauser.dev)'**
  String get about_contact_phrase;

  /// No description provided for @about_Development.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get about_Development;

  /// No description provided for @about_development_phrase.
  ///
  /// In en, this message translates to:
  /// **'August Oberhauser\n\nEmail: info@oberhauser.dev\n\nWebsite: [oberhauser.dev](https://oberhauser.dev)'**
  String get about_development_phrase;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @optionSelect.
  ///
  /// In en, this message translates to:
  /// **'select'**
  String get optionSelect;

  /// No description provided for @noneSelected.
  ///
  /// In en, this message translates to:
  /// **'None selected'**
  String get noneSelected;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveAndGenerate.
  ///
  /// In en, this message translates to:
  /// **'Save & Generate'**
  String get saveAndGenerate;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addExisting.
  ///
  /// In en, this message translates to:
  /// **'Add existing'**
  String get addExisting;

  /// No description provided for @mergeObjectData.
  ///
  /// In en, this message translates to:
  /// **'Merge Object Data'**
  String get mergeObjectData;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @display.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get display;

  /// No description provided for @toggleFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Toggle Fullscreen'**
  String get toggleFullscreen;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @abbreviation.
  ///
  /// In en, this message translates to:
  /// **'Abbreviation'**
  String get abbreviation;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @noItems.
  ///
  /// In en, this message translates to:
  /// **'No items available.'**
  String get noItems;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @mandatoryField.
  ///
  /// In en, this message translates to:
  /// **'This is a mandatory field.'**
  String get mandatoryField;

  /// No description provided for @actionSuccessful.
  ///
  /// In en, this message translates to:
  /// **'The action was successful.'**
  String get actionSuccessful;

  /// No description provided for @noWebSocketConnection.
  ///
  /// In en, this message translates to:
  /// **'The connection to the server could not be established or was interrupted.'**
  String get noWebSocketConnection;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong :/'**
  String get errorOccurred;

  /// No description provided for @notFoundException.
  ///
  /// In en, this message translates to:
  /// **'Element was not found :/'**
  String get notFoundException;

  /// No description provided for @invalidParameterException.
  ///
  /// In en, this message translates to:
  /// **'The change was not successful, please check your input parameters.'**
  String get invalidParameterException;

  /// No description provided for @warningBoutGenerate.
  ///
  /// In en, this message translates to:
  /// **'This action overrides all existing bouts of this match. To edit single bouts, use the bout editing page. Are you sure, you want to continue?'**
  String get warningBoutGenerate;

  /// No description provided for @warningPrefilledLineup.
  ///
  /// In en, this message translates to:
  /// **'The lineup was prefilled with values from a previous match!'**
  String get warningPrefilledLineup;

  /// No description provided for @infoUseDivisionWeightClass.
  ///
  /// In en, this message translates to:
  /// **'Only define weight classes per league, if they differ from those of its division!'**
  String get infoUseDivisionWeightClass;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @networkTimeout.
  ///
  /// In en, this message translates to:
  /// **'Network timeout'**
  String get networkTimeout;

  /// No description provided for @event.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get event;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get place;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Beginning'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endDate;

  /// No description provided for @wrestlingRulesPdf.
  ///
  /// In en, this message translates to:
  /// **'https://uww.org/sites/default/files/2019-12/wrestling_rules.pdf'**
  String get wrestlingRulesPdf;

  /// No description provided for @teamMatchTranscript.
  ///
  /// In en, this message translates to:
  /// **'Transcript for Team Matches'**
  String get teamMatchTranscript;

  /// No description provided for @teamMatchScoreSheet.
  ///
  /// In en, this message translates to:
  /// **'Score sheet for Team Matches'**
  String get teamMatchScoreSheet;

  /// No description provided for @singleCompetitionTranscript.
  ///
  /// In en, this message translates to:
  /// **'Transcript for Single Competitions'**
  String get singleCompetitionTranscript;

  /// No description provided for @singleCompetitionScoreSheet.
  ///
  /// In en, this message translates to:
  /// **'Score sheet for Single Competitions'**
  String get singleCompetitionScoreSheet;

  /// No description provided for @signature.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get signature;

  /// No description provided for @pool.
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get pool;

  /// No description provided for @poolGroupCount.
  ///
  /// In en, this message translates to:
  /// **'Pool group count'**
  String get poolGroupCount;

  /// No description provided for @rank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get rank;

  /// No description provided for @cycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get cycle;

  /// No description provided for @cycles.
  ///
  /// In en, this message translates to:
  /// **'Cycles'**
  String get cycles;

  /// No description provided for @round.
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get round;

  /// No description provided for @roundType.
  ///
  /// In en, this message translates to:
  /// **'Round Type'**
  String get roundType;

  /// No description provided for @qualification.
  ///
  /// In en, this message translates to:
  /// **'Qualification'**
  String get qualification;

  /// No description provided for @contestantStatus.
  ///
  /// In en, this message translates to:
  /// **'Contestant Status'**
  String get contestantStatus;

  /// No description provided for @elimination.
  ///
  /// In en, this message translates to:
  /// **'Elimination'**
  String get elimination;

  /// No description provided for @eliminated.
  ///
  /// In en, this message translates to:
  /// **'Eliminated'**
  String get eliminated;

  /// No description provided for @injured.
  ///
  /// In en, this message translates to:
  /// **'Injured'**
  String get injured;

  /// No description provided for @disqualified.
  ///
  /// In en, this message translates to:
  /// **'Disqualified'**
  String get disqualified;

  /// No description provided for @repechage.
  ///
  /// In en, this message translates to:
  /// **'Repechage'**
  String get repechage;

  /// No description provided for @finals.
  ///
  /// In en, this message translates to:
  /// **'Final'**
  String get finals;

  /// No description provided for @semiFinals.
  ///
  /// In en, this message translates to:
  /// **'Semi-Final'**
  String get semiFinals;

  /// No description provided for @mat.
  ///
  /// In en, this message translates to:
  /// **'Mat'**
  String get mat;

  /// No description provided for @mats.
  ///
  /// In en, this message translates to:
  /// **'Mats'**
  String get mats;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @visitors.
  ///
  /// In en, this message translates to:
  /// **'Visitors'**
  String get visitors;

  /// No description provided for @numberAbbreviation.
  ///
  /// In en, this message translates to:
  /// **'No.'**
  String get numberAbbreviation;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @participantVacant.
  ///
  /// In en, this message translates to:
  /// **'vacant'**
  String get participantVacant;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @weightClass.
  ///
  /// In en, this message translates to:
  /// **'Weight Class'**
  String get weightClass;

  /// No description provided for @weightClasses.
  ///
  /// In en, this message translates to:
  /// **'Weight Classes'**
  String get weightClasses;

  /// No description provided for @weightCategory.
  ///
  /// In en, this message translates to:
  /// **'Weight Category'**
  String get weightCategory;

  /// No description provided for @weightCategories.
  ///
  /// In en, this message translates to:
  /// **'Weight Categories'**
  String get weightCategories;

  /// No description provided for @weightUnit.
  ///
  /// In en, this message translates to:
  /// **'Weight Unit'**
  String get weightUnit;

  /// No description provided for @ageCategory.
  ///
  /// In en, this message translates to:
  /// **'Age Category'**
  String get ageCategory;

  /// No description provided for @ageCategories.
  ///
  /// In en, this message translates to:
  /// **'Age Categories'**
  String get ageCategories;

  /// No description provided for @suffix.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get suffix;

  /// No description provided for @participantUnknownWeight.
  ///
  /// In en, this message translates to:
  /// **'unknown weight'**
  String get participantUnknownWeight;

  /// No description provided for @club.
  ///
  /// In en, this message translates to:
  /// **'Club'**
  String get club;

  /// No description provided for @clubs.
  ///
  /// In en, this message translates to:
  /// **'Clubs'**
  String get clubs;

  /// No description provided for @clubNumber.
  ///
  /// In en, this message translates to:
  /// **'Club number'**
  String get clubNumber;

  /// No description provided for @person.
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get person;

  /// No description provided for @persons.
  ///
  /// In en, this message translates to:
  /// **'Persons'**
  String get persons;

  /// No description provided for @membership.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get membership;

  /// No description provided for @memberships.
  ///
  /// In en, this message translates to:
  /// **'Memberships'**
  String get memberships;

  /// No description provided for @membershipNumber.
  ///
  /// In en, this message translates to:
  /// **'Membership number'**
  String get membershipNumber;

  /// No description provided for @leader.
  ///
  /// In en, this message translates to:
  /// **'Team Leader'**
  String get leader;

  /// No description provided for @leaders.
  ///
  /// In en, this message translates to:
  /// **'Team Leaders'**
  String get leaders;

  /// No description provided for @coach.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get coach;

  /// No description provided for @coaches.
  ///
  /// In en, this message translates to:
  /// **'Coaches'**
  String get coaches;

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @teams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get teams;

  /// No description provided for @teamClubAffiliation.
  ///
  /// In en, this message translates to:
  /// **'Team Club Affiliation'**
  String get teamClubAffiliation;

  /// No description provided for @participatingTeam.
  ///
  /// In en, this message translates to:
  /// **'Participating Team'**
  String get participatingTeam;

  /// No description provided for @participatingTeams.
  ///
  /// In en, this message translates to:
  /// **'Participating Teams'**
  String get participatingTeams;

  /// No description provided for @sub.
  ///
  /// In en, this message translates to:
  /// **'Sub'**
  String get sub;

  /// No description provided for @umbrellaOrganization.
  ///
  /// In en, this message translates to:
  /// **'Umbrella Organization'**
  String get umbrellaOrganization;

  /// No description provided for @organization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get organization;

  /// No description provided for @organizations.
  ///
  /// In en, this message translates to:
  /// **'Organizations'**
  String get organizations;

  /// No description provided for @division.
  ///
  /// In en, this message translates to:
  /// **'Division'**
  String get division;

  /// No description provided for @divisions.
  ///
  /// In en, this message translates to:
  /// **'Divisions'**
  String get divisions;

  /// No description provided for @league.
  ///
  /// In en, this message translates to:
  /// **'League'**
  String get league;

  /// No description provided for @leagues.
  ///
  /// In en, this message translates to:
  /// **'Leagues'**
  String get leagues;

  /// No description provided for @season.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get season;

  /// No description provided for @seasonPartition.
  ///
  /// In en, this message translates to:
  /// **'Season Partition'**
  String get seasonPartition;

  /// No description provided for @seasonPartitions.
  ///
  /// In en, this message translates to:
  /// **'Season Partitions'**
  String get seasonPartitions;

  /// No description provided for @seasonFirstHalf.
  ///
  /// In en, this message translates to:
  /// **'First Half'**
  String get seasonFirstHalf;

  /// No description provided for @seasonSecondHalf.
  ///
  /// In en, this message translates to:
  /// **'Second Half'**
  String get seasonSecondHalf;

  /// No description provided for @competition.
  ///
  /// In en, this message translates to:
  /// **'Competition'**
  String get competition;

  /// No description provided for @competitions.
  ///
  /// In en, this message translates to:
  /// **'Competitions'**
  String get competitions;

  /// No description provided for @competitionSystem.
  ///
  /// In en, this message translates to:
  /// **'Competition System'**
  String get competitionSystem;

  /// No description provided for @competitionSystems.
  ///
  /// In en, this message translates to:
  /// **'Competition Systems'**
  String get competitionSystems;

  /// No description provided for @boutDay.
  ///
  /// In en, this message translates to:
  /// **'Bout Day'**
  String get boutDay;

  /// No description provided for @boutDays.
  ///
  /// In en, this message translates to:
  /// **'Bout Days'**
  String get boutDays;

  /// No description provided for @match.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get match;

  /// No description provided for @matches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matches;

  /// No description provided for @competitionNumber.
  ///
  /// In en, this message translates to:
  /// **'Competition-ID'**
  String get competitionNumber;

  /// No description provided for @matchNumber.
  ///
  /// In en, this message translates to:
  /// **'Match-ID'**
  String get matchNumber;

  /// No description provided for @lineup.
  ///
  /// In en, this message translates to:
  /// **'Lineup'**
  String get lineup;

  /// No description provided for @lineups.
  ///
  /// In en, this message translates to:
  /// **'Lineups'**
  String get lineups;

  /// No description provided for @bout.
  ///
  /// In en, this message translates to:
  /// **'Bout'**
  String get bout;

  /// No description provided for @bouts.
  ///
  /// In en, this message translates to:
  /// **'Bouts'**
  String get bouts;

  /// No description provided for @boutNo.
  ///
  /// In en, this message translates to:
  /// **'Bout-No.'**
  String get boutNo;

  /// No description provided for @boutResult.
  ///
  /// In en, this message translates to:
  /// **'Bout Result'**
  String get boutResult;

  /// No description provided for @boutResultVfa.
  ///
  /// In en, this message translates to:
  /// **'Victory by fall'**
  String get boutResultVfa;

  /// No description provided for @boutResultVin.
  ///
  /// In en, this message translates to:
  /// **'Victory by injury'**
  String get boutResultVin;

  /// No description provided for @boutResultBothVin.
  ///
  /// In en, this message translates to:
  /// **'Both wrestlers are injured'**
  String get boutResultBothVin;

  /// No description provided for @boutResultVca.
  ///
  /// In en, this message translates to:
  /// **'Victory by cautions - the opponent received 3 cautions \"O\" due to error against the rules'**
  String get boutResultVca;

  /// No description provided for @boutResultVsu.
  ///
  /// In en, this message translates to:
  /// **'Technical superiority'**
  String get boutResultVsu;

  /// No description provided for @boutResultVpo.
  ///
  /// In en, this message translates to:
  /// **'Victory by points'**
  String get boutResultVpo;

  /// No description provided for @boutResultVfo.
  ///
  /// In en, this message translates to:
  /// **'Victory by forfeit - no show up on the mat / not attending or failing the weigh-in'**
  String get boutResultVfo;

  /// No description provided for @boutResultBothVfo.
  ///
  /// In en, this message translates to:
  /// **'None of wrestlers pass the weight or show up on the mat'**
  String get boutResultBothVfo;

  /// No description provided for @boutResultDsq.
  ///
  /// In en, this message translates to:
  /// **'Victory by disqualification of the opponent from the whole competition due to infringement of the rules'**
  String get boutResultDsq;

  /// No description provided for @boutResultBothDsq.
  ///
  /// In en, this message translates to:
  /// **'In case both wrestlers have been disqualified due to infringement of the rules'**
  String get boutResultBothDsq;

  /// No description provided for @boutResultVfaAbbr.
  ///
  /// In en, this message translates to:
  /// **'VFA'**
  String get boutResultVfaAbbr;

  /// No description provided for @boutResultVinAbbr.
  ///
  /// In en, this message translates to:
  /// **'VIN'**
  String get boutResultVinAbbr;

  /// No description provided for @boutResultBothVinAbbr.
  ///
  /// In en, this message translates to:
  /// **'2VIN'**
  String get boutResultBothVinAbbr;

  /// No description provided for @boutResultVcaAbbr.
  ///
  /// In en, this message translates to:
  /// **'VCA'**
  String get boutResultVcaAbbr;

  /// No description provided for @boutResultVsuAbbr.
  ///
  /// In en, this message translates to:
  /// **'VSU'**
  String get boutResultVsuAbbr;

  /// No description provided for @boutResultVpoAbbr.
  ///
  /// In en, this message translates to:
  /// **'VPO'**
  String get boutResultVpoAbbr;

  /// No description provided for @boutResultVfoAbbr.
  ///
  /// In en, this message translates to:
  /// **'VFO'**
  String get boutResultVfoAbbr;

  /// No description provided for @boutResultBothVfoAbbr.
  ///
  /// In en, this message translates to:
  /// **'2VFO'**
  String get boutResultBothVfoAbbr;

  /// No description provided for @boutResultDsqAbbr.
  ///
  /// In en, this message translates to:
  /// **'DSQ'**
  String get boutResultDsqAbbr;

  /// No description provided for @boutResultBothDsqAbbr.
  ///
  /// In en, this message translates to:
  /// **'2DSQ'**
  String get boutResultBothDsqAbbr;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @point.
  ///
  /// In en, this message translates to:
  /// **'Point'**
  String get point;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @technicalPoints.
  ///
  /// In en, this message translates to:
  /// **'Technical Points'**
  String get technicalPoints;

  /// No description provided for @technicalPointsAbbr.
  ///
  /// In en, this message translates to:
  /// **'TP'**
  String get technicalPointsAbbr;

  /// No description provided for @classificationPoints.
  ///
  /// In en, this message translates to:
  /// **'Classification Points'**
  String get classificationPoints;

  /// No description provided for @classificationPointsAbbr.
  ///
  /// In en, this message translates to:
  /// **'CP'**
  String get classificationPointsAbbr;

  /// No description provided for @difference.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get difference;

  /// No description provided for @participation.
  ///
  /// In en, this message translates to:
  /// **'Participation'**
  String get participation;

  /// No description provided for @participations.
  ///
  /// In en, this message translates to:
  /// **'Participations'**
  String get participations;

  /// No description provided for @boutConfig.
  ///
  /// In en, this message translates to:
  /// **'Bout configuration'**
  String get boutConfig;

  /// No description provided for @boutResultRule.
  ///
  /// In en, this message translates to:
  /// **'Bout Result Rule'**
  String get boutResultRule;

  /// No description provided for @boutResultRules.
  ///
  /// In en, this message translates to:
  /// **'Bout Result Rules'**
  String get boutResultRules;

  /// No description provided for @launchScratchBout.
  ///
  /// In en, this message translates to:
  /// **'Launch Scratch Bout'**
  String get launchScratchBout;

  /// No description provided for @red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get red;

  /// No description provided for @blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blue;

  /// No description provided for @winner.
  ///
  /// In en, this message translates to:
  /// **'Winner'**
  String get winner;

  /// No description provided for @wins.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get wins;

  /// No description provided for @loser.
  ///
  /// In en, this message translates to:
  /// **'Loser'**
  String get loser;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @wrestlingStyle.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get wrestlingStyle;

  /// No description provided for @freeStyle.
  ///
  /// In en, this message translates to:
  /// **'Freestyle'**
  String get freeStyle;

  /// No description provided for @freeStyleAbbr.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get freeStyleAbbr;

  /// No description provided for @grecoRoman.
  ///
  /// In en, this message translates to:
  /// **'Greco-Roman'**
  String get grecoRoman;

  /// No description provided for @grecoRomanAbbr.
  ///
  /// In en, this message translates to:
  /// **'G'**
  String get grecoRomanAbbr;

  /// No description provided for @verbalWarning.
  ///
  /// In en, this message translates to:
  /// **'Verbal Warning'**
  String get verbalWarning;

  /// No description provided for @verbalWarningAbbr.
  ///
  /// In en, this message translates to:
  /// **'V'**
  String get verbalWarningAbbr;

  /// No description provided for @passivity.
  ///
  /// In en, this message translates to:
  /// **'Passivity'**
  String get passivity;

  /// No description provided for @passivityAbbr.
  ///
  /// In en, this message translates to:
  /// **'P'**
  String get passivityAbbr;

  /// No description provided for @caution.
  ///
  /// In en, this message translates to:
  /// **'Caution'**
  String get caution;

  /// No description provided for @cautionAbbr.
  ///
  /// In en, this message translates to:
  /// **'O'**
  String get cautionAbbr;

  /// No description provided for @dismissal.
  ///
  /// In en, this message translates to:
  /// **'Dismissal'**
  String get dismissal;

  /// No description provided for @dismissalAbbr.
  ///
  /// In en, this message translates to:
  /// **'D'**
  String get dismissalAbbr;

  /// No description provided for @activityTime.
  ///
  /// In en, this message translates to:
  /// **'activity time'**
  String get activityTime;

  /// No description provided for @activityTimeAbbr.
  ///
  /// In en, this message translates to:
  /// **'AT'**
  String get activityTimeAbbr;

  /// No description provided for @injuryTime.
  ///
  /// In en, this message translates to:
  /// **'injury time'**
  String get injuryTime;

  /// No description provided for @injuryTimeShort.
  ///
  /// In en, this message translates to:
  /// **'IT'**
  String get injuryTimeShort;

  /// No description provided for @bleedingInjuryTimeShort.
  ///
  /// In en, this message translates to:
  /// **'BT'**
  String get bleedingInjuryTimeShort;

  /// No description provided for @deleteLatestAction.
  ///
  /// In en, this message translates to:
  /// **'Delete latest action'**
  String get deleteLatestAction;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @durations.
  ///
  /// In en, this message translates to:
  /// **'Durations'**
  String get durations;

  /// No description provided for @periodDuration.
  ///
  /// In en, this message translates to:
  /// **'Period duration'**
  String get periodDuration;

  /// No description provided for @breakDuration.
  ///
  /// In en, this message translates to:
  /// **'Break duration'**
  String get breakDuration;

  /// No description provided for @activityDuration.
  ///
  /// In en, this message translates to:
  /// **'Activity duration'**
  String get activityDuration;

  /// No description provided for @injuryDuration.
  ///
  /// In en, this message translates to:
  /// **'Injury duration'**
  String get injuryDuration;

  /// No description provided for @bleedingInjuryDuration.
  ///
  /// In en, this message translates to:
  /// **'Bleeding injury duration'**
  String get bleedingInjuryDuration;

  /// No description provided for @periodCount.
  ///
  /// In en, this message translates to:
  /// **'Number of periods'**
  String get periodCount;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @minimum.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get minimum;

  /// No description provided for @maximum.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get maximum;

  /// No description provided for @referee.
  ///
  /// In en, this message translates to:
  /// **'Referee'**
  String get referee;

  /// No description provided for @refereeAbbr.
  ///
  /// In en, this message translates to:
  /// **'REF'**
  String get refereeAbbr;

  /// No description provided for @judge.
  ///
  /// In en, this message translates to:
  /// **'Judge'**
  String get judge;

  /// No description provided for @matChairman.
  ///
  /// In en, this message translates to:
  /// **'Mat president'**
  String get matChairman;

  /// No description provided for @timeKeeper.
  ///
  /// In en, this message translates to:
  /// **'Time Keeper'**
  String get timeKeeper;

  /// No description provided for @transcriptionWriter.
  ///
  /// In en, this message translates to:
  /// **'Transcription Writer'**
  String get transcriptionWriter;

  /// No description provided for @steward.
  ///
  /// In en, this message translates to:
  /// **'Steward'**
  String get steward;

  /// No description provided for @prename.
  ///
  /// In en, this message translates to:
  /// **'Prename'**
  String get prename;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderTransgender.
  ///
  /// In en, this message translates to:
  /// **'Diverse'**
  String get genderTransgender;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
