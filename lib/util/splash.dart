// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import '../main.dart';
import '../model/usuario.dart';
import 'app_cores.dart';
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.escuro,
              AppColors.claro,
              AppColors.claro,

            ],
          ),
        ),
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imagemLogo(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'CODELINK',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.carvao,
                  fontSize: 24,
                  letterSpacing: 2.5,
                ),
              ),
            ),
            asset == 'Conectado'
                ? Container(
                    constraints: BoxConstraints(maxWidth: 400),
                    margin: EdgeInsets.only(top: 8),
                    child: const LinearProgressIndicator(
                        color: AppColors.verde, minHeight: 7),
                  )
                : Container(
                    color: AppColors.verde,
                    child: wifiOff(mensagem: asset),
                  ),
          ],
        ),
      ),
    );
  }
}
