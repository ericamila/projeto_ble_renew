import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final Color? cor;
  final Function()? onPressed;
  final String? text;

  const MyElevatedButton(
      {super.key, required this.onPressed, this.text, this.cor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          )),
      onPressed: onPressed,
      child: (text == null) ? const Icon(Icons.search) : Text(text!),
    );
  }
}
