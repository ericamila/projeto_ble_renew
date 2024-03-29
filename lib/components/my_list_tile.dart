import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final Color? cor;
  final Color? tileCor;
  final IconData? icon;
  final IconData? trailing;
  final String text;
  final String? subText;
  final Function()? onTap;

  const MyListTile({
    super.key,
    this.icon,
    required this.text,
    this.subText,
    required this.onTap,
    this.trailing,
    this.cor,
    this.tileCor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListTile(
        tileColor: tileCor,
        leading: Icon(
          icon,
          size: 56,
          color: cor,
        ),
        onTap: onTap,
        title: Text(
          text,
          style: TextStyle(color: cor, fontWeight: FontWeight.bold),
        ),
        subtitle: (subText == null)
            ? null
            : Text(subText!),
        trailing: (trailing == null)
            ? null
            : Icon(
          trailing,
          size: 30,
          color: cor,
        ),
      ),
    );
  }
}
