import 'package:flutter/material.dart';
import 'main.dart';
import 'database_helper.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? noteToEdit;

  const AddEditNoteScreen({Key? key, this.noteToEdit}) : super(key: key);

  @override
  _AddEditNoteScreenState createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _selectedCategory;
  final List<String> _categories = ['Work', 'Personal', 'Ideas', 'To-Do'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.noteToEdit?.title ?? '');
    _contentController = TextEditingController(text: widget.noteToEdit?.content ?? '');
    _selectedCategory = widget.noteToEdit?.category ?? _categories[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteToEdit == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  fillColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  filled: true,
                ),
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                    fillColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                    filled: true,
                  ),
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  fillColor: Color(0x1A000000), // Use a constant color value
                  filled: true,
                ),
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final note = Note(
                    id: widget.noteToEdit?.id,
                    title: _titleController.text,
                    content: _contentController.text,
                    category: _selectedCategory,
                  );
                  if (widget.noteToEdit == null) {
                    int id = await DatabaseHelper.instance.insertNote(note);
                    note.id = id;
                  } else {
                    await DatabaseHelper.instance.updateNote(note);
                  }
                  Navigator.pop(context, note);
                },
                child: Text(widget.noteToEdit == null ? 'Add' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}