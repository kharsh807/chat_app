import 'package:chat_app/pages/notes_pages.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // logo
              DrawerHeader(
                child: Center(
                  child: Image.asset(
                    'lib/assets/khimg.jpeg', // Path to your image asset
                    height: 120, // Adjust size as needed
                    width: 180,
                  ),
                ),
              ),
              // home
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: ListTile(
                  title: const Text('H O M E'),
                  leading: Icon(Icons.home),
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);
                    // navigate to home
                  },
                ),
              ),
              // settings
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: ListTile(
                  title: const Text('N O T E S'),
                  leading: Icon(Icons.note_alt_sharp),
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);
                    // navigate to settings
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotesPage(),
                      ),
                    );
                  },
                ),
              ),
              // notes
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: ListTile(
                  title: const Text('S E T T I N G S'),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);
                    // navigate to notes
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // logout
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: ListTile(
              title: const Text('L O G O U T'),
              leading: Icon(Icons.logout),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
