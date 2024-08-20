import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.text,required this.onTap});

final String text;
final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        padding:const EdgeInsets.all(25.0),
        margin:  const EdgeInsets.symmetric(horizontal: 40.0),
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }
}
