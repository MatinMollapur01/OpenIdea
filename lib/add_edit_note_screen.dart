import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'main.dart';
import 'database_helper.dart';
import 'dart:convert';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? noteToEdit;

  const AddEditNoteScreen({super.key, this.noteToEdit});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  late TextEditingController _titleController;
  late quill.QuillController _contentController;
  late String _selectedCategory;
  final List<String> _categories = ['Work', 'Personal', 'Ideas', 'To-Do'];
  late TextEditingController _tagsController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.noteToEdit?.title ?? '');
    _contentController = quill.QuillController(
      document: widget.noteToEdit?.content != null
          ? quill.Document.fromJson(jsonDecode(widget.noteToEdit!.content))
          : quill.Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );
    _selectedCategory = widget.noteToEdit?.category ?? _categories[0];
    _tagsController = TextEditingController(text: widget.noteToEdit?.tags.join(', ') ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteToEdit == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: const OutlineInputBorder(),
                  fillColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  filled: true,
                ),
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(height: 16),
              CustomToolbar(_contentController),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: quill.QuillEditor(
                    controller: _contentController,
                    scrollController: ScrollController(),
                    focusNode: FocusNode(),
                    configurations: const quill.QuillEditorConfigurations(
                      scrollable: true,
                      autoFocus: false,
                      padding: EdgeInsets.zero,
                      expands: false,
                    ),
                  ),
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
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: const OutlineInputBorder(),
                  fillColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  filled: true,
                ),
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _tagsController,
                decoration: InputDecoration(
                  labelText: 'Tags (comma separated)',
                  border: const OutlineInputBorder(),
                  fillColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
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
                    content: jsonEncode(_contentController.document.toDelta().toJson()),
                    category: _selectedCategory,
                    isArchived: widget.noteToEdit?.isArchived ?? false,
                    isPinned: widget.noteToEdit?.isPinned ?? false,
                    tags: _tagsController.text.split(',').map((tag) => tag.trim()).toList(),
                  );
                  if (widget.noteToEdit == null) {
                    int id = await DatabaseHelper.instance.insertNote(note);
                    note.id = id;
                  } else {
                    await DatabaseHelper.instance.updateNote(note);
                  }
                  if (!mounted) return;
                  if (context.mounted) {
                    Navigator.pop(context, note);
                  }
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
    _tagsController.dispose();
    super.dispose();
  }
}

// CustomToolbar widget
class CustomToolbar extends StatelessWidget {
  final quill.QuillController controller;

  const CustomToolbar(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ToggleButtons(
            isSelected: [
              controller.getSelectionStyle().attributes.containsKey(quill.Attribute.bold.key),
              controller.getSelectionStyle().attributes.containsKey(quill.Attribute.italic.key),
              controller.getSelectionStyle().attributes.containsKey(quill.Attribute.underline.key),
              controller.getSelectionStyle().attributes.containsKey(quill.Attribute.strikeThrough.key),
            ],
            onPressed: (int index) {
              switch (index) {
                case 0:
                  _toggleAttribute(quill.Attribute.bold);
                  break;
                case 1:
                  _toggleAttribute(quill.Attribute.italic);
                  break;
                case 2:
                  _toggleAttribute(quill.Attribute.underline);
                  break;
                case 3:
                  _toggleAttribute(quill.Attribute.strikeThrough);
                  break;
              }
            },
            children: const [
              Icon(Icons.format_bold),
              Icon(Icons.format_italic),
              Icon(Icons.format_underline),
              Icon(Icons.format_strikethrough),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.format_list_bulleted),
            onPressed: () => _toggleAttribute(quill.Attribute.ul),
          ),
          IconButton(
            icon: const Icon(Icons.format_list_numbered),
            onPressed: () => _toggleAttribute(quill.Attribute.ol),
          ),
          IconButton(
            icon: const Icon(Icons.format_quote),
            onPressed: () => _toggleAttribute(quill.Attribute.blockQuote),
          ),
          IconButton(
            icon: const Icon(Icons.code),
            onPressed: () => _toggleAttribute(quill.Attribute.codeBlock),
          ),
          IconButton(
            icon: const Icon(Icons.format_size),
            onPressed: () => _toggleAttribute(quill.Attribute.h1),
          ),
          IconButton(
            icon: const Icon(Icons.format_color_text),
            onPressed: () => _showColorPicker(context),
          ),
          IconButton(
            icon: const Icon(Icons.format_color_fill),
            onPressed: () => _showBackgroundColorPicker(context),
          ),
          IconButton(
            icon: const Icon(Icons.format_align_left),
            onPressed: () => _toggleAttribute(quill.Attribute.leftAlignment),
          ),
          IconButton(
            icon: const Icon(Icons.format_align_center),
            onPressed: () => _toggleAttribute(quill.Attribute.centerAlignment),
          ),
        ],
      ),
    );
  }

  void _toggleAttribute(quill.Attribute attribute) {
    if (controller.getSelectionStyle().attributes.containsKey(attribute.key)) {
      controller.formatSelection(quill.Attribute.clone(attribute, null));
    } else {
      controller.formatSelection(attribute);
    }
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: Colors.black,
              onColorChanged: (Color color) {
                final colorString = color.value.toRadixString(16).substring(2, 8);
                controller.formatSelection(quill.ColorAttribute('#$colorString'));
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Remove Color'),
              onPressed: () {
                controller.formatSelection(const quill.ColorAttribute(null));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showBackgroundColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a background color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: Colors.white,
              onColorChanged: (Color color) {
                final colorString = color.value.toRadixString(16).substring(2, 8);
                controller.formatSelection(quill.BackgroundAttribute('#$colorString'));
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Remove Background Color'),
              onPressed: () {
                controller.formatSelection(const quill.BackgroundAttribute(null));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
