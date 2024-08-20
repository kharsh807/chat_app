import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ConfirmPasswordController =
  TextEditingController();

  RegisterPage({super.key, required this.onTap});

  //for login click
  final void Function()? onTap;

  void register(BuildContext context) {
    final auth = AuthService();

    if (passwordController.text == ConfirmPasswordController.text) {
      try {
        auth.registerWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Passwords don't match!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            const Icon(Icons.message, size: 60),

            //welecome back msg
            const Text(
              'Register Now!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            //email textfiled
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            //pw textfield
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: ConfirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: true,
            ),
            //login button
            const SizedBox(
              height: 25,
            ),
            MyButton(
              text: 'Register',
              onTap: () => register(context),
            ),
            const SizedBox(height: 25),
            //register now
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Already have an account?'),
              GestureDetector(
                  onTap: onTap,
                  child: const Text(' Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ))),
            ]),
          ],
        ),
      ),
    );
  }
}
