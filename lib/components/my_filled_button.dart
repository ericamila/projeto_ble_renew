import 'package:flutter/material.dart';

class MyFlilledButton extends StatelessWidget {
  final Color? cor;
  final Function()? onPressed;
  final String text;

  const MyFlilledButton(
      {super.key, required this.onPressed, required this.text, this.cor});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        style: FilledButton.styleFrom(backgroundColor: cor),
        onPressed: onPressed,
        child: Text(text));
  }
}
