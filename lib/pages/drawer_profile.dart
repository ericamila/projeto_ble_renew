import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xFF008296)),
        title: const Text("Perfil"),
        foregroundColor: const Color(0xFFF9FDFE),
        backgroundColor: const Color(0xFF292935),
      ),
      body: ListView(children: []),
    );
  }
}
