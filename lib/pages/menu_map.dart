import 'package:flutter/material.dart';

class MenuMapa extends StatefulWidget {
  const MenuMapa({super.key});

  @override
  State<MenuMapa> createState() => _MenuMapaState();
}

class _MenuMapaState extends State<MenuMapa> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          Image(
            image: AssetImage('images/planta_baixa_zero.jpg'),
          ),
        ],
      ),
    );
  }
}
