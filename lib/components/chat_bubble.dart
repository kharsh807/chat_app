import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/themes/theme_provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;

  ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId,
  });

  // Show options when the message is long pressed
  void _showOptions(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              // Report message
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('Report message'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  // Call the method to report the message
                  _reportMessage(context, messageId, userId);
                },
              ),
              // Block user
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Block user'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  // Call the method to block the user
                  _blockUser(context, userId);
                },
              ),
              // Cancel button
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Report the message
  void _reportMessage(BuildContext context, String messageId, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Report message'),
          content: const Text('Are you sure you want to report this message?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the method to report the message
                ChatService().reportUser(messageId, userId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message reported')),
                );
              },
              child: const Text('Report'),
            ),
          ],
        );
      },
    );
  }

  // Block the user
  void _blockUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Block user'),
          content: const Text('Are you sure you want to block this user?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the method to block the user
                ChatService().blockUser(userId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User blocked')),
                );
              },
              child: const Text('Block'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    Color currentUserColor = isDarkMode ? Color(0xff8674fe) : Colors.green;
    Color otherUserColor = isDarkMode ? Color(0xff343646) : Colors.grey;

    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          // Show options to block user or report message
          _showOptions(context, messageId, userId);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentUser ? currentUserColor : otherUserColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 25),
        child: Text(message),
      ),
    );
  }
}