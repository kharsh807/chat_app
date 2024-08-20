import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/services/notes_service.dart';

class NotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NotesService notesService = Provider.of<NotesService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: notesService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading notes"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No notes available"));
          }

          final notes = snapshot.data!;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note['title']),
                subtitle: Text(note['content']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, note['id'], notesService);
                  },
                ),
                onTap: () {
                  _showEditNoteDialog(
                      context, note['id'], note['title'], note['content']);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNoteDialog(context);
        },
        child: const Icon(Icons.add,color: Color(0xff1f1f1f),),
        backgroundColor: Theme.of(context).colorScheme.secondary, // Set the color here
        tooltip: 'Add Note',
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = titleController.text.trim();
                final content = contentController.text.trim();

                if (title.isNotEmpty && content.isNotEmpty) {
                  final notesService = Provider.of<NotesService>(context, listen: false);
                  notesService.addNote(title, content);
                }

                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditNoteDialog(BuildContext context, String noteId, String title, String content) {
    final TextEditingController titleController = TextEditingController(text: title);
    final TextEditingController contentController = TextEditingController(text: content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newTitle = titleController.text.trim();
                final newContent = contentController.text.trim();

                if (newTitle.isNotEmpty && newContent.isNotEmpty) {
                  final notesService = Provider.of<NotesService>(context, listen: false);
                  notesService.updateNote(noteId, newTitle, newContent);
                }

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String noteId, NotesService notesService) {
    print("Delete request for note ID: $noteId");  // Debugging line

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                notesService.deleteNote(noteId);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
