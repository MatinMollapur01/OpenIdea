import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'main.dart';
import 'add_edit_note_screen.dart';
import 'database_helper.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'note_history_screen.dart';
import 'package:idea/gen_l10n/app_localizations.dart';

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
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_note.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final editedNote = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditNoteScreen(noteToEdit: _note),
                ),
              );
              if (editedNote != null) {
                setState(() {
                  _note = editedNote;
                  _quillController = quill.QuillController(
                    document: quill.Document.fromJson(jsonDecode(_note.content)),
                    selection: const TextSelection.collapsed(offset: 0),
                  );
                });
                widget.onEdit(_note);
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
                      title: Text(localizations.deleteNote),
                      content: Text(localizations.areYouSureDeleteNote),
                      actions: [
                        TextButton(
                          child: Text(localizations.cancel),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: Text(localizations.delete),
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
            icon: Icon(_note.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            onPressed: () async {
              await DatabaseHelper.instance.updateNotePinStatus(_note.id!, !_note.isPinned);
              setState(() {
                _note = Note(
                  id: _note.id,
                  title: _note.title,
                  content: _note.content,
                  categoryKey: _note.categoryKey,
                  isArchived: _note.isArchived,
                  isPinned: !_note.isPinned,
                  tags: _note.tags,
                  isLocked: _note.isLocked,
                );
              });
              widget.onEdit(_note);
            },
          ),
          IconButton(
            icon: Icon(_note.isLocked ? Icons.lock : Icons.lock_open),
            onPressed: () => _toggleLock(context),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteHistoryScreen(currentNote: _note),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildNoteContent()),
          _buildStatsFooter(),
        ],
      ),
    );
  }

  Widget _buildLockedView() {
    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, size: 64, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: 16),
          Text(localizations.thisNoteIsLocked, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _unlockNote(context),
            child: Text(localizations.unlock),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteContent() {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${localizations.category}: ${_note.categoryKey}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              '${localizations.tags}: ${_note.tags.join(', ')}',
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
    final localizations = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Theme.of(context).colorScheme.surface,
      child: Text(
        '${localizations.words}: $_wordCount | ${localizations.characters}: $_characterCount',
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
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.setPassword),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: localizations.enterPassword),
          ),
          actions: [
            TextButton(
              child: Text(localizations.cancel),
              onPressed: () {
                _passwordController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(localizations.unlock),
              onPressed: () async {
                if (_passwordController.text.isNotEmpty) {
                  await _savePassword(_passwordController.text);
                  await DatabaseHelper.instance.updateNoteLockStatus(_note.id!, true);
                  setState(() {
                    _note = Note(
                      id: _note.id,
                      title: _note.title,
                      content: _note.content,
                      categoryKey: _note.categoryKey,
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
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.enterPassword),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: localizations.enterPassword),
          ),
          actions: [
            TextButton(
              child: Text(localizations.cancel),
              onPressed: () {
                _passwordController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(localizations.unlock),
              onPressed: () async {
                if (await _verifyPassword(_passwordController.text)) {
                  await DatabaseHelper.instance.updateNoteLockStatus(_note.id!, false);
                  setState(() {
                    _note = Note(
                      id: _note.id,
                      title: _note.title,
                      content: _note.content,
                      categoryKey: _note.categoryKey,
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
                    SnackBar(content: Text(localizations.incorrectPassword)),
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
