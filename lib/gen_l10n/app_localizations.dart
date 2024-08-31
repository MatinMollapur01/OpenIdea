import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:openidea/gen_l10n/app_localizations_ar.dart';
import 'package:openidea/gen_l10n/app_localizations_az.dart';
import 'package:openidea/gen_l10n/app_localizations_es.dart';
import 'package:openidea/gen_l10n/app_localizations_fa.dart';
import 'package:openidea/gen_l10n/app_localizations_ru.dart';
import 'package:openidea/gen_l10n/app_localizations_tr.dart';
import 'package:openidea/gen_l10n/app_localizations_zh.dart';
import 'package:intl/intl.dart' as intl;

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
/// import 'gen_l10n/app_localizations.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
    Locale('tr'),
    Locale('az'),
    Locale('es'),
    Locale('ar'),
    Locale('zh'),
    Locale('ru'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Idea - Note Taking App'**
  String get appTitle;

  /// Label for adding a new note
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// Label for editing a note
  ///
  /// In en, this message translates to:
  /// **'Edit Note'**
  String get editNote;

  /// Label for deleting a note
  ///
  /// In en, this message translates to:
  /// **'Delete Note'**
  String get deleteNote;

  /// Confirmation message for deleting a note
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this note?'**
  String get areYouSureDeleteNote;

  /// Label for cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Label for delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Label for save action
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Label for note title
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Label for note content
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// Label for note category
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Label for note tags
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// Label for settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for dark mode setting
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Label for language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Label for pinned notes section
  ///
  /// In en, this message translates to:
  /// **'Pinned Notes'**
  String get pinnedNotes;

  /// Label for other notes section
  ///
  /// In en, this message translates to:
  /// **'Other Notes'**
  String get otherNotes;

  /// Label for search functionality
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Label for archived notes
  ///
  /// In en, this message translates to:
  /// **'Archived Notes'**
  String get archivedNotes;

  /// Label for note history
  ///
  /// In en, this message translates to:
  /// **'Note History'**
  String get noteHistory;

  /// Label for restoring a note
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// Label for note lock
  ///
  /// In en, this message translates to:
  /// **'This note is locked'**
  String get thisNoteIsLocked;

  /// Label for unlocking a note
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  String get lock;

  get words;

  get characters;

  String get setPassword;

  get enterPassword;

  String get incorrectPassword;

  get tagsCommaSeparated;

  get add;

  String get pickColor;

  String get done;

  String get removeColor;

  String get pickBackgroundColor;

  String get removeBackgroundColor;
  
  ///** Work
  String get categoryWork;
  
  ///** Personal
  String get categoryPersonal;

  ///** Ideas
  String get categoryIdeas;

  ///** To Do
  String get categoryToDo;

  /// Label for note archived
  get noteArchived;

  /// Label for note unarchived
  get noteUnarchived;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fa', 'tr', 'az', 'es', 'ar', 'zh', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fa': return AppLocalizationsFa();
    case 'tr': return AppLocalizationsTr();
    case 'az': return AppLocalizationsAz();
    case 'es': return AppLocalizationsEs();
    case 'ar': return AppLocalizationsAr();
    case 'zh': return AppLocalizationsZh();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
