import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final FocusNode? focusNode;
  final TextEditingController controller;

  const MyTextField(
      {super.key,
      required this.hintText,
      this.obscureText = false,
      required this.controller,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
          controller: controller,
          obscureText: obscureText,
          focusNode: focusNode,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff8674fe),
              ),
            ),
            fillColor: Theme.of(context).colorScheme.background,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          )),
    );
  }
}
