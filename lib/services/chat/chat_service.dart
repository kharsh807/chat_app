import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to get all users
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // Stream to get users excluding blocked users
  Stream<List<Map<String, dynamic>>> getUserStreamExcludingBlocked() {
    final currentUser = _auth.currentUser;

    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      final blockedUsersIds = snapshot.docs.map((doc) => doc.id).toList();

      final usersSnapshot = await _firestore.collection('users').get();

      // Exclude current user and blocked users
      return usersSnapshot.docs
          .where((doc) =>
      doc.data()['email'] != currentUser.email &&
          !blockedUsersIds.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

  // Send a message to another user
  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    try {
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toMap());
      print("Message sent successfully: ${newMessage.message}");
    } catch (e) {
      print("Failed to send message: $e");
    }
  }

  // Stream to get messages between two users
  Stream<QuerySnapshot> getMessages(String userID, String otherUserId) {
    List<String> ids = [userID, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Report a user for a specific message
  Future<void> reportUser(String messageId, String userId) async {
    final currentUser = _auth.currentUser;
    final report = {
      'messageOwnerId': userId,
      'messageId': messageId,
      'reportedBy': currentUser!.uid,
      'timestamp': Timestamp.now()
    };
    await _firestore.collection('reports').add(report);
  }

  // Block a user by adding their ID to the blockedUsers collection
  Future<void> blockUser(String userId) async {
    final currentUser = _auth.currentUser;
    final block = {
      'blockedUserId': userId,
      'blockedBy': currentUser!.uid,
      'timestamp': Timestamp.now()
    };
    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('blockedUsers')
        .doc(userId)
        .set({});
    notifyListeners();
  }
  Future<void> markMessagesAsRead(String chatRoomId, String userId) async {
    final unreadMessagesQuery = _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('receiverId', isEqualTo: userId)
        .where('read', isEqualTo: false);

    final unreadMessages = await unreadMessagesQuery.get();

    for (var doc in unreadMessages.docs) {
      doc.reference.update({'read': true});
    }
  }


  // Unblock a user by removing them from the blockedUsers collection
  Future<void> unblockUser(String userId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blockedUsers')
        .doc(userId)
        .delete();
  }

  // Stream to get all blocked users' IDs
  Stream<List<String>> getBlockedUsersStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('blockedUsers')
        .snapshots()
        .asyncMap((snapshot) async{
          //get list of blocked users id
          final blockedUserIds= snapshot.docs.map((doc) => doc.id);
          final userDocs= await Future.wait(
            blockedUserIds.map((id) => _firestore.collection('users').doc(id).get())
          );
          return snapshot.docs.map((doc) => doc.id).toList();
    });
  }



}
