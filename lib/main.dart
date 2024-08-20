import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/auth/auth_gate.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/services/notes_service.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Default to dark mode
  bool isDarkMode = true; // Set this to true to start with dark mode

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(isDarkMode: isDarkMode)),
        Provider(create: (context) => AuthService()),
        Provider(create: (context) => ChatService()),
        ChangeNotifierProvider(create: (_) => NotesService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),  // Use AuthGate to manage authentication flow
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
