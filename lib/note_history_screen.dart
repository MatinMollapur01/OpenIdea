import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:convert';
import 'database_helper.dart';
import 'main.dart';

class NoteHistoryScreen extends StatefulWidget {
  final Note currentNote;

  const NoteHistoryScreen({super.key, required this.currentNote});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note History'),
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

  const NoteHistoryDetailScreen({Key? key, required this.historyItem, required this.currentNote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                category: currentNote.category,
                isArchived: currentNote.isArchived,
                isPinned: currentNote.isPinned,
                tags: currentNote.tags,
                isLocked: currentNote.isLocked,
              );
              await DatabaseHelper.instance.updateNote(updatedNote);
              
              // Pop twice to return to the main screen
              Navigator.of(context).pop();
              Navigator.of(context).pop(updatedNote);
            },
            child: const Text('Restore'),
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