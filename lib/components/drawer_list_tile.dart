import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final Color? cor = const Color(0xFFF9FDFE);
  final Color? tileCor;
  final IconData? icon;
  final IconData? trailing;
  final String text;
  final String? subText;
  final Function()? onTap;

  const DrawerListTile({
    super.key,
    this.icon,
    required this.text,
    this.subText,
    required this.onTap,
    this.trailing,
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
          size: 30,
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
