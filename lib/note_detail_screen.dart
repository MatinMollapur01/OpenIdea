import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'main.dart';
import 'add_edit_note_screen.dart';
import 'database_helper.dart';
import 'dart:convert';

class NoteDetailScreen extends StatefulWidget {
  final Note note;
  final Function(Note) onEdit;
  final VoidCallback onDelete;
  final Function(bool) onArchiveStatusChanged;

  const NoteDetailScreen({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
    required this.onArchiveStatusChanged,
  });

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late Note _note;
  late quill.QuillController _quillController;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
    _quillController = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(_note.content)),
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_note.title),
        actions: [
          IconButton(
            icon: Icon(_note.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            onPressed: () async {
              await DatabaseHelper.instance.updateNotePinStatus(_note.id!, !_note.isPinned);
              setState(() {
                _note = Note(
                  id: _note.id,
                  title: _note.title,
                  content: _note.content,
                  category: _note.category,
                  isArchived: _note.isArchived,
                  isPinned: !_note.isPinned,
                );
              });
              widget.onEdit(_note);
            },
          ),
          if (!_note.isArchived)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final editedNote = await Navigator.push<Note>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditNoteScreen(noteToEdit: _note),
                  ),
                );
                if (editedNote != null) {
                  widget.onEdit(editedNote);
                }
              },
            ),
          IconButton(
            icon: Icon(_note.isArchived ? Icons.unarchive : Icons.archive),
            onPressed: () async {
              await DatabaseHelper.instance.updateNoteArchiveStatus(_note.id!, !_note.isArchived);
              widget.onArchiveStatusChanged(!_note.isArchived);
              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
          if (!_note.isArchived)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Delete Note"),
                      content: const Text("Are you sure you want to delete this note?"),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: const Text("Delete"),
                          onPressed: () async {
                            await DatabaseHelper.instance.deleteNote(_note.id!);
                            widget.onDelete();
                            if (mounted) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category: ${_note.category}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tags: ${_note.tags.join(', ')}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: quill.QuillEditor(
                  controller: _quillController,
                  scrollController: ScrollController(),
                  focusNode: FocusNode(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
