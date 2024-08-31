import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Idea - Note Taking App';

  @override
  String get addNote => 'Add Note';

  @override
  String get editNote => 'Edit Note';

  @override
  String get deleteNote => 'Delete Note';

  @override
  String get areYouSureDeleteNote => 'Are you sure you want to delete this note?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get title => 'Title';

  @override
  String get content => 'Content';

  @override
  String get category => 'Category';

  @override
  String get tags => 'Tags';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get pinnedNotes => 'Pinned Notes';

  @override
  String get otherNotes => 'Other Notes';

  @override
  String get search => 'Search';

  @override
  String get archivedNotes => 'Archived Notes';

    @override
  String get noteHistory => 'Note History';

  @override
  String get restore => 'Restore';

  @override
  String get thisNoteIsLocked => 'This note is locked';

  @override
  String get unlock => 'Unlock';

  @override
  get words => 'Words';

  @override
  get characters => 'Characters';

  @override
  String get setPassword => 'Set Password';

  @override
  get enterPassword => 'Enter Password';

  @override
  String get incorrectPassword => 'Incorrect Password';

  @override
  get tagsCommaSeparated => 'Tags (comma separated)';

  @override
  get add => 'Add';

  @override
  String get pickColor => 'Pick Color';

  @override
  String get done => 'Done';

  @override
  String get removeColor => 'Remove Color';

  @override
  String get pickBackgroundColor => 'Pick Background Color';

  @override
  String get removeBackgroundColor => 'Remove Background Color';

  /// Work
  @override
  String get categoryWork => 'Work';
  
  /// Personal
  @override
  String get categoryPersonal => 'Personal';

  /// Ideas
  @override
  String get categoryIdeas => 'Ideas';

  /// To Do
  @override
  String get categoryToDo => 'To Do'; 
}
