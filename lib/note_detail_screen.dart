import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'main.dart';
import 'add_edit_note_screen.dart';
import 'database_helper.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'note_history_screen.dart';

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
  final TextEditingController _passwordController = TextEditingController();
  late String _wordCount;
  late String _characterCount;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
    _quillController = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(_note.content)),
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
    );
    _updateStats();
  }

  void _updateStats() {
    final plainText = _quillController.document.toPlainText();
    _characterCount = plainText.length.toString();
    _wordCount = plainText.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length.toString();
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
                  tags: _note.tags,
                  isLocked: _note.isLocked,
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
          IconButton(
            icon: Icon(_note.isLocked ? Icons.lock : Icons.lock_open),
            onPressed: () => _toggleLock(context),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () async {
              final restoredNote = await Navigator.push<Note>(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteHistoryScreen(currentNote: _note),
                ),
              );
              if (restoredNote != null) {
                setState(() {
                  _note = restoredNote;
                  _quillController = quill.QuillController(
                    document: quill.Document.fromJson(jsonDecode(_note.content)),
                    selection: const TextSelection.collapsed(offset: 0),
                    readOnly: true,
                  );
                  _updateStats();
                });
                widget.onEdit(_note);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _note.isLocked ? _buildLockedView() : _buildNoteContent(),
          ),
          _buildStatsFooter(),
        ],
      ),
    );
  }

  Widget _buildLockedView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, size: 64, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: 16),
          Text('This note is locked', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _unlockNote(context),
            child: const Text('Unlock'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteContent() {
    return Container(
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
    );
  }

  Widget _buildStatsFooter() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Theme.of(context).colorScheme.surface,
      child: Text(
        'Words: $_wordCount | Characters: $_characterCount',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          fontSize: 12,
        ),
      ),
    );
  }

  void _toggleLock(BuildContext context) {
    if (_note.isLocked) {
      _unlockNote(context);
    } else {
      _lockNote(context);
    }
  }

  void _lockNote(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Password'),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Enter password'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _passwordController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Lock'),
              onPressed: () async {
                if (_passwordController.text.isNotEmpty) {
                  await _savePassword(_passwordController.text);
                  await DatabaseHelper.instance.updateNoteLockStatus(_note.id!, true);
                  setState(() {
                    _note = Note(
                      id: _note.id,
                      title: _note.title,
                      content: _note.content,
                      category: _note.category,
                      isArchived: _note.isArchived,
                      isPinned: _note.isPinned,
                      tags: _note.tags,
                      isLocked: true,
                    );
                  });
                  widget.onEdit(_note);
                  _passwordController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _unlockNote(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Password'),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Enter password'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _passwordController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Unlock'),
              onPressed: () async {
                if (await _verifyPassword(_passwordController.text)) {
                  await DatabaseHelper.instance.updateNoteLockStatus(_note.id!, false);
                  setState(() {
                    _note = Note(
                      id: _note.id,
                      title: _note.title,
                      content: _note.content,
                      category: _note.category,
                      isArchived: _note.isArchived,
                      isPinned: _note.isPinned,
                      tags: _note.tags,
                      isLocked: false,
                    );
                  });
                  widget.onEdit(_note);
                  _passwordController.clear();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incorrect password')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final hashedPassword = _hashPassword(password);
    await prefs.setString('note_${_note.id}_password', hashedPassword);
  }

  Future<bool> _verifyPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedHash = prefs.getString('note_${_note.id}_password');
    final inputHash = _hashPassword(password);
    return storedHash == inputHash;
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
