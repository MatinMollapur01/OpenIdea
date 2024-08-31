import 'app_localizations.dart';

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Идея - Приложение для заметок';

  @override
  String get addNote => 'Добавить заметку';

  @override
  String get editNote => 'Редактировать заметку';

  @override
  String get deleteNote => 'Удалить заметку';

  @override
  String get areYouSureDeleteNote => 'Вы уверены, что хотите удалить эту заметку?';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get save => 'Сохранить';

  @override
  String get title => 'Заголовок';

  @override
  String get content => 'Содержание';

  @override
  String get category => 'Категория';

  @override
  String get tags => 'Теги';

  @override
  String get settings => 'Настройки';

  @override
  String get darkMode => 'Темный режим';

  @override
  String get language => 'Язык';

  @override
  String get pinnedNotes => 'Закрепленные заметки';

  @override
  String get otherNotes => 'Другие заметки';

  @override
  String get search => 'Поиск';

  @override
  String get archivedNotes => 'Архивированные заметки';

    @override
  String get noteHistory => 'История заметок';

  @override
  String get restore => 'Восстановить';

  @override
  String get thisNoteIsLocked => 'Эта заметка заблокирована';

  @override
  String get unlock => 'Разблокировать';

  @override
  get words => 'Слова';

  @override
  get characters => 'Символы';

  @override
  String get setPassword => 'Установить пароль';

  @override
  get enterPassword => 'Введите пароль';

  @override
  String get incorrectPassword => 'Неверный пароль';

  @override
  get tagsCommaSeparated => 'Теги (через запятую)';

  @override
  get add => 'Добавить';

  @override
  String get pickColor => 'Выбрать цвет';

  @override
  String get done => 'Готово';

  @override
  String get removeColor => 'Удалить цвет';

  @override
  String get pickBackgroundColor => 'Выбрать цвет фона';

  @override
  String get removeBackgroundColor => 'Удалить цвет фона';

  /// Work
  @override
  String get categoryWork => 'Работа';
  
  /// Personal
  @override
  String get categoryPersonal => 'Личное';

  /// Ideas
  @override
  String get categoryIdeas => 'Идеи';

  /// To Do
  @override
  String get categoryToDo => 'Список дел'; 
}