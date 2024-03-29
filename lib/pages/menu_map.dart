import 'package:flutter/material.dart';

class MenuMapa extends StatefulWidget {
  const MenuMapa({super.key});

  @override
  State<MenuMapa> createState() => _MenuMapaState();
}

class _MenuMapaState extends State<MenuMapa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('M'),
      ),
    );
  }
}
