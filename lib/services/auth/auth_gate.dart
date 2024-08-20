

import 'package:chat_app/pages/HomePage.dart';
import 'package:chat_app/services/auth/loginOrRegister.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return  HomePage();
          } else {
            return  LoginOrRegister();
          }
        },
      ),
    );
  }
}
