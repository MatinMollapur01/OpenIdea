import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:convert';
import 'database_helper.dart';
import 'main.dart';
import 'package:idea/gen_l10n/app_localizations.dart';

class NoteHistoryScreen extends StatefulWidget {
  final Note currentNote;
  final Function(Note) onNoteUpdated;

  const NoteHistoryScreen({
    Key? key,
    required this.currentNote,
    required this.onNoteUpdated,
  }) : super(key: key);

  @override
  State<NoteHistoryScreen> createState() => _NoteHistoryScreenState();
}

class _NoteHistoryScreenState extends State<NoteHistoryScreen> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final history = await DatabaseHelper.instance.getNoteHistory(widget.currentNote.id!);
    setState(() {
      _history = history;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.noteHistory),
      ),
      body: ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final historyItem = _history[index];
          return ListTile(
            title: Text(historyItem['title']),
            subtitle: Text(DateTime.fromMillisecondsSinceEpoch(historyItem['timestamp']).toString()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteHistoryDetailScreen(
                    historyItem: historyItem,
                    currentNote: widget.currentNote,
                    onNoteRestored: (restoredNote) {
                      widget.onNoteUpdated(restoredNote);
                      Navigator.pop(context); // Close the history screen
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

class NoteHistoryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> historyItem;
  final Note currentNote;
  final Function(Note) onNoteRestored;

  const NoteHistoryDetailScreen({
    Key? key,
    required this.historyItem,
    required this.currentNote,
    required this.onNoteRestored,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final quillController = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(historyItem['content'])),
      selection: const TextSelection.collapsed(offset: 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(historyItem['title']),
        actions: [
          TextButton(
            onPressed: () async {
              final updatedNote = Note(
                id: currentNote.id,
                title: historyItem['title'],
                content: historyItem['content'],
                categoryKey: currentNote.categoryKey,
                isArchived: currentNote.isArchived,
                isPinned: currentNote.isPinned,
                tags: currentNote.tags,
                isLocked: currentNote.isLocked,
              );
              await DatabaseHelper.instance.updateNote(updatedNote);
              onNoteRestored(updatedNote);
              Navigator.of(context).pop(); // Close the detail screen
            },
            child: Text(localizations.restore),
          ),
        ],
      ),
      body: quill.QuillEditor(
        controller: quillController,
        scrollController: ScrollController(),
        focusNode: FocusNode(),
        configurations: const quill.QuillEditorConfigurations(
          scrollable: true,
          autoFocus: false,
          expands: false,
          padding: EdgeInsets.zero,
          customStyles: quill.DefaultStyles(),
        ),
      ),
    );
  }
}