import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/notes_pages.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/pages/my_drawer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Chat and Auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),

        actions: [
          IconButton(
            icon: const Icon(Icons.note),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotesPage()),
              );
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getUserStreamExcludingBlocked(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Print the error message for debugging
          print("Error loading users: ${snapshot.error}");
          return const Center(child: Text("Error loading users"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print("No users available");
          return const Center(child: Text("No users available"));
        }

        // Debugging: print the data returned
        print('User data: ${snapshot.data}');

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    // Fetch current user's email
    final String currentUserEmail = _authService.getCurrentUser()!;

    // Display all users except current user
    if (userData['email'] != currentUserEmail) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          // Navigate to chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData['email'],
                receiverID: userData['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return const SizedBox.shrink(); // Return an empty widget
    }
  }
}
