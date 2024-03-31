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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.grey[200],
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.grey[300],
                          // backgroundImage:
                          // imageFile != null ? FileImage(imageFile!) : null,
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: IconButton(
                            onPressed: (){},
                            //onPressed: _showOpcoesBottomSheet,
                            icon: Icon(
                              Icons.edit,
                              //PhosphorIcons.pencilSimple(),
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
