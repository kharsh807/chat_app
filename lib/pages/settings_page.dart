import 'package:chat_app/pages/Blocked_users_page.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(top: 10, left: 25, right: 25),
            padding: const EdgeInsets.only(top: 16, bottom: 16, left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark Mode'),
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context).isDarkMode,  // Reflect the current theme mode
                  onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                  activeColor: Colors.blue,  // Set the active color to blue
                ),

              ],
            ),
          ),


          // blocked users

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(top: 10, left: 25, right: 25),
            padding: const EdgeInsets.only(top: 16, bottom: 16, left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Blocked Users'),

                // button to go to blocked user page
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  BlockedUsersPage())),
                ),

              ],
            ),
          ),
        ],
      ),


    );
  }
}