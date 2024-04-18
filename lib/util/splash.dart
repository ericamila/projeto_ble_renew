// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/pages/login_page.dart';
import '../model/usuario.dart';
import '../pages/home_page.dart';
import 'app_cores.dart';
import 'banco.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Check if user is logged in
    _verificarUsuarioLogado();
  }

  Future<void> _verificarUsuarioLogado() async {
    // ignore: await_only_futures
    LoggedUser.userLogado = await supabase.auth.currentUser;

    if (LoggedUser.userLogado?.id != null) {
      LoggedUser.usuarioLogado = await UsuarioDao().findUUID(
          LoggedUser.userLogado!.id);

      print("Usuario L O G A D O ${LoggedUser.usuarioLogado?.id} \n ${LoggedUser
          .usuarioLogado?.uid}");
      print("User L O G A D O ${LoggedUser.userLogado?.id}");

      Navigator.pushReplacementNamed(context, '/home');
    }
    else{
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child:
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.asset(
                'images/codelink_alt.png',
                height: 96,
                color: verde,
              ),
            ),
          ),
          const Center(
            child: Text("Carregando..."),
          ),
        ],
      ),
    );
  }
}
