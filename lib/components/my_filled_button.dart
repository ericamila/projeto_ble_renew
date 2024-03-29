import 'package:flutter/material.dart';

class MyFlilledButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;

  const MyFlilledButton(
      {super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        onPressed: onPressed,
        child: Text(text));
  }
}
