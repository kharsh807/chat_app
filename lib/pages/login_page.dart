import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
  // Ensure this import is correct
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';


class LoginPage extends StatelessWidget {
  final void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // login method
  void login(BuildContext context) async {
    final authService = AuthService();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await authService.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Dismiss the loading dialog after successful login
      Navigator.pop(context); // Close the loading dialog

      // No need to navigate manually here if you're using AuthGate to handle navigation.
      // The StreamBuilder in AuthGate will detect the login state and show HomePage automatically.
    } catch (e) {
      Navigator.pop(context); // Close the loading dialog if there's an error

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            const Icon(Icons.message, size: 60),

            // welcome back msg
            const Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // email text field
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            // password text field
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 25),
            // login button
            MyButton(
              text: 'Login',
              onTap: () => login(context),
            ),
            const SizedBox(height: 25),
            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                GestureDetector(
                  onTap: onTap,
                  child: const Text(
                    ' Register Now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
