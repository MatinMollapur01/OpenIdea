import 'app_localizations.dart';

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'OpenIdea';

  @override
  String get addNote => 'إضافة ملاحظة';

  @override
  String get editNote => 'تحرير ملاحظة';

  @override
  String get deleteNote => 'حذف ملاحظة';

  @override
  String get areYouSureDeleteNote => 'هل أنت متأكد أنك تريد حذف هذه الملاحظة؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get save => 'حفظ';

  @override
  String get title => 'العنوان';

  @override
  String get content => 'المحتوى';

  @override
  String get category => 'الفئة';

  @override
  String get tags => 'العلامات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get language => 'اللغة';

  @override
  String get pinnedNotes => 'الملاحظات المثبتة';

  @override
  String get otherNotes => 'ملاحظات أخرى';

  @override
  String get search => 'بحث';

  @override
  String get archivedNotes => 'الملاحظات المؤرشفة';

    @override
  String get noteHistory => 'تاريخ الملاحظة';

  @override
  String get restore => 'استعادة';

  @override
  String get thisNoteIsLocked => 'هذه الملاحظة مقفلة';

  @override
  String get unlock => 'فتح القفل';

  @override
  get words => 'الكلمات';

  @override
  get characters => 'الأحرف';

  @override
  String get setPassword => 'تعيين كلمة المرور';

  @override
  get enterPassword => 'أدخل كلمة المرور';

  @override
  String get incorrectPassword => 'كلمة مرور غير صحيحة';

  @override
  get tagsCommaSeparated => 'العلامات (مفصولة بفاصلات)';

  @override
  get add => 'إضافة';

  @override
  String get pickColor => 'اختيار اللون';

  @override
  String get done => 'تم';

  @override
  String get removeColor => 'إزالة اللون';

  @override
  String get pickBackgroundColor => 'اختيار لون الخلفية';

  @override
  String get removeBackgroundColor => 'إزالة لون الخلفية';

  /// Work
  @override
  String get categoryWork => 'عمل';
  
  /// Personal
  @override
  String get categoryPersonal => 'شخصي';

  /// Ideas
  @override
  String get categoryIdeas => 'أفكار';

  /// To Do
  @override
  String get categoryToDo => 'للعمل'; 

  @override
  get noteArchived => 'ملاحظة بعنوان';

  @override
  get noteUnarchived => 'ملاحظة بعنوان';

  @override
  get lock => 'قفل';
}