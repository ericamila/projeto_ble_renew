// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import '../main.dart';
import '../model/usuario.dart';
import 'banco.dart';
import 'constants.dart';

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
      LoggedUser.usuarioLogado =
          await UsuarioDao().findUUID(LoggedUser.userLogado!.id);

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = ConnectionNotifier.of(context).value;
    final asset =
        hasConnection ? 'Conectado' : 'Verifique sua conexão com a Internet';
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: imagemLogo()),
          ),
          Center(
            child: asset == 'Conectado'
                ? const Text("Carregando...")
                : wifiOff(mensagem: asset),
          ),
        ],
      ),
    );
  }
}
