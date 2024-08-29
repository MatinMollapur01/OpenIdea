import 'package:flutter/material.dart';
import 'main.dart';
import 'note_detail_screen.dart';
import 'database_helper.dart';

class ArchivedNotesScreen extends StatefulWidget {
  final Function onNoteUnarchived;

  const ArchivedNotesScreen({Key? key, required this.onNoteUnarchived}) : super(key: key);

  @override
  _ArchivedNotesScreenState createState() => _ArchivedNotesScreenState();
}

class _ArchivedNotesScreenState extends State<ArchivedNotesScreen> {
  List<Note> _archivedNotes = [];

  @override
  void initState() {
    super.initState();
    _loadArchivedNotes();
  }

  void _loadArchivedNotes() async {
    List<Note> notes = await DatabaseHelper.instance.getNotes();
    setState(() {
      _archivedNotes = notes.where((note) => note.isArchived).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived Notes'),
      ),
      body: ListView.builder(
        itemCount: _archivedNotes.length,
        itemBuilder: (context, index) {
          final note = _archivedNotes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text('Category: ${note.category}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteDetailScreen(
                    note: note,
                    onEdit: (editedNote) {
                      // This should not be called for archived notes
                    },
                    onDelete: () {
                      // Optionally implement delete functionality for archived notes
                    },
                    onArchiveStatusChanged: (isArchived) async {
                      if (!isArchived) {
                        await DatabaseHelper.instance.updateNoteArchiveStatus(note.id!, false);
                        setState(() {
                          _archivedNotes.removeWhere((n) => n.id == note.id);
                        });
                        widget.onNoteUnarchived();
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}