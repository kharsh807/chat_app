import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class NotesService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a new note for the current user
  Future<void> addNote(String title, String content) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final note = {
      'title': title,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('notes')
          .add(note);
      print("Note added: $title");
      notifyListeners();
    } catch (e) {
      print("Failed to add note: $e");
    }
  }

  // Stream to get all notes for the current user
  Stream<List<Map<String, dynamic>>> getNotesStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('notes')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => {
        'id': doc.id, // Add document ID to the map
        'title': doc['title'],
        'content': doc['content']
      }).toList();
    });
  }

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('notes')
          .doc(noteId)
          .delete();
      print("Note deleted: $noteId");
      notifyListeners();
    } catch (e) {
      print("Failed to delete note: $e");
    }
  }

  // Update a note
  Future<void> updateNote(String noteId, String title, String content) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final note = {
      'title': title,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('notes')
          .doc(noteId)
          .update(note);
      print("Note updated: $noteId");
      notifyListeners();
    } catch (e) {
      print("Failed to update note: $e");
    }
  }
}
