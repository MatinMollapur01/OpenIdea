import 'app_localizations.dart';

/// The translations for Chinese - Simplified (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([super.locale = 'zh']);

  @override
  String get appTitle => 'Idea - 笔记应用程序';

  @override
  String get addNote => '添加笔记';

  @override
  String get editNote => '编辑笔记';

  @override
  String get deleteNote => '删除笔记';

  @override
  String get areYouSureDeleteNote => '您确定要删除此笔记吗？';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get save => '保存';

  @override
  String get title => '标题';

  @override
  String get content => '内容';

  @override
  String get category => '类别';

  @override
  String get tags => '标签';

  @override
  String get settings => '设置';

  @override
  String get darkMode => '深色模式';

  @override
  String get language => '语言';

  @override
  String get pinnedNotes => '置顶笔记';

  @override
  String get otherNotes => '其他笔记';

  @override
  String get search => '搜索';

  @override
  String get archivedNotes => '已归档的笔记';

    @override
  String get noteHistory => '笔记历史记录';

  @override
  String get restore => '恢复';

  @override
  String get thisNoteIsLocked => '此笔记已锁定';

  @override
  String get unlock => '解锁';

  @override
  get words => '字数';

  @override
  get characters => '字符数';

  @override
  String get setPassword => '设置密码';

  @override
  get enterPassword => '输入密码';

  @override
  String get incorrectPassword => '密码不正确';

  @override
  get tagsCommaSeparated => '标签（逗号分隔）';

  @override
  get add => '添加';

  @override
  String get pickColor => '选择颜色';

  @override
  String get done => '完成';

  @override
  String get removeColor => '移除颜色';

  @override
  String get pickBackgroundColor => '选择背景颜色';

  @override
  String get removeBackgroundColor => '移除背景颜色';

  /// Work
  @override
  String get categoryWork => '工作';
  
  /// Personal
  @override
  String get categoryPersonal => '个人';

  /// Ideas
  @override
  String get categoryIdeas => '想法';

  /// To Do
  @override
  String get categoryToDo => '待办事项';

  @override
  get noteArchived => '笔记已归档';

  @override
  get noteUnarchived => '笔记未归档';

  @override
  get lock => '锁定';
}