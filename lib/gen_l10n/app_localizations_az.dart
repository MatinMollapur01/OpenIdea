import 'app_localizations.dart';

/// The translations for Azerbaijani (`az`).
class AppLocalizationsAz extends AppLocalizations {
  AppLocalizationsAz([String locale = 'az']) : super(locale);

  @override
  String get appTitle => 'Idea - Note Taking App';

  @override
  String get addNote => 'Qeyd əlavə et';

  @override
  String get editNote => 'Qeydi redaktə et';

  @override
  String get deleteNote => 'Qeydi sil';

  @override
  String get areYouSureDeleteNote => 'Bu qeydi silmək istədiyinizdən əminsiniz?';

  @override
  String get cancel => 'Ləğv et';

  @override
  String get delete => 'Sil';

  @override
  String get save => 'Yadda saxla';

  @override
  String get title => 'Başlıq';

  @override
  String get content => 'Məzmun';

  @override
  String get category => 'Kateqoriya';

  @override
  String get tags => 'Etiketlər';

  @override
  String get settings => 'Ayarlar';

  @override
  String get darkMode => 'Qaranlıq rejim';

  @override
  String get language => 'Dil';

  @override
  String get pinnedNotes => 'Sancaqlanmış qeydlər';

  @override
  String get otherNotes => 'Digər qeydlər';

  @override
  String get search => 'Axtar';

  @override
  String get archivedNotes => 'Arxivləşdirilmiş Qeydlər';

    @override
  String get noteHistory => 'Qeyd Tarixçəsi';

  @override
  String get restore => 'Bərpa et';

  @override
  String get thisNoteIsLocked => 'Bu qeyd kilidlidir';

  @override
  String get unlock => 'Kilidini aç';

  @override
  get words => 'Sözlər';

  @override
  get characters => 'Simvollar';

  @override
  String get setPassword => 'Şifrə təyin et';

  @override
  get enterPassword => 'Şifrəni daxil edin';

  @override
  String get incorrectPassword => 'Yanlış şifrə';

  @override
  get tagsCommaSeparated => 'Etiketlər (vergüllə ayrılmış)';

  @override
  get add => 'Əlavə et';

  @override
  String get pickColor => 'Rəng seçin';

  @override
  String get done => 'Bitdi';

  @override
  String get removeColor => 'Rəngi sil';

  @override
  String get pickBackgroundColor => 'Fon rəngi seçin';

  @override
  String get removeBackgroundColor => 'Fon rəngini sil';

  /// Work
  @override
  String get categoryWork => 'İş';
  
  /// Personal
  @override
  String get categoryPersonal => 'Şəxsi';

  /// Ideas
  @override
  String get categoryIdeas => 'Ideyalar';

  /// To Do
  @override
  String get categoryToDo => 'Ediləcək işlər'; 
}