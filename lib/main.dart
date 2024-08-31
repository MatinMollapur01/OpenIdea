import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:idea/database_helper.dart';
import 'add_edit_note_screen.dart' as add_edit;
import 'note_detail_screen.dart' as detail;
import 'settings_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'archived_notes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idea/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getApplicationDocumentsDirectory(); // This line ensures path_provider is initialized
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = true;
  String _currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
      _currentLanguage = prefs.getString('language') ?? 'en';
    });
  }

  void toggleDarkMode(bool value) async {
    setState(() {
      _isDarkMode = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  void changeLanguage(String languageCode) async {
    setState(() {
      _currentLanguage = languageCode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    
    // Rebuild the entire app
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Idea',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
          surface: _isDarkMode ? const Color(0xFF1C1919) : const Color(0xFFD9D9D9),
          onSurface: _isDarkMode ? const Color(0xFFD9D9D9) : const Color(0xFF1C1919),
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(_currentLanguage),
      home: IdeaHomePage(
        isDarkMode: _isDarkMode,
        toggleDarkMode: toggleDarkMode,
        changeLanguage: changeLanguage,
        currentLanguage: _currentLanguage,
      ),
    );
  }
}

class IdeaHomePage extends StatefulWidget {
  const IdeaHomePage({
    super.key,
    required this.isDarkMode,
    required this.toggleDarkMode,
    required this.changeLanguage,
    required this.currentLanguage,
  });

  final bool isDarkMode;
  final Function(bool) toggleDarkMode;
  final Function(String) changeLanguage;
  final String currentLanguage;

  @override
  State<IdeaHomePage> createState() => _IdeaHomePageState();
}

class _IdeaHomePageState extends State<IdeaHomePage> {
  List<Note> _notes = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    List<Note> notes = await DatabaseHelper.instance.getNotes();
    setState(() {
      _notes = notes.where((note) => !note.isArchived).toList();
    });
  }

  void _addOrEditNote({Note? noteToEdit}) async {
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (context) => add_edit.AddEditNoteScreen(noteToEdit: noteToEdit),
      ),
    );

    if (result != null) {
      setState(() {
        if (noteToEdit == null) {
          _notes.insert(0, result);
        } else {
          final index = _notes.indexWhere((note) => note.id == noteToEdit.id);
          if (index != -1) {
            _notes[index] = result;
          }
        }
      });
      _loadNotes();
    }
  }

  void _deleteNote(Note note) async {
    await DatabaseHelper.instance.deleteNote(note.id!);
    _loadNotes();
  }

  List<Note> get _filteredNotes {
    List<Note> filtered = _notes.where((note) {
      return note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note.content.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();

    // Sort the filtered notes: pinned notes first, then by ID (most recent first)
    filtered.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.id!.compareTo(a.id!);
    });

    return filtered;
  }

  List<Note> get _filteredPinnedNotes {
    return _filteredNotes.where((note) => note.isPinned).toList();
  }

  List<Note> get _filteredUnpinnedNotes {
    return _filteredNotes.where((note) => !note.isPinned).toList();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.archive),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArchivedNotesScreen(
                    onNoteUnarchived: () {
                      _loadNotes();
                    },
                  ),
                ),
              );
              _loadNotes();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    isDarkMode: widget.isDarkMode,
                    toggleDarkMode: widget.toggleDarkMode,
                    changeLanguage: widget.changeLanguage,
                    currentLanguage: widget.currentLanguage,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: localizations.search,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (_filteredPinnedNotes.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(localizations.pinnedNotes, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ..._filteredPinnedNotes.map((note) => _buildNoteListTile(note)),
                  const Divider(),
                ],
                if (_filteredUnpinnedNotes.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(localizations.otherNotes, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ..._filteredUnpinnedNotes.map((note) => _buildNoteListTile(note)),
                ],
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditNote(),
        tooltip: localizations.addNote,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNoteListTile(Note note) {
    final localizations = AppLocalizations.of(context)!;
    String localizedCategory = _getLocalizedCategory(note.categoryKey, localizations);
    
    return ListTile(
      title: Text(note.title),
      subtitle: Text('${localizations.category}: $localizedCategory'),
      leading: note.isPinned ? const Icon(Icons.push_pin) : null,
      trailing: note.isLocked ? const Icon(Icons.lock) : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => detail.NoteDetailScreen(
              note: note,
              onEdit: (editedNote) {
                setState(() {
                  final noteIndex = _notes.indexWhere((n) => n.id == editedNote.id);
                  if (noteIndex != -1) {
                    _notes[noteIndex] = editedNote;
                  }
                });
                _loadNotes(); // Reload notes to reflect changes
              },
              onDelete: () {
                setState(() {
                  _notes.removeWhere((n) => n.id == note.id);
                });
                _deleteNote(note);
              },
              onArchiveStatusChanged: (isArchived) {
                setState(() {
                  if (isArchived) {
                    _notes.removeWhere((n) => n.id == note.id);
                  }
                });
                _loadNotes();
              },
            ),
          ),
        );
      },
    );
  }

  String _getLocalizedCategory(String categoryKey, AppLocalizations localizations) {
    switch (categoryKey) {
      case 'work':
        return localizations.categoryWork;
      case 'personal':
        return localizations.categoryPersonal;
      case 'ideas':
        return localizations.categoryIdeas;
      case 'todo':
        return localizations.categoryToDo;
      default:
        return categoryKey;
    }
  }
}

class Note {
  int? id;
  String title;
  String content;
  String categoryKey; // This should be 'work', 'personal', 'ideas', or 'todo'
  bool isArchived;
  bool isPinned;
  List<String> tags;
  bool isLocked;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.categoryKey,
    this.isArchived = false,
    this.isPinned = false,
    this.tags = const [],
    this.isLocked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': categoryKey,
      'isArchived': isArchived ? 1 : 0,
      'isPinned': isPinned ? 1 : 0,
      'tags': jsonEncode(tags),
      'isLocked': isLocked ? 1 : 0,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      categoryKey: map['category'] as String,
      isArchived: map['isArchived'] == 1,
      isPinned: map['isPinned'] == 1,
      tags: List<String>.from(jsonDecode(map['tags'])),
      isLocked: map['isLocked'] == 1,
    );
  }
}
