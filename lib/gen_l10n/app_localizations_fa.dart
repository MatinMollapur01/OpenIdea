import 'app_localizations.dart';

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([super.locale = 'fa']);

  @override
  String get appTitle => 'Idea - Note Taking App';

  @override
  String get addNote => 'افزودن یادداشت';

  @override
  String get editNote => 'ویرایش یادداشت';

  @override
  String get deleteNote => 'حذف یادداشت';

  @override
  String get areYouSureDeleteNote => 'آیا از حذف این یادداشت مطمئن هستید؟';

  @override
  String get cancel => 'لغو';

  @override
  String get delete => 'حذف';

  @override
  String get save => 'ذخیره';

  @override
  String get title => 'عنوان';

  @override
  String get content => 'محتوا';

  @override
  String get category => 'دسته بندی';

  @override
  String get tags => 'برچسب ها';

  @override
  String get settings => 'تنظیمات';

  @override
  String get darkMode => 'حالت تاریک';

  @override
  String get language => 'زبان';

  @override
  String get pinnedNotes => 'یادداشت های پین شده';

  @override
  String get otherNotes => 'سایر یادداشت ها';

  @override
  String get search => 'جستجو';

  @override
  String get archivedNotes => 'یادداشت‌های بایگانی شده';

    @override
  String get noteHistory => 'تاریخچه یادداشت';

  @override
  String get restore => 'بازیابی';

  @override
  String get thisNoteIsLocked => 'این یادداشت قفل شده است';

  @override
  String get unlock => 'باز کردن قفل';

  @override
  get words => 'کلمات';

  @override
  get characters => 'کاراکترها';

  @override
  String get setPassword => 'تنظیم رمز عبور';

  @override
  get enterPassword => 'رمز عبور را وارد کنید';

  @override
  String get incorrectPassword => 'رمز عبور نادرست است';

  @override
  get tagsCommaSeparated => 'برچسب ها (با کاما جدا شده)';

  @override
  get add => 'اضافه کردن';

  @override
  String get pickColor => 'انتخاب رنگ';

  @override
  String get done => 'انجام شد';

  @override
  String get removeColor => 'حذف رنگ';

  @override
  String get pickBackgroundColor => 'انتخاب رنگ پس زمینه';

  @override
  String get removeBackgroundColor => 'حذف رنگ پس زمینه';

  /// Work
  @override
  String get categoryWork => 'کاری';
  
  /// Personal
  @override
  String get categoryPersonal => 'شخصی';

  /// Ideas
  @override
  String get categoryIdeas => 'ایده ها';

  /// To Do
  @override
  String get categoryToDo => 'انجام دادنی';
}