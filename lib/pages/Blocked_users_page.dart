import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  BlockedUsersPage({super.key});

  // Confirm unblock box
  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Unblock User"),
        content: const Text("Are you sure you want to unblock this user?"),
        actions: [
          // Cancel
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          // Unblock
          TextButton(
            onPressed: () {
              chatService.unblockUser(userId); // Unblock the user
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User unblocked")),
              );
            },
            child: const Text("Unblock"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user ID from the AuthService
    final String? userId = authService.getCurrentUser();
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Blocked Users'),
        ),
        body: const Center(
          child: Text('No user logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked Users'),
      ),
      body: StreamBuilder<List<String>>(
        stream: chatService.getBlockedUsersStream(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading blocked users"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final blockedUserIds = snapshot.data ?? [];
          if (blockedUserIds.isEmpty) {
            return const Center(child: Text("No blocked users"));
          }

          // Fetch user details for the blocked users
          return FutureBuilder<List<DocumentSnapshot>>(
            future: Future.wait(blockedUserIds.map((id) =>
                FirebaseFirestore.instance.collection('users').doc(id).get())),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (userSnapshot.hasError) {
                return const Center(child: Text("Error loading user details"));
              }

              final userDocs = userSnapshot.data ?? [];
              return ListView.builder(
                itemCount: userDocs.length,
                itemBuilder: (context, index) {
                  final blockedUser = userDocs[index].data() as Map<String, dynamic>;
                  return UserTile(
                    text: blockedUser['email'], // Display the email of the blocked user
                    onTap: () => _showUnblockBox(context, userDocs[index].id),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
