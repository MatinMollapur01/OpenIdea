import 'package:flutter/material.dart';
import 'package:idea/database_helper.dart';
import 'add_edit_note_screen.dart';
import 'note_detail_screen.dart';
import 'settings_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'archived_notes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkModePreference();
  }

  void _loadDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  void toggleDarkMode(bool value) async {
    setState(() {
      _isDarkMode = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
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
      home: IdeaHomePage(title: 'Idea - Note Taking App', isDarkMode: _isDarkMode, toggleDarkMode: toggleDarkMode),
    );
  }
}

class Note {
  int? id;
  String title;
  String content;
  String category;
  bool isArchived;
  bool isPinned;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    this.isArchived = false,
    this.isPinned = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'isArchived': isArchived ? 1 : 0,
      'isPinned': isPinned ? 1 : 0,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      category: map['category'] as String,
      isArchived: map['isArchived'] == 1,
      isPinned: map['isPinned'] == 1,
    );
  }
}

class IdeaHomePage extends StatefulWidget {
  const IdeaHomePage({super.key, required this.title, required this.isDarkMode, required this.toggleDarkMode});

  final String title;
  final bool isDarkMode;
  final Function(bool) toggleDarkMode;

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
        builder: (context) => AddEditNoteScreen(noteToEdit: noteToEdit),
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
          note.content.toLowerCase().contains(_searchQuery.toLowerCase());
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
              _loadNotes(); // Refresh notes when returning from ArchivedNotesScreen
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      isDarkMode: widget.isDarkMode,
                      toggleDarkMode: widget.toggleDarkMode,
                    ),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice.toLowerCase(),
                  child: Text(choice),
                );
              }).toList();
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
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (_filteredPinnedNotes.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Pinned Notes', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ..._filteredPinnedNotes.map((note) => _buildNoteListTile(note)),
                  const Divider(),
                ],
                if (_filteredUnpinnedNotes.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Other Notes', style: TextStyle(fontWeight: FontWeight.bold)),
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
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNoteListTile(Note note) {
    return ListTile(
      title: Text(note.title),
      subtitle: Text('Category: ${note.category}'),
      leading: note.isPinned ? const Icon(Icons.push_pin) : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteDetailScreen(
              note: note,
              onEdit: (editedNote) {
                setState(() {
                  final noteIndex = _notes.indexWhere((n) => n.id == editedNote.id);
                  if (noteIndex != -1) {
                    _notes[noteIndex] = editedNote;
                  }
                });
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
}

